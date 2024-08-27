//
//  WeightDetail.swift
//  FoodDeliveryAdmin
//
//  Created by Pascal Allekotte on 27.08.24.
//

import SwiftUI

struct WeightDetail: View {
    @StateObject private var viewModel = ProductViewModel()
    @State var meatProduct: ProductMeatModel
    
    @State private var newTag: String = ""
    
    let categories = ["Lamm", "Rind", "drinks", "Alkoholfrei", "Gewürze", "Geflügel", "Grillen", "Alkoholisch"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Header
                    HStack {
                        Text("Produkt bearbeiten")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(6)
                            .padding(.top, -20)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    
                    // Produktname und Beschreibung
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Produktname")
                            .font(.headline)
                        TextField("Produktname eingeben", text: $meatProduct.productName)
                            .textFieldStyle()

                        Text("Beschreibung")
                            .font(.headline)
                        TextField("Beschreibung eingeben", text: $meatProduct.description)
                            .textFieldStyle()
                    }
                    .padding(.horizontal)
                    
                    // Preis und Kategorienauswahl
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Preis")
                                .font(.headline)
                            TextField("Preis eingeben", text: $meatProduct.price)
                                .textFieldStyle()
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Kategorie")
                                .font(.headline)
                               

                            Picker("Kategorie auswählen", selection: Binding(
                                get: { meatProduct.category ?? categories.first! },
                                set: { meatProduct.category = $0 }
                            )) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category).tag(category as String?)
                                        .foregroundStyle(.black)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(height: 50)
                         
                            .padding(.horizontal, 10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MagicBlue"), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Auswahlfelder und Rabattoptionen
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Optionen")
                            .font(.headline)
                            
                        TextField("Auswahl 1", text: $meatProduct.vauswahl1)
                            .textFieldStyle()

                        TextField("Auswahl 2", text: $meatProduct.vauswahl2)
                            .textFieldStyle()
                        
                        Toggle("Rabatt", isOn: $meatProduct.discount)
                            .padding(.horizontal, 10)
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MagicBlue"), lineWidth: 0.5)
                            )
                        
                        if meatProduct.discount {
                            TextField("Rabatt-Details", text: $meatProduct.discountDetail)
                                .textFieldStyle()
                        }
                        
                        Toggle("Favorit", isOn: $meatProduct.isFavorite)
                            .padding(.horizontal, 10)
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MagicBlue"), lineWidth: 0.5)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Tags hinzufügen
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Tags")
                            .font(.headline)
                            
                        
                        HStack {
                            TextField("Neuer Tag", text: $newTag)
                                .textFieldStyle()
                                .frame(height: 45)

                            Button(action: {
                                if !newTag.isEmpty {
                                    meatProduct.hTags?.append(newTag)
                                    newTag = ""
                                }
                            }) {
                                Text("Hinzufügen")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                    .bold()
                                    .background(Color("MagicBlue"))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 1)

                            }
                            .disabled(newTag.isEmpty)
                        }
                        
                        // Anzeige der hinzugefügten Tags
                        if let hTags = meatProduct.hTags, !hTags.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(hTags, id: \.self) { tag in
                                    HStack {
                                        Text(tag)
                                        Spacer()
                                        Button(action: {
                                            if let index = meatProduct.hTags?.firstIndex(of: tag) {
                                                meatProduct.hTags?.remove(at: index)
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color("MagicBlue").opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Speichern Button
                    Button(action: {
                        if let category = meatProduct.category, !category.isEmpty {
                            viewModel.updateMeatProduct(meatProduct)
                        } else {
                            print("Kategorie ist nicht ausgewählt oder leer")
                        }
                    }) {
                        Text("Speichern")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color("MagicBlue"))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal)
                            .shadow(radius: 1)

                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    WeightDetail(meatProduct: ProductMeatModel(
        id: UUID().uuidString,
        description: "Beispielbeschreibung",
        imageURL: "https://storage.googleapis.com/appshop-691f3.appspot.com/MeatNow.png",
        price: "19.99",
        productName: "Beispielprodukt",
        vauswahl1: "Option 1",
        vauswahl2: "Option 2",
        discount: false,
        discountDetail: "",
        isFavorite: false,
        category: "Lamm",
        hTags: ["Tag1", "Tag2"]
    ))
}
