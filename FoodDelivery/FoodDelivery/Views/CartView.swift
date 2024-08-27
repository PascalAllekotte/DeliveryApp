//  CartView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 05.08.24.
//

import SwiftUI

struct CartView: View {
    @State private var deliverySheet = false
    @State private var selectedDeliveryTime: String = ""
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Text("Bestellübersicht \(cartViewModel.totalitem()) Artikel")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    if cartViewModel.totalitem() > 0 {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(cartViewModel.gespeicherteEintraege.keys.sorted(), id: \.self) { key in
                                    if let entry = cartViewModel.gespeicherteEintraege[key] {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                if let imageUrl = URL(string: entry.productMeat?.imageURL ?? entry.product?.imageURL ?? "") {
                                                    AsyncImage(
                                                        url: imageUrl,
                                                        content: { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 50, height: 50)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        },
                                                        placeholder: {
                                                            Image(systemName: "photo")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 50, height: 50)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        }
                                                    )
                                                } else {
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                                
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(entry.productMeat?.productName ?? entry.product?.productName ?? "")
                                                            .font(.headline)
                                                        
                                                        Spacer()
                                                        
                                                        Button(action: {
                                                            cartViewModel.removeEntry(for: key)
                                                        }) {
                                                            Image(systemName: "xmark.circle.fill")
                                                                .foregroundStyle(.blue.opacity(0.5))
                                                        }
                                                    }
                                                    
                                                    if let productMeat = entry.productMeat {
                                                        Text("\(productMeat.price)/kg")
                                                            .font(.subheadline)
                                                            .foregroundStyle(.gray)
                                                    }
                                                    
                                                    if let product = entry.product {
                                                        Text(String(format: "Einzelpreis: %.2f €", Double(product.price.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "€", with: "")) ?? 0.0))
                                                            .font(.subheadline)
                                                            .foregroundStyle(.gray)
                                                        
                                                        if entry.pfand > 0 {
                                                            Text(String(format: "Pfand: %.2f €", entry.pfand))
                                                                .font(.subheadline)
                                                                .foregroundStyle(.gray)
                                                        }
                                                        
                                                        HStack {
                                                            HStack {
                                                                Button(action: {
                                                                    cartViewModel.decreaseQuantity(for: key)
                                                                }) {
                                                                    Image(systemName: "minus.circle")
                                                                        .foregroundColor(.blue.opacity(0.5))
                                                                }
                                                                
                                                                Text(" \(entry.quantity ?? 0) ")
                                                                    .font(.subheadline)
                                                                    .padding(.horizontal)
                                                                
                                                                Button(action: {
                                                                    cartViewModel.increaseQuantity(for: key)
                                                                }) {
                                                                    Image(systemName: "plus.circle")
                                                                        .foregroundStyle(.blue.opacity(0.5))
                                                                }
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            Text(String(format: "%.2f €", Double(entry.quantity ?? 0) * (Double(entry.product?.price ?? "0") ?? 0) + (entry.pfand * Double(entry.quantity ?? 0))))
                                                                .font(.subheadline)
                                                                .bold()
                                                        }
                                                        .padding(.top, 5)
                                                    }
                                                    
                                                    if let entries = entry.entries {
                                                        ForEach(entries.indices, id: \.self) { index in
                                                            HStack {
                                                                Text("\(Int(entries[index].gramm)) g")
                                                                    .font(.subheadline)
                                                                Spacer()
                                                                Text(String(format: "%.2f €", entries[index].preis))
                                                                    .font(.subheadline)
                                                                    .bold()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Divider()
                                        }
                                        .padding(.vertical, 5)
                                    }
                                }
                            }
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .background(Color("produkt").opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    else {
                        Text("Noch keine Artikel im Warenkorb.")
                    }
                }
                
                Spacer()
                
                // MARK: COST DELIVERY INFOSTACK
                VStack {
                    // Datum und Lieferzeit anzeigen
                    if !selectedDeliveryTime.isEmpty {
                        HStack {
                        
                            Text("Lieferzeit")
                                .bold()
                            Spacer()
                            
                            Button("\(selectedDeliveryTime)"){
                                deliverySheet.toggle()
                            }
                            .foregroundStyle(.black)
                            .padding(4)
                            .background(Color("produkt"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))


                            
                        }
                        .padding(.bottom, 5)
                    }
                    
                    // Zwischensumme
                    HStack {
                        Text("Zwischensumme")
                            .bold()
                        Spacer()
                        Text(String(format: "%.2f €", cartViewModel.calculateTotalPrice()))
                    }
                    
                    Divider()
                    
                    // Pfand
                    HStack {
                        Text("zzgl. Pfand")
                            .bold()
                        Spacer()
                        Text(String(format: "%.2f €", cartViewModel.calculateTotalPfand()))
                    }
                    
                    Divider()
                    
                    // Lieferkosten
                    HStack {
                        Text("Lieferung")
                            .bold()
                        Spacer()
                        Text("1.99 €")
                    }
                    
                    Divider()
                    
                    // Gesamtsumme
                    HStack {
                        Text("Gesamtsumme")
                            .bold()
                        Spacer()
                        Text(String(format: "%.2f €", cartViewModel.calculateTotalPrice() + cartViewModel.calculateTotalPfand() + 1.99))
                            .bold()
                    }
                    
                    // DeliverTime and Order Button in change
                    if selectedDeliveryTime.isEmpty {
                        Button("Lieferzeit wählen") {
                            deliverySheet.toggle()
                        }
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("produkt"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Button("Bestellen") {
                            deliverySheet.toggle()
                        }
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("produkt"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                        .padding()
                
                
            }
        }
        .sheet(isPresented: $deliverySheet) {
            DeliveryTimeView(selectedDeliveryTime: $selectedDeliveryTime)
            // .environmentObject(CartViewModel())
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
        .environmentObject(ProductViewModel())
}
