//
//  MeinKontoView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 09.07.24.
//

import SwiftUI
import FirebaseAuth

struct MyAccountView: View {
    
    // MARK: VARIABLES -
    
    @EnvironmentObject var loginViewModel : AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var path : NavigationPath
    
    
    var body: some View {
        ScrollView{
            
            VStack{
                HStack{
                    Text("Konto Details")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
                HStack{
                    Text("Name")
                        .bold()
                    Spacer()
                    
                    Text("\(loginViewModel.user?.name ?? "Name") \(loginViewModel.user?.nachname ?? "Name")")
                }
                .padding()
                
                HStack{
                    Text("E-Mail")
                        .bold()
                    Spacer()
                    
                    Text("\(loginViewModel.user?.email ?? "Name")")
                }
                .padding()
                
                HStack{
                    Text("Mobilfunknummer")
                        .bold()
                    Spacer()
                    
                    Text("\(loginViewModel.user?.mobilNumber ?? "29439439")")
                }
                .padding()
                
                Divider()
                
                // MARK: Konto Einstellungen zum ändern
                
                VStack{
                    HStack{
                        Text("Konto Verwaltung")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    NavigationLink(destination: NameView()){
                        HStack{
                            Text("Name")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    
                    NavigationLink(destination: MobilNumberView()){
                        HStack{
                            Text("Mobilfunknummer")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    
                    NavigationLink(destination: EmailView()){
                        HStack{
                            Text("E-Mail")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    
                    NavigationLink(destination: PasswordView()){
                        HStack{
                            Text("Passwort")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    
                    NavigationLink(destination: AdressView()){
                        HStack{
                            Text("Lieferadresse")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    
                    
                    NavigationLink(destination: DeleteView(path: $path)){
                        HStack{
                            Text("Account löschen")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    
                    
                    
                    Spacer()
                    Button("Ausloggen"){
                        loginViewModel.logout()
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("produkt"))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 2)
                    .padding()
                    .foregroundStyle(.black)
                    //     .padding(.top, -20)
                }
            }
            
        }
        
    }
    
}



#Preview {
    MyAccountView(path: .constant(NavigationPath()))
        .environmentObject(AuthViewModel())
    
}
