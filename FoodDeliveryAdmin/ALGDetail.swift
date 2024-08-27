//
//  ALGDetail.swift
//  FoodDeliveryAdmin
//
//  Created by Pascal Allekotte on 27.08.24.
//

import SwiftUI

struct ALGDetailView: View {
    @StateObject var productViewModel = ProductViewModel()
    
    @State var product: ProductModel
    
    @State private var newTag = ""
    
    let categories = ["Lamm", "Rind", "drinks", "Alkoholfrei", "Gewürze", "Geflügel", "Grillen", "Alkoholisch"]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                // ------------------- DESCRIPTION AND PRODUCTNAME -------------------
                VStack{
                    HStack{
                        Text("Produkt bearbeiten")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(6)
                            .padding(.top, -10)
                            
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Produktname")
                            .font(.headline)
                        TextField("Produkt Name", text: $product.productName)
                            .textFieldStyle()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Beschreibung")
                            .font(.headline)
                        TextField("Beschreibung eingeben", text: $product.description)
                            .textFieldStyle()
                    }
                    .padding(.horizontal)
                    
                    // ------------------- PRICE AND CATEGORY -------------------
                    HStack(spacing: 10){
                        VStack(alignment: .leading, spacing: 5){
                            Text("Preis")
                                .font(.headline)
                            TextField("Preis eingeben", text: $product.price)
                                .textFieldStyle()
                        }
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("Kategorie")
                                .font(.headline)
                            
                            Picker("Kategorie", selection: Binding(
                                get: { product.category ?? categories.first! },
                                set: { product.category = $0 }
                            )) {
                                ForEach(categories, id: \.self){ category in
                                    Text(category).tag(category as String?)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(height: 50)
                            .padding(.horizontal, 10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MagicBlue"), lineWidth: 0.5)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // ------------------- OPTIONS -------------------
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Optionen")
                            .font(.headline)
                        TextField("Anzahl + k. Beschreibung", text: $product.quantity)
                            .textFieldStyle()
                        TextField("ml", text: $product.ml)
                            .textFieldStyle()
                        
                        Toggle("Favorite", isOn: $product.isFavorite)
                            .padding(.horizontal, 10)
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MagicBlue"), lineWidth: 0.5)
                            )
                        Toggle("Rabatt", isOn: $product.discount)
                            .padding(.horizontal, 10)
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MagicBlue"), lineWidth: 0.5)
                            )
                        if product.discount {
                            TextField("Rabatt Details", text: $product.discountDetail)
                                .textFieldStyle()
                        }
                        
                        // ------------------- TAGS -------------------
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Tags")
                                .font(.headline)
                            HStack{
                                TextField("Neuer Tag", text: $newTag)
                                    .textFieldStyle()
                                    .frame(height: 45)
                                
                                Button(action: {
                                    if !newTag.isEmpty {
                                        product.hTags?.append(newTag)
                                        newTag = ""
                                    }
                                }) {
                                    Text("hinzufügen")
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
                            
                            if let hTags = product.hTags, !hTags.isEmpty {
                                VStack(alignment: .leading, spacing: 5){
                                    ForEach(hTags, id: \.self) { tag in
                                        HStack {
                                            Text(tag)
                                            Spacer()
                                            Button(action: {
                                                if let index = product.hTags?.firstIndex(of: tag) {
                                                    product.hTags?.remove(at: index)
                                                }
                                            }) { Image(systemName: "trash")
                                                    .foregroundStyle(.black)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color("MagicBlue").opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            // Speichern Button
                            Button(action: {
                                if let category = product.category, !category.isEmpty {
                                    productViewModel.updateProduct(product)
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
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ALGDetailView(product: ProductModel(
        id: UUID().uuidString,
        imageURL: "https://storage.googleapis.com/appshop-691f3.appspot.com/MeatNow.png",
        ml: "500",
        price: "19.99",
        productName: "Beispielprodukt",
        discount: false,
        discountDetail: "",
        pfand: false,
        quantity: "1",
        hTags: ["Tag1", "Tag2"],
        category: "Lamm",
        description: "Eine detaillierte Beschreibung",
        isFavorite: false
    ))
}
