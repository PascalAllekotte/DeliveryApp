//
//  Producte anzeigen test.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.06.24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Producte_anzeigen_test: View {
    
    @StateObject var viewModel = ProductViewModel()
    
    var body: some View {
        NavigationStack{
            List(viewModel.productss) { product in
                VStack(alignment: .leading) {
                    Text(product.productName)
                        .font(.headline)
                    Text("Preis: \(product.price)€")
                    Text("Menge: \(product.ml)ml")
                }
            }
            .navigationTitle("Produkte")
            .onAppear {
                viewModel.fetchProducts(kategorie: "Alkoholfrei")
            }
        }
    }
}

#Preview {
    Producte_anzeigen_test()
}
