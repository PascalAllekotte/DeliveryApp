//
//  DeleteView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 10.07.24.
//

import SwiftUI

struct DeleteView: View {
    // MARK: Variables -
    
    @EnvironmentObject var loginViewModel : AuthViewModel
    
    @State private var password = ""
    
    @Binding var path : NavigationPath
    
    var body: some View {
        VStack {
            Text("Account löschen")
                .font(.title)
            
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
            
            Spacer()
            Button("Bestätigen") {
                delete(password: password)
                
                
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
    
    func delete(password: String) {
        loginViewModel.deleteAccount(password: password) { success in
            if success {
                path = .init()
            }
        }
    }
}

#Preview {
    DeleteView(path: .constant(NavigationPath()))
}
