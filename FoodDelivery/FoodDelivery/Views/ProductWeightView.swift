//  DetailView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI

struct ProductWeightView: View {
    let selectedItem: String
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(selectedItem)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 16)
                    .padding(.top, 10)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.allProducts.indices, id: \.self) { index in
                        if let meatProduct = viewModel.allProducts[index] as? ProductMeatModel {
                            ProductWeightItem(product: meatProduct, viewModel: viewModel)
                                .padding(8)
                        } else if let normalProduct = viewModel.allProducts[index] as? ProductModel {
                            NormalProduct(viewModel: viewModel, product: normalProduct)
                                .padding(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 10)
        }
        .scrollIndicators(.hidden)
        .background(Color("bg").edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchAllProducts(kategorie: selectedItem)
        }
        .navigationTitle(selectedItem)
    }
}

#Preview {
    ProductWeightView(selectedItem: "Rind")
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}
