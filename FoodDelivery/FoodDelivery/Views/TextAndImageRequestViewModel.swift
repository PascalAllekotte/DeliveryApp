//
//  TextAndImageRequestViewModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 22.08.24.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore

class TextAndImageRequestViewModel: ObservableObject {
    // MARK: VARIABLES -
       @Published var responseText: String = ""
       @Published var isLoading: Bool = false
       @Published var image: UIImage?
       @Published var detectedDishName: String = "" // Speichert den erkannten Gerichtnamen
       @Published var ingredients: [String] = [] // Speichert die extrahierten Zutaten
       @Published var firestoreIngredients: [String] = [] // Zutaten aus Firestore
       
       @Published var foundProducts: [ProductModel] = [] // Anpassung: Hinzugefügt für die gefundenen normalen Produkte
       @Published var foundMeatProducts: [ProductMeatModel] = [] // Anpassung: Hinzugefügt für die gefundenen Fleischprodukte

       
       private let firebaseFireStore = Firestore.firestore()

    // MARK: Functions -
    func sendRequest() {
        guard let image = image else {
            print("Kein Bild ausgewählt.")
            return
        }
        
        let requestText = "Beschreibe mir dies Gericht, wenn es kein Gericht zum essen ist antworte mir >Dies ist kein erkennbares Gericht< und wenn es etwas zum essen ist schreibe mir den Namen so >#Name: Name< und die Zutaten für dies Gericht in einer Liste so >#Ingredient1: Zutat< >#Ingredient2: Zutat<"
        isLoading = true
        
        if let base64String = image.jpegData(compressionQuality: 1.0)?.base64EncodedString() {
            Task {
                await uploadTextAndImage(requestText: requestText, base64String: base64String)
            }
        }
    }
    
    private func makeRequest(urlString: String, requestBody: OpenAIRequest) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    private func handleResponse(data: Data) async {
        do {
            let chatResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
            if let content = chatResponse.choices.first?.message.content {
                DispatchQueue.main.async {
                    self.processResponse(content)
                    self.isLoading = false
                    self.searchIngredientsInFirestore() // Suche nach den Zutaten in Firestore
                }
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.responseText = "Fehler bei der Verarbeitung der Antwort"
                self.isLoading = false
            }
        }
    }
    
    private func processResponse(_ content: String) {
        self.responseText = content
        
        // Extrahiere den Gerichtnamen
        if let nameRange = content.range(of: "#Name:") {
            let nameStartIndex = content.index(nameRange.lowerBound, offsetBy: 7)
            let dishName = String(content[nameStartIndex...]).components(separatedBy: "\n").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.detectedDishName = dishName
        } else {
            self.detectedDishName = "Kein erkennbares Gericht"
        }
        
        // Extrahiere die Zutaten
        let ingredientPattern = "#Ingredient\\d+: ([^#\\n]+)"
        let regex = try? NSRegularExpression(pattern: ingredientPattern, options: [])
        let matches = regex?.matches(in: content, options: [], range: NSRange(content.startIndex..., in: content))
        
        var extractedIngredients: [String] = []
        matches?.forEach { match in
            if let range = Range(match.range(at: 1), in: content) {
                let ingredient = String(content[range]).trimmingCharacters(in: .whitespacesAndNewlines)
                extractedIngredients.append(ingredient)
            }
        }
        
        self.ingredients = extractedIngredients
    }
    
    private func uploadTextAndImage(requestText: String, base64String: String) async {
        let imageContent = OpenAIContent(type: "image_url", text: nil, image_url: OpenAIImageURL(url: "data:image/jpeg;base64,\(base64String)"))
        let textContent = OpenAIContent(type: "text", text: requestText, image_url: nil)
        let message = OpenAIMessage(role: "user", content: [textContent, imageContent])
        let requestBody = OpenAIRequest(model: "gpt-4o", messages: [message], max_tokens: 300)
        
        do {
            let data = try await makeRequest(urlString: "https://api.openai.com/v1/chat/completions", requestBody: requestBody)
            await handleResponse(data: data)
        } catch {
            print("Error uploading text and image: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.responseText = "Fehler beim Hochladen der Anfrage"
                self.isLoading = false
            }
        }
    }
    
    // Sucht nach den extrahierten Zutaten in Firestore
    private func searchIngredientsInFirestore() {
            guard !ingredients.isEmpty else { return }

            firestoreIngredients = []
            foundProducts = [] // Zurücksetzen der gefundenen normalen Produkte
            foundMeatProducts = [] // Zurücksetzen der gefundenen Fleischprodukte

            let dispatchGroup = DispatchGroup()

            let categories = ["Rind", "Alkoholfrei", "Lamm", "Gewürze"]

            for category in categories {
                for ingredient in ingredients {
                    let words = ingredient.components(separatedBy: " ")

                    for word in words {
                        dispatchGroup.enter()
                        firebaseFireStore.collection(category)
                            .whereField("hTags", arrayContains: word)
                            .getDocuments { snapshot, error in
                                if let error = error {
                                    print("Error while searching ingredients in Firestore: \(error)")
                                    dispatchGroup.leave()
                                    return
                                }
                                guard let documents = snapshot?.documents else {
                                    print("No documents found for word: \(word)")
                                    dispatchGroup.leave()
                                    return
                                }

                                for document in documents {
                                    if let meatProduct = try? document.data(as: ProductMeatModel.self) {
                                        self.foundMeatProducts.append(meatProduct) // Hinzufügen des gefundenen Fleischprodukts
                                    } else if let normalProduct = try? document.data(as: ProductModel.self) {
                                        self.foundProducts.append(normalProduct) // Hinzufügen des gefundenen normalen Produkts
                                    }
                                }
                                dispatchGroup.leave()
                            }
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("Search in Firestore completed with \(self.foundProducts.count) normal products and \(self.foundMeatProducts.count) meat products found.")
            }
        }


}

 
