//  DetailViewProduct.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//xfg

import SwiftUI

struct DetailViewProduct: View {
    let selectedItem: String
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(selectedItem)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 15)
                    .padding(.top, 10)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.productss) { product in
                        NormalProduct(viewModel: viewModel, product: product)
                            .padding(1)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .scrollIndicators(.hidden)
        .background(Color("bg"))
        .onAppear {
            viewModel.fetchProducts(kategorie: selectedItem)
        }
        .navigationTitle(selectedItem)
    }
}

#Preview {
    DetailViewProduct(selectedItem: "Alkoholfrei")
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}
