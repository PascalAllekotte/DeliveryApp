//
//  MeatProductsTestView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 30.06.24.
//

import SwiftUI

struct MeatProductsTestView: View {
    
    @StateObject var viewModel = ProductViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.meatProducts) { product in
                HStack {
                    if let imageUrl = URL(string: product.imageURL) {
                        AsyncImage(
                            url: imageUrl,
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            },
                            placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            }
                        )
                        .frame(width: 50, height: 50)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(product.productName)
                            .font(.headline)
                        Text(product.description)
                        Text("Price: \(product.price)")
                        Text("Option 1: \(product.vauswahl1)")
                        Text("Option 2: \(product.vauswahl2)")
                        if product.discount {
                            Text("Rabatt: \(product.discountDetail)")
                                .foregroundStyle(.green)
                        }
                    }

                    Spacer()

                    Button(action: {
                        toggleFavorite(for: product)
                    }) {
                        Image(systemName: authViewModel.user?.favorites.contains(product.id ?? "") ?? false ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .navigationTitle("Meat Products")
            .refreshable {
                viewModel.fetchMeatProducts(kategorie: "Rind")
            }
            .onAppear {
                viewModel.fetchMeatProducts(kategorie: "Rind")
                authViewModel.fetchFavorites()
            }
        }
    }

    private func toggleFavorite(for product: ProductMeatModel) {
        guard let productId = product.id else { return }
        if authViewModel.user?.favorites.contains(productId) ?? false {
            authViewModel.removeFromFavorites(productId: productId)
        } else {
            authViewModel.addToFavorites(productId: productId)
        }
    }
}

#Preview {
    MeatProductsTestView()
        .environmentObject(AuthViewModel())
}
