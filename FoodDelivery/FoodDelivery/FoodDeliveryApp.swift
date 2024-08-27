//
//  FoodDeliveryApp.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.05.24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth




@main
struct FoodDeliveryApp: App {
    
    @StateObject private var loginViewModel = AuthViewModel()
    @StateObject var cartViewModel = CartViewModel()


      init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
      }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .environmentObject(cartViewModel)

        }
    }
}
/*
// TODO: Heute zu erledigen-
 Produkte hinzufügen =
 Detailansicht für normale Produkte =
 


 

*/
