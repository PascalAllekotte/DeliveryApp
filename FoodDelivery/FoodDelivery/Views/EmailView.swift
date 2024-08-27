//
//  EmailView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 10.07.24.
//

import SwiftUI

struct EmailView: View {
    // MARK: Variables -
    
    @EnvironmentObject var loginViewModel : AuthViewModel
    
    @State private var email = ""
    @State private var newEmail = ""
    @State private var password = ""
    
    
    var body: some View {
        VStack{
            
            Text("E-Mail Adresse ändern")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
            TextField("Alte E-Mail", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
            
            TextField("Neue E-Mail", text: $newEmail)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
            
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
            
            
            
            Spacer()
            Button("Bestätigen"){
                loginViewModel.changeEmail(email: email, newEmail: newEmail, password: password)
                
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 2)
            .foregroundStyle(.black)
            
        }
        .padding()
    }
 // MARK: Functions -
    
    
}

#Preview {
    EmailView()
        .environmentObject(AuthViewModel())
}
