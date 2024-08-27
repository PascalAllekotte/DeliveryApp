//
//  FireUser.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 03.07.24.
//

import Foundation

struct FireUser : Codable, Identifiable, Equatable {
    static func == (lhs: FireUser, rhs: FireUser) -> Bool {
        lhs.id == rhs.id
    }
    
    let id : String
    var name : String
    var nachname: String
    var mobilNumber: String
    var email : String
    var adress : AdressModel
    var favorites: [String] = [] 
    var admin : Bool

    
}
