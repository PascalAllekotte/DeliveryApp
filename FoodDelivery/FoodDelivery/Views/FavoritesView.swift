//
//  FavoritesView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 09.07.24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var fireStoreViewModel = ProductViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(groupedFavorites.keys.sorted(), id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category)
                                .font(.headline)
                                .padding(.leading, 15) 
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(groupedFavorites[category] ?? []) { product in
                                        ProductWeightItem(product: product, viewModel: fireStoreViewModel)
                                    }
                                }
                                .padding(.leading)
                            }
                        }
                        .padding(.bottom)
                    }
                }
                .padding(.leading, -4)
            }
            .navigationTitle("Favorites")
            .onAppear {
                loadFavorites()
            }
        }
    }
    
    private var groupedFavorites: [String: [ProductMeatModel]] {
        Dictionary(grouping: fireStoreViewModel.favoriteProducts) { product in
            product.category ?? "test"
        }
    }
    
    private func loadFavorites() {
        fireStoreViewModel.fetchFavoriteProducts(favoriteIds: authViewModel.user?.favorites ?? [])
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AuthViewModel())
}
