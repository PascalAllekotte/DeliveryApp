//
//  RegistrationView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 03.07.24.
//

import SwiftUI

struct RegistrationView: View {
    
    // MARK: VARIABLES -
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    @State private var name = ""
    @State private var nachname = ""
    @State private var email: String = ""
    @State private var mobilNumber: String = ""    
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @State private var address = AdressModel(street: "", streetNumber: "", postalCode: "", place: "")


    
    
    var body: some View {
        VStack{
            HStack{
                Text("Registriere dich jetzt!")
                    .font(.headline)
                Spacer()
            }
            VStack(spacing: 15){
                
                //Vorname und Nachname
                HStack{
                    TextField("Vorname" , text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))

                    TextField("Nachname" , text: $nachname)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }
                
                //E-Mail Adresse
                TextField("E-Mail Adresse" , text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                
                //Mobilfunknummer
                TextField("Mobilfunknummer" , text: $mobilNumber)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                
                //Passwort
                SecureField("Passwort" , text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                
                //Passwort bestätigen iff
                SecureField("Passwort bestätigen" , text: $passwordCheck)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                
                Spacer()
                Button("Registrieren"){
                    
                    viewModel.register(password: password, name: name, nachname: nachname, mobilNumber: mobilNumber, email: email, passwordCheck: passwordCheck, address: address, admin: false)
                }
                .padding()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .background(Color("produkt"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    RegistrationView()
}
