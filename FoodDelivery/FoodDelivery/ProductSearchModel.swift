//
//  ProductSearchModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 17.08.24.
//

import Foundation

struct ProductSearchModel: Identifiable {
    var id: String?
    var productMeatModel: ProductMeatModel?
    var productModel: ProductModel?
    
    init(productMeatModel: ProductMeatModel) {
        self.id = productMeatModel.id
        self.productMeatModel = productMeatModel
        self.productModel = nil
    }
    
    init(productModel: ProductModel) {
        self.id = productModel.id
        self.productModel = productModel
        self.productMeatModel = nil
    }
    
    var productName: String {
        return productMeatModel?.productName ?? productModel?.productName ?? ""
    }
}
