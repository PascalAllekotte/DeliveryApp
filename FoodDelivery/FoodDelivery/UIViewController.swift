//
//  UIViewController.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 30.05.24.
//

import Foundation
import UIKit
import SwiftUI


extension UIViewController {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
