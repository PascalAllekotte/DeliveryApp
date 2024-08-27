//
//  Fleisch.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct Fleisch: View {
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    NavigationLink(destination: ProductWeightView(selectedItem: "Rind")) {
                        ItemViewBild(title: "Rind", backgroundImageName: "Beef")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                    
                    NavigationLink(destination: ProductWeightView(selectedItem: "Lamm")) {
                        ItemViewBild(title: "Lamm", backgroundImageName: "Lamm")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                }
                
                GridRow {
                    NavigationLink(destination: ProductWeightView(selectedItem: "Geflügel")) {
                        ItemViewBild(title: "Geflügel", backgroundImageName: "Huhn")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                    
                    NavigationLink(destination: ProductWeightView(selectedItem: "Grillen")) {
                        ItemViewBild(title: "Grillen", backgroundImageName: "grillfleisch")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                }
            }
            .padding(.horizontal, 5) // Padding links und rechts
        }
    }
}

#Preview {
    Fleisch()
}
