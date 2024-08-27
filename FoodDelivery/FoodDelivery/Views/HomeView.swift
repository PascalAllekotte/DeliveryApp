//
//  HomeView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct HomeView: View {
    @StateObject var viewModel = ProductViewModel()
    
    @State private var category: String = ""
    @State private var productName: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Text("Willkommen!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding()
                        //.foregroundStyle(Color("produkt"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Angebote")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.discountedProducts) { produkt in
                                Angebot(product: produkt)
                                    .padding(2)
                            }
                        }
                        .padding(.top, 3)
                        .padding(.horizontal)
                    }
                    
                    
                    Text("Fleisch")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                    Fleisch()
                    
                   
                    
                    Text("Gesundheit/Ernährung")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                    Image("ddd")
                       .resizable()
                  //      .scaledToFill()
                        .frame(width: 380,height: 270)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                   //     .padding(.trailing, 35)
                       // .padding(.horizontal)


                    Text("Zubehör")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                    Zubehoer()
                    
                    Text("Getränke")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                   Getraenke()
                }
            }
            .onAppear {
                viewModel.fetchDiscountedProducts()
            }
        }
    }
}

#Preview {
    HomeView()
        
}
