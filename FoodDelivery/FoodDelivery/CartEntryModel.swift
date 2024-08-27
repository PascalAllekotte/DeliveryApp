//
//  CartEntryModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 11.08.24.
//

import Foundation

struct CartEntryModel {
    var productMeat: ProductMeatModel?
    var product: ProductModel?
    var entries: [(gramm: Double, preis: Double)]?
    var quantity: Int?
    var pfand: Double
}
