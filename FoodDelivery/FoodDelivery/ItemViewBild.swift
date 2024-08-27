//
//  ItemViewBild.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct ItemViewBild: View {
    let title: String
    let backgroundImageName: String?
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                if let backgroundImageName = backgroundImageName {
                    Image(backgroundImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .clipped()
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                }
            }
            
            VStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .foregroundStyle(.black)
                        .padding(2)
                        .bold()
                        .background(Color("produkt"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.leading, 10)
                    Spacer()
                }
                Spacer()
            }
            .frame(height: 110)
        }
        .background(Color("produkt"))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(1)
    }
}

#Preview {
    ItemViewBild(title: "Lamm", backgroundImageName: "Lamm")
}
