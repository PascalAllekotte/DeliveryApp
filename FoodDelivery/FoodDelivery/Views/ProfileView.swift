//
//  ProfileView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 03.07.24.
//

import SwiftUI
import MapKit

struct ProfileView: View {
    
    // MARK: VARIABLES -
    
    @State private var information = false
    @State private var login = false
    @State private var registrate = false
    
    @EnvironmentObject var loginViewModel: AuthViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    // MARK: BEREICH wenn User nicht logged in
                    if !loginViewModel.isUserLoggedIn {
                        VStack {
                            Image("MeatNow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260, height: 100)
                                .offset(CGSize(width: 0, height: 10))
                            
                        
                            Text("Lass dir deine Fleischprodukte direkt zur dir nach Hause liefern.")
                                .font(.title2)
                                .bold()
                            
                            // Login
                            Button("Anmelden") {
                                loginSheet()
                            }
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            
                            // Registrate
                            Button("Registrieren") {
                                registrierenSheet()
                            }
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            
                        }
                        .padding()
                        
                        .background(Color("produkt"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(8)
                        
                    } else {
                        
                        // MARK: Bereich für loggedInUser - FAVORITES / BESTELLUNGEN / MEIN KONTO
                        Text("Willkommen zurück, \(loginViewModel.user?.name ?? "User")!")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                        
                        HStack{
                            NavigationLink(destination: FavoritesView()){
                                VStack{
                                    Text("Bestellungen")
                                }
                                .frame(width: 105, height: 100)
                                .background(Color("produkt"))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 1)
                                .foregroundStyle(.black)
                            }
                            
                            NavigationLink(destination: FavoritesView()){
                                VStack{
                                    Text("Favoriten")
                                }
                                .frame(width: 105, height: 110)
                                .background(Color("produkt"))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 1)
                                .foregroundStyle(.black)
                            }
                            
                            
                            NavigationLink(destination: MyAccountView(path: $path)){
                                VStack{
                                    Text("Mein Konto")
                                }
                                .frame(width: 105, height: 100)
                                .background(Color("produkt"))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 1)
                                .foregroundStyle(.black)
                                
                            }
                        }
                        
                        HStack {
                            Text("Lieferadresse")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        
                        HStack{
                            VStack{
                                HStack{
                                    Text("\(loginViewModel.user?.adress.street ?? "Zinkhüttenstraße")")
                                    Text("\(loginViewModel.user?.adress.streetNumber ?? "300")")
                                }
                                
                                HStack{
                                    Text("\(loginViewModel.user?.adress.postalCode ?? "45473")")
                                    
                                }
                                
                                HStack{
                                    Text("\(loginViewModel.user?.adress.place ?? "Mülheim an der Ruhr")")
                                    
                                }
                                Spacer()
                                
                            }
                            .padding()
                            
                            
                            Spacer()
                            Map{
                                
                            }
                            .frame(width: 150, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(10)
                            .padding(.top, -20)
                            
                        }
                        
                        
                        
                    }
                }
                
                // MARK: HILFE Section + Andere -
                HStack {
                    Text("Hilfe")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                
                VStack {
                    NavigationLink(destination: FAQ()){
                        HStack {
                            Image(systemName: "questionmark.app")
                            Text("FAQ")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .foregroundStyle(.black)
                        .padding()
                    }
                    Divider()
                        .padding(4)
                }
                
                VStack {
                    NavigationLink(destination: UserSupportVIew()) {
                        HStack {
                            Image(systemName: "questionmark.app")
                            Text("Kundenservice Kontaktieren")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .foregroundStyle(.black)
                        .padding()
                    }
                    Divider()
                        .padding(4)
                }
                
                VStack {
                    NavigationLink(destination: Feedback()){
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("Feedback geben")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .foregroundStyle(.black)
                        .padding()
                    }
                    Divider()
                        .padding(4)
                }
                
                //Rechtliches Section
                HStack {
                    Text("Rechtliches")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                
                VStack {
                    NavigationLink(destination: Datenschutz()){
                        HStack {
                            Image(systemName: "lock.display")
                            Text("Datenschutz")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    Divider()
                        .padding(4)
                }
                
                VStack {
                    NavigationLink(destination: AGB()){
                        HStack {
                            Image(systemName: "book.pages")
                            Text("AGB")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                        
                    }
                    Divider()
                        .padding(4)
                }
                
                VStack {
                    HStack {
                        Image(systemName: "figure.australian.football")
                        Text("Datenschutzeinstellungen")
                        Spacer()
                        Image(systemName: "arrowshape.right")
                    }
                    .padding()
                    Divider()
                        .padding(4)
                }
                
                VStack {
                    NavigationLink(destination: Impressum()){
                        HStack {
                            Image(systemName: "book.pages")
                            Text("Impressum")
                            Spacer()
                            Image(systemName: "arrowshape.right")
                        }
                        .padding()
                        .foregroundStyle(.black)
                    }
                    Divider()
                        .padding(4)
                }
                
                if information == true {
                    Section(header: Text("test")) {
                        Button("LogIn") {
                            //test
                        }
                    }
                }
            }
            .sheet(isPresented: $registrate) {
                NavigationView {
                    RegistrationView()
                        .navigationBarItems(trailing: Button(action: {
                            registrate.toggle()
                        }) {
                            Image(systemName: "xmark")
                        })
                }
            }
            .sheet(isPresented: $login) {
                NavigationView {
                    LoginView(isPresented: $login)
                        .navigationBarItems(trailing: Button(action: {
                            login.toggle()
                        }) {
                            Image(systemName: "xmark")
                        })
                }
            }
        }
    }
    
    // MARK: FUNCTIONS -
    
    private func forTestsing() {
        information.toggle()
    }
    
    private func loginSheet() {
        login.toggle()
    }
    
    private func registrierenSheet() {
        registrate.toggle()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
