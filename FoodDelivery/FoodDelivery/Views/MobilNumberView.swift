//
//  MobilNumberView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 12.07.24.
//

import SwiftUI

struct MobilNumberView: View {
    // MARK: Variables -
    
    @State private var mobilNumber: String = ""
    
    @EnvironmentObject var loginViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            
            Text("Wie lautet deine Mobilfunknummer?")
                .font(.title)
            
            VStack {
                TextField("Mobilfunknummer", text: $mobilNumber)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .foregroundColor(.black)
                    
                  
                
            }
            .padding()
            
            Spacer()
            
            Button("Speichern") {
               loginViewModel.updateNumber(newMobilNumber: mobilNumber)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 2)
            .padding()
            .foregroundStyle(.black)
        }
        .onAppear {
            if let user = loginViewModel.user {
                mobilNumber = user.mobilNumber
            }
        }
        
    }
    
    // MARK: Functions -
}
#Preview {
    MobilNumberView()
        .environmentObject(AuthViewModel())
}
