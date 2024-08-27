//
//  Impressum.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 14.07.24.
//

import SwiftUI

struct Impressum: View {
    @State private var test = "Das Impressum sooo!"
    var body: some View {
        VStack{
            VStack{
                Text("Impressum!")
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
    Impressum()
}
