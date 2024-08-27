//  NameView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 10.07.24.
//

import SwiftUI

struct NameView: View {
    // MARK: Variables -
    
    @State private var name: String = ""
    @State private var nachName: String = ""
    
    @EnvironmentObject var loginViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            
            Text("Wie lautet dein Name?")
                .font(.title)
            
            VStack {
                TextField("Vorname", text: $name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .foregroundStyle(.black)
                   
                
                TextField("Nachname", text: $nachName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .foregroundStyle(.black)
                
                
                   
            }
            .padding()
            
            
            
            Spacer()
            
            Button("Speichern") {
                loginViewModel.updateName(newName: name, newNachName: nachName)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 2)
            .padding()
        }
        .onAppear {
            if let user = loginViewModel.user {
                name = user.name
                nachName = user.nachname
            }
        }
    }
    
    // MARK: Functions -
}

// Preview
#Preview {
    NameView()
        .environmentObject(AuthViewModel())
}
