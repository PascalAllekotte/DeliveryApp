//
//  FAQ.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 14.07.24.
//

import SwiftUI

struct FAQ: View {
    @State private var test = "kjadscjnasvdjknov"
    var body: some View {
        VStack{
            VStack{
                Text("FAQ!")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                
                    .padding()
                    .background(Color("produkt"))
            }
            Spacer()
            ScrollView{
                Text("\(test)")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
                    .padding()
            }
            
            

        }
       
        Spacer()
    }
}

#Preview {
    FAQ()
}
