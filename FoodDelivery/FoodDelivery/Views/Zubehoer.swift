//
//  Zubehoer.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct Zubehoer: View {
    var body: some View {
        VStack{
            Grid {
                GridRow {
                    NavigationLink(destination: ProductWeightView(selectedItem: "Grillen | Kochen")) {
                        ItemViewBild(title: "Grillen | Kochen", backgroundImageName: "gundk")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                        
                    }
                    
                    NavigationLink(destination: ProductWeightView(selectedItem: "Gewürze")) {
                        ItemViewBild(title: "Gewürze", backgroundImageName: "gewürze")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 5)
            
        }
    }
}
    #Preview {
       Zubehoer()
    }
