//
//  Getraenke.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct Getraenke: View {
    var body: some View {
        Grid {
            GridRow {
                NavigationLink(destination: DetailViewProduct(selectedItem: "Alkoholfrei")) {
                    ItemViewBild(title: "Alkoholfrei", backgroundImageName: "getraenke")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
                
                NavigationLink(destination: DetailViewProduct(selectedItem: "Alkoholisch")) {
                    ItemViewBild(title: "Alkoholisch", backgroundImageName: "mit")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

#Preview {
    Getraenke()
}

