//
//  UserSupportVIew.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 05.07.24.
//

import SwiftUI

struct UserSupportVIew: View {
    // MARK: Variables -
    @State private var test = ""
    
    
    var body: some View {
        VStack{
            VStack{
                Text("Kundenservice kontaktieren!")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                
                    .padding()
                    .background(Color("produkt"))
            }
            Spacer()
            ScrollView{
                HStack{
                    Text("Kontaktieren sie mit einer Nachricht den Kundenservice")
                    Spacer()
                }
                .padding(.horizontal)
                TextField("Deine Nachricht", text: $test)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
                    .padding()
            }
            Button("Nachricht senden!"){
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundStyle(.black)
            .padding()

            

        }
       
        Spacer()
    }
}

#Preview {
    UserSupportVIew()
}
