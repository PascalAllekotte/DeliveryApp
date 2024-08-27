//
//  Feedback.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 14.07.24.
//

import SwiftUI

struct Feedback: View {
    // MARK: Variables -
    @State private var test = ""
    
    
    var body: some View {
        VStack{
            VStack{
                Text("Feedback geben!")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                
                    .padding()
                    .background(Color("produkt"))
            }
            Spacer()
            ScrollView{
                TextField("test", text: $test)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
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
    Feedback()
}
