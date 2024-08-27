//
//  CartViewModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 05.08.24.
//

import Foundation

class CartViewModel: ObservableObject {
    
    // MARK: - Variables -

    @Published var gespeicherteEintraege: [String: CartEntryModel] = [:]
    @Published var selectedDay: String = ""
    @Published var selectedTimeSlot: String = ""
    
    
    
    
    // MARK: - FUNCTIONS -

    // Hinzufügen eines Fleischprodukts (basierend auf Gewicht) zum Warenkorb
    func addEntry(for product: ProductMeatModel, gramm: Double, preis: Double) {
        guard let productId = product.id else { return }
        
        if gespeicherteEintraege[productId] == nil {
            gespeicherteEintraege[productId] = CartEntryModel(productMeat: product, entries: [], quantity: nil, pfand: 0.0)
        }
        gespeicherteEintraege[productId]?.entries?.append((gramm: gramm, preis: preis))
    }

    // Hinzufügen eines allgemeinen Produkts (basierend auf Menge) zum Warenkorb
    func addProduct(for product: ProductModel, quantity: Int) {
        guard let productId = product.id else { return }
        
        let pfand = product.pfand ? 0.25 : 0.0
        
        if gespeicherteEintraege[productId] == nil {
            gespeicherteEintraege[productId] = CartEntryModel(productMeat: nil, product: product, entries: nil, quantity: quantity, pfand: pfand)
        } else {
            gespeicherteEintraege[productId]?.quantity = quantity
            gespeicherteEintraege[productId]?.pfand = pfand
        }
    }

    // Entfernen eines Eintrags, unabhängig davon, ob es sich um ein Gewichtseintrag oder allgemeines Produkt handelt
    func removeEntry(for productId: String, at index: Int? = nil) {
        // Wenn es sich um ein Produkt mit Gewichtsangabe handelt
        if let index = index, var entries = gespeicherteEintraege[productId]?.entries {
            entries.remove(at: index)
            gespeicherteEintraege[productId]?.entries = entries
            
            // Entfernen des gesamten Produkts, wenn keine Einträge mehr vorhanden sind
            if entries.isEmpty {
                gespeicherteEintraege.removeValue(forKey: productId)
            }
        } else {
            // Entfernen des gesamten Produkts, wenn kein spezifischer Index angegeben ist (für allgemeine Produkte)
            gespeicherteEintraege.removeValue(forKey: productId)
        }
    }

    // Abrufen der Einträge für ein bestimmtes Produkt
    func getEntries(for productId: String) -> [(gramm: Double, preis: Double)] {
        return gespeicherteEintraege[productId]?.entries ?? []
    }
    
    // Berechnung der Gesamtzahl aller Artikel im Warenkorb
    func totalitem() -> Int {
        var count = 0
        for entry in gespeicherteEintraege.values {
            if let entries = entry.entries {
                count += entries.count
            } else if let quantity = entry.quantity {
                count += quantity
            }
        }
        return count
    }

    // Berechnung des Gesamtpreises aller Produkte im Warenkorb
    func calculateTotalPrice() -> Double {
        return gespeicherteEintraege.values.reduce(0) { total, entry in
            let productTotal = entry.entries?.reduce(0) { $0 + $1.preis } ?? 0
            let quantityTotal = (Double(entry.quantity ?? 0) * (Double(entry.product?.price ?? "0") ?? 0))
            return total + productTotal + quantityTotal
        }
    }

    // Berechnung des gesamten Pfandbetrags für alle Produkte im Warenkorb
    func calculateTotalPfand() -> Double {
        return gespeicherteEintraege.values.reduce(0) { total, entry in
            let pfandTotal = (entry.pfand * Double(entry.quantity ?? 0))
            return total + pfandTotal
        }
    }
    
    
    // Erhöhen der Menge eines allgemeinen Produkts
       func increaseQuantity(for productId: String) {
           guard let currentQuantity = gespeicherteEintraege[productId]?.quantity else { return }
           gespeicherteEintraege[productId]?.quantity = currentQuantity + 1
       }

       // Verringern der Menge eines allgemeinen Produkts
       func decreaseQuantity(for productId: String) {
           guard let currentQuantity = gespeicherteEintraege[productId]?.quantity else { return }
           if currentQuantity > 1 {
               gespeicherteEintraege[productId]?.quantity = currentQuantity - 1
           } else {
               // Wenn die Menge auf 0 reduziert wird, entferne das Produkt aus dem Warenkorb
               gespeicherteEintraege.removeValue(forKey: productId)
           }
       }
    
    // MARK: DELIVERYTIME
    
    // Funktion zum Setzen der ausgewählten Lieferzeit
     func setSelectedDeliveryTime(day: String, timeSlot: String) {
         self.selectedDay = day
         self.selectedTimeSlot = timeSlot
     }
     
     // Funktion zum Abrufen der vollständigen Lieferzeit
     func getSelectedDeliveryTime() -> String {
         return "\(selectedDay) \(selectedTimeSlot)"
     }

}

