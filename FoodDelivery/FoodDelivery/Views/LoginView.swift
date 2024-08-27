//
//  LoginView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 04.07.24.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: VARIABLES -
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isPresented: Bool
    @State private var loginFailed: Bool = false
    @State private var loginErrorMessage: String?
    
    
    // MARK: MAIN -
    var body: some View {
        VStack{
            HStack{
                Text("Melde dich an!")
                    .font(.headline)
                Spacer()
            }
            //E-Mail Adresse
            TextField("E-Mail Adresse" , text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            
            //Passwort
            SecureField("Passwort" , text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            
            Spacer()
            
            if loginFailed {
                           Text(loginErrorMessage ?? "Anmeldung fehlgeschlagen")
                               .foregroundColor(.red)
                               .padding()
                       }
            
            Button("Anmelden"){
                viewModel.login(email: email, password: password)
                
              //login()
                
            }
            .padding()
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .onChange(of: viewModel.user){ old, new in
            if new != nil {
                isPresented = false
            }
        }
        .padding()
        Spacer()
    }
    
    // MARK: FUNCTIONS -

}



#Preview {
    LoginView(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}
