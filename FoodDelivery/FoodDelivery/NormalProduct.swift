//
//  NormalProduct.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 16.08.24.
//

import SwiftUI
import FirebaseAnalytics

struct NormalProduct: View {
    @State private var hinzugefuegt: Bool = false
    @State private var anzahl: Int = 0
    
    @ObservedObject var viewModel: ProductViewModel
    var product: ProductModel
    
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                ZStack {
                    Color("produkt").frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    VStack(spacing: 5) {
                        if let imageUrl = URL(string: product.imageURL) {
                            AsyncImage(
                                url: imageUrl,
                                content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .frame(width: 150, height: 100)
                                        .offset(y: hinzugefuegt ? -3 : 20)
                                    
                                },
                                placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .offset(y: hinzugefuegt ? -3 : 20)
                                }
                                
                            )
                            // Hier fügen wir das Rabattlabel als Overlay hinzu
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        if product.discount {
                                            Text("-\(product.discountDetail)%")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .padding(5)
                                                .background(Color.red)
                                                .foregroundStyle(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .padding(.top, 5)
                                                .padding(.trailing, 5)
                                                .offset(y: hinzugefuegt ? -3 : 20)

                                        }
                                    }
                                    Spacer()
                                }
                            )
                        } else {
                            Color.gray
                                .frame(width: 150, height: 100)
                                .background(Color("produkt"))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .offset(y: hinzugefuegt ? 40 : 0) // Hier auch die graue Platzhalterbox verschieben
                        }
                            
                        if hinzugefuegt {
                            HStack {
                                Button(action: {
                                    if anzahl > 1 {
                                        anzahl -= 1
                                        cartViewModel.addProduct(for: product, quantity: anzahl)
                                        Analytics.logEvent("anzahl_verringert", parameters: ["neue_anzahl": anzahl])
                                    } else {
                                        hinzugefuegt = false
                                        anzahl = 0
                                        cartViewModel.removeEntry(for: product.id ?? "", at: 0)
                                        Analytics.logEvent("artikel_entfernt", parameters: nil)
                                    }
                                }) {
                                    Text("-")
                                        .font(.headline)
                                        .padding(5)
                                        .background(Color("addfarbe2"))
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                .padding(.leading, 15)
                                
                                Spacer()
                                
                                Text("\(anzahl)")
                                    .font(.headline)
                                    .padding(5)
                                
                                Spacer()
                                
                                Button(action: {
                                    anzahl += 1
                                    cartViewModel.addProduct(for: product, quantity: anzahl)
                                    Analytics.logEvent("anzahl_erhoeht", parameters: ["neue_anzahl": anzahl])
                                }) {
                                    Text("+")
                                        .font(.headline)
                                        .padding(5)
                                        .background(Color("addfarbe2"))
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                .padding(.trailing, 15)
                            }
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        } else {
                            Button(action: {
                                hinzugefuegt = true
                                anzahl = 1
                                cartViewModel.addProduct(for: product, quantity: anzahl)
                                Analytics.logEvent("artikel_hinzugefuegt", parameters: ["anzahl": anzahl])
                            }) {
                                Text("Hinzufügen")
                                    .padding(5)
                                    .background(Color("addfarbe2"))
                                    .foregroundStyle(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                            .padding(.top, 50)
                            .padding(.bottom, 2)
                            .shadow(radius: 1)
                        }
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    let originalPrice = Double(product.price) ?? 0.0
                    let discount = Double(product.discountDetail) ?? 0.0
                    let discountedPrice = originalPrice - (originalPrice * discount / 100)
                    
                    if product.discount {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text(String(format: "%.0f", floor(discountedPrice)))
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .bold()
                            VStack {
                                Text(String(format: "%.2f", discountedPrice).dropFirst(String(format: "%.0f", floor(discountedPrice)).count))
                                    .font(.system(size: 10))
                                    .foregroundStyle(.black)
                                    .bold()
                                    .offset(y: -10) // Nachkommastellen nach oben versetzen
                            }
                        }
                        
                        Text("\(product.price) €")
                            .font(.system(size: 15))
                            .strikethrough()
                            .foregroundStyle(.gray)
                            .baselineOffset(8)
                    } else {
                        Text("\(product.price)€")
                            .font(.system(size: 20))
                            .bold()
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Text(product.productName)
                        .bold()
                        .font(.subheadline)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    if product.pfand {
                        Text("+0.25€ Pfand")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                
                if product.quantity.isEmpty{
                    HStack {
                        if let mlValue = Double(product.ml), let priceValue = Double(product.price) {
                            Text("\(convertMlToLitersString(mlValue)) · (\(calculatePricePerLiter(price: priceValue, ml: mlValue)))€ / 1 L")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding(.top, 2)
                        }
                        Spacer()
                    }
                } else {
                    HStack{
                        Text("\(product.quantity)")
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            anzahl = getProductQuantity(product)
            hinzugefuegt = anzahl > 0
        }
    }
    
    private func convertMlToLitersString(_ ml: Double) -> String {
        if ml >= 1000 {
            let liters = ml / 1000
            return String(format: "%.1f l", liters)
        } else {
            return String(format: "%.0f ml", ml)
        }
    }
    
    private func calculatePricePerLiter(price: Double, ml: Double) -> String {
        let liters = ml / 1000
        let pricePerLiter = price / liters
        return String(format: "%.2f", pricePerLiter)
    }
    
    private func getProductQuantity(_ product: ProductModel) -> Int {
        return cartViewModel.gespeicherteEintraege[product.id ?? ""]?.quantity ?? 0
    }
}

#Preview {
    NormalProduct(
        viewModel: ProductViewModel(),
        product: ProductModel(
            id: "1",
            imageURL: "https://storage.googleapis.com/appshop-691f3.appspot.com/drinks/Objekt.png",
            ml: "1500",
            price: "2.59",
            productName: "Coca-Cola 1.5 L",
            discount: true,
            discountDetail: "20",
            pfand: true,
            quantity: "1"
        )
    )
    .environmentObject(CartViewModel())
    .environmentObject(AuthViewModel())
}
