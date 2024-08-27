//
//  Angebot.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct Angebot: View {
    var product: ProductMeatModel

    var body: some View {
        NavigationLink(destination: ProductWeightDetail(produkt: product)) {
            ZStack(alignment: .topLeading) {
                VStack {
                    ZStack(alignment: .topLeading) {
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
                            .frame(width: 150, height: 60)
                            .shadow(radius: 5)
                            .background(Color("angebot"))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        } else {
                            Color.gray
                                .frame(width: 150, height: 100)
                                .background(Color("angebot"))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                   
                    Text(product.productName)
                        .bold()
                        .font(.subheadline)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.leading, .trailing], 5)
                        .padding(.top, -10)
                }
                .frame(minWidth: 100, minHeight: 80)
                .background(Color("angebot"))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(2)
                
                Text("-\(product.discountDetail)%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .rotationEffect(.degrees(-30))
                    .offset(x: -6, y: 3)
            }
        }
        .buttonStyle(PlainButtonStyle()) // Entfernt den blauen Highlight-Effekt des NavigationLinks
    }
}

#Preview {
    Angebot(product: ProductMeatModel(
        description: "Leckeres Rindfleisch",
        imageURL: "https://storage.googleapis.com/appshop-691f3.appspot.com/goho.png",
        price: "10,00€",
        productName: "Beef",
        vauswahl1: "Option 1",
        vauswahl2: "Option 2",
        discount: true,
        discountDetail: "15",
        isFavorite: true,
        category: "Rind"
    ))
}
