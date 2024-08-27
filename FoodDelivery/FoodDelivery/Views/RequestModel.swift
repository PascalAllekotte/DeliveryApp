//
//  ChatBotModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 02.07.24.
//

import Foundation

struct OpenAIContent: Codable {
    let type: String
    let text: String?
    let image_url: OpenAIImageURL?
}

struct OpenAIImageURL: Codable {
    let url: String
}

struct OpenAIMessage: Codable {
    let role: String
    let content: [OpenAIContent]
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let max_tokens: Int
}

