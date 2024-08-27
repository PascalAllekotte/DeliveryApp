//
//  ResponseModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 02.07.24.
//
import SwiftUI
import UIKit

struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

struct Choice: Codable {
    let index: Int
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
    
}
