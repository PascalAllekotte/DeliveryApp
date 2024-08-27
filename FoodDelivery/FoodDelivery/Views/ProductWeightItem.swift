//
//  ProductWeightDetail.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 01.07.24.
//

import SwiftUI
import FirebaseAnalytics

struct ProductWeightItem: View {
    // MARK: VARIABLES -
    @State private var hinzugefuegt: Bool = false
    @State private var anzahl: Int = 1
    @State private var gramm: Double = 75
    @State private var berechneterPreis: Double = 0.0
    @State private var isFavorite: Bool = false
    
    var product: ProductMeatModel
    @ObservedObject var viewModel: ProductViewModel
    @EnvironmentObject var authViewModel: AuthViewModel // user favorite
    @EnvironmentObject var cartViewModel: CartViewModel // cart
     
    var preisProGramm: Double {
        let preisProKg = Double(product.price.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "€", with: "")) ?? 0.0
        return preisProKg / 1000
    }

    var body: some View {
        ZStack {
            Color("produkt")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    hideKeyboard()
                }

            VStack(spacing: 10) {
                ZStack {
                    if let imageUrl = URL(string: product.imageURL) {
                        AsyncImage(
                            url: imageUrl,
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            },
                            placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        )
                        .frame(width: 180, height: 110)
                        .shadow(radius: 5)
                        .background(Color("produkt"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    } else {
                        Color.gray
                            .frame(width: 150, height: 100)
                            .background(Color("produkt"))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    NavigationLink(destination: ProductWeightDetail(produkt: product)) {
                        Color.clear
                    }
                    
                    if product.discount {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("-\(product.discountDetail)%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(5)
                                    .background(Color.red)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(.top, 5)
                                    .padding(.trailing, 5)
                            }
                        }
                    }
                }
                
                VStack {
                    ZStack {
                        HStack {
                            Text(product.productName)
                                .bold()
                                .font(.subheadline)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, -8)
                            Spacer()
                            Text(String(format: "%.2f €", berechneterPreis))
                                .bold()
                                .font(.subheadline)
                        }
                        .padding([.leading, .bottom], 5)

                        NavigationLink(destination: ProductWeightDetail(produkt: product)) {
                            Color.clear
                        }

                        HStack {
                            Spacer()
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(isFavorite ? .black.opacity(0.6) : Color("addfarbe2"))
                            Spacer()
                        }
                        .padding(.top, -30)
                    }

                    ForEach(cartViewModel.getEntries(for: product.id ?? "").indices, id: \.self) { index in
                        HStack {
                            Button(action: {
                                cartViewModel.removeEntry(for: product.id ?? "", at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 5)
                            Text("\(Int(cartViewModel.getEntries(for: product.id ?? "")[index].gramm))g")
                                .font(.subheadline)
                                .padding(.leading, 5)
                            Spacer()
                            Text(String(format: "%.2f €", cartViewModel.getEntries(for: product.id ?? "")[index].preis))
                                .font(.subheadline)
                                .padding(.trailing, 5)
                        }
                        .padding([.bottom], 5)
                    }

                    HStack {
                        Text("\(Int(gramm)) g")
                            .font(.subheadline)
                        
                        Slider(value: $gramm, in: 75...1000, step: 25)
                            .padding()
                            .onChange(of: gramm) { _, newValue in
                                berechneterPreis = newValue * preisProGramm
                            }
                            .padding(.leading, -20)
                    }
                    .padding(.top, -20)

                    Spacer()

                    Button(action: {
                        if gramm > 0, let productId = product.id {
                            cartViewModel.addEntry(for: product, gramm: gramm, preis: berechneterPreis)
                            Analytics.logEvent("artikel_hinzugefuegt", parameters: ["anzahl": anzahl, "gramm": gramm, "preis": berechneterPreis])
                            gramm = 75
                            berechneterPreis = gramm * preisProGramm
                        }
                    }) {
                        Text("Hinzufügen")
                            .padding(5)
                            .background(Color("addfarbe2"))
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 1)
                    }
                    .padding(.top, -20)
                }
                .padding([.leading, .trailing, .bottom], 5)
            }
            .frame(width: 170)
        }
        .frame(width: 180, height: 240 + CGFloat(cartViewModel.getEntries(for: product.id ?? "").count * 40))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .onAppear {
            isFavorite = authViewModel.user?.favorites.contains(product.id ?? "") ?? false
        }
    }
}


#Preview {
   ProductWeightItem(
       product: ProductMeatModel(
           description: "Leckeres Rindfleisch",
           imageURL: "https://storage.googleapis.com/appshop-691f3.appspot.com/goho.png",
           price: "10,00€", // Preis pro Kilogramm
           productName: "Beef",
           vauswahl1: "Option 1",
           vauswahl2: "Option 2",
           discount: true,
           discountDetail: "15",
           isFavorite: true,
           category: "Rind"
       ),
       viewModel: ProductViewModel()
   )
   .environmentObject(AuthViewModel())
   .environmentObject(CartViewModel())
}

