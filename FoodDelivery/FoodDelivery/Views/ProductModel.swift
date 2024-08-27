//
//  ProductModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 28.06.24.
//

import Foundation
import FirebaseFirestore

struct ProductModel: Identifiable, Codable {
    @DocumentID var id: String?
    
    var imageURL: String
    var ml: String
    var price: String
    var productName: String
    var discount: Bool
    var discountDetail: String
    var pfand: Bool
    var quantity: String
    var hTags: [String]?

}
