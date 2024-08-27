//
//  AGB.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 14.07.24.
//

import SwiftUI

struct AGB: View {
    @State private var test = "Die AGBS!!"
    var body: some View {
        VStack{
            VStack{
                Text("AGB!")
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
    AGB()
}
