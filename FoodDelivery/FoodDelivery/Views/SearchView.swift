//
//  SearchView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 05.08.24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                    .padding(.leading)
                TextField("Suchen", text: $searchText)
                    .padding(8)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.searchProducts(searchfield: newValue)
                    }
            }
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.searchResults, id: \.id) { result in
                        if let meatProduct = result.productMeatModel {
                            ProductWeightItem(product: meatProduct, viewModel: viewModel)
                        } else if let product = result.productModel {
                            NormalProduct(viewModel: viewModel, product: product)
                                .padding(6)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(.top)
    }
}

#Preview {
    SearchView()
        .environmentObject(CartViewModel())
        .environmentObject(AuthViewModel())
}
