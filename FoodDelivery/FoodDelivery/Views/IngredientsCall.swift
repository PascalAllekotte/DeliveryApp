//
//  IngredientsCall.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 03.07.24.
//

import SwiftUI
import PhotosUI

struct IngredientsCall: View {
    
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @StateObject private var viewModel = TextAndImageRequestViewModel()
    @StateObject private var productViewModel = ProductViewModel() // Hinzugefügt für die Produktdarstellung
    //Ingredient
    
    
    var body: some View {
        
        
        ScrollView {
            HStack{
                Text("IngredientEye")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                Spacer()
            }
            VStack {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Foto vom Gericht:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            HStack {
                                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                                    Image("Menu")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 14)
                                        .padding(20)
                                        .background()
                                        .foregroundStyle(.white)
                                        .clipShape(Circle())
                                        .padding(.leading, 25)
                                        .shadow(radius: 5)
                                }
                                .onChange(of: photosPickerItem) { _, newItem in
                                    if let newItem = newItem {
                                        Task {
                                            do {
                                                if let data = try await newItem.loadTransferable(type: Data.self),
                                                   let uiImage = UIImage(data: data) {
                                                    self.image = uiImage
                                                    self.viewModel.image = uiImage // Bild im ViewModel speichern
                                                }
                                            } catch {
                                                print("Error loading the picture: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                        if let image = image {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .border(Color.black.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 5)
                                Button(action: {
                                    self.image = nil
                                    self.viewModel.image = nil // Bild im ViewModel entfernen
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.black)
                                        .padding(5)
                                }
                            }
                        }
                    }
                    
                    Button("Zutaten finden!") {
                        guard image != nil else { return } // Überprüfen, ob ein Bild vorhanden ist
                        Task {
                            viewModel.sendRequest() // Anfrage absenden
                            productViewModel.searchProductss(byTags: viewModel.ingredients) // Suche nach Produkten
                        }
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 2)
                }
                .frame(minWidth: 360)
                .padding(7)
                .background(Color("produkt"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                VStack{
                    if viewModel.isLoading {
                        ProgressView("☺︎☹︎☺︎☹︎☺︎☹︎☺︎☹︎☺︎☹︎")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if viewModel.ingredients.isEmpty{
                        Text("Um die Zutaten eines Gerichts zu finden, wähle einfach ein Foto aus deiner Galerie aus und klicke auf den Button. Die App analysiert das Bild, erkennt das Gericht und listet die zugehörigen Zutaten auf. Außerdem werden dir passende Produkte angezeigt, die du direkt in den Warenkorb packen kannst.")
                            .foregroundStyle(.gray)
                    }
                    
                    if !viewModel.detectedDishName.isEmpty {
                        Text("\(viewModel.detectedDishName)")
                            .font(.headline)
                        
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if !viewModel.ingredients.isEmpty {
                        Text("Zutaten:")
                            .font(.headline)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach(viewModel.ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .padding(.vertical, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    /*
                     Text("Zutaten im Laden gefunden: \(viewModel.firestoreIngredients.count)")
                     .font(.subheadline)
                     .padding(.top, 20)
                     .foregroundStyle(.gray)
                     .frame(maxWidth: .infinity, alignment: .leading)
                     */
                    
                    if !viewModel.firestoreIngredients.isEmpty {
                        Text("Zutaten vorrätig:")
                            .font(.headline)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach(viewModel.firestoreIngredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .padding(.vertical, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
                .background(Color("produkt").opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.top, -10)
                Spacer()
                
                
                
            }
            .padding()
            .padding(.top, -20)
            
            HStack{
                if !viewModel.foundProducts.isEmpty {
                    Text("Gefundene Produkte basierend auf Zutaten:")
                        .font(.headline)
                        .padding(7)
                        .padding(.trailing, 15)
                        .padding(.top, -30)
                    
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 1) {
                    ForEach(viewModel.foundMeatProducts.indices, id: \.self) { index in
                        ProductWeightItem(product: viewModel.foundMeatProducts[index], viewModel: productViewModel)
                            .padding(8)
                    }
                    ForEach(viewModel.foundProducts.indices, id: \.self) { index in
                        NormalProduct(viewModel: productViewModel, product: viewModel.foundProducts[index])
                            .padding(2)
                    }
                }
                .padding(.horizontal, 4)
            }
            Spacer()
            
            
            Spacer()
            
        }
    }
}

#Preview {
    IngredientsCall()
}
