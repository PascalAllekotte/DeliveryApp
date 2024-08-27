//
//  PasswordView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 10.07.24.
//

import SwiftUI

struct PasswordView: View {
    // MARK: Variables -
    
    @State private var newPassword = ""
    @State private var newPasswordAgain = ""
    @State private var oldPassword = ""

    
    @EnvironmentObject var loginViewModel : AuthViewModel
    
    var body: some View {
        VStack{
            Text("Ändere dein Password")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            
                
                VStack {
                    
                    SecureField("Altes Password" , text: $oldPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    
                    
                    SecureField("Neues Password" , text: $newPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    
                    
                    SecureField("Neues Password bestätigen" , text: $newPasswordAgain)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }
                .padding()
                
                
                Spacer()
                
                Button("Speichern"){
                    loginViewModel.changePassword(oldPassword: oldPassword, newPassword: newPassword)
                    
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("produkt"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 2)
                .padding()
            }
    }
    
    // MARK: Functions -
    
}


#Preview {
    PasswordView()
        .environmentObject(AuthViewModel())
}
