//
//  MenuItem.swift
//  Little Lemon
//
//  Created by Jay Thakur on 03/01/24.
//

import Foundation

enum MenuItemCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case starters = "starters"
    case mains = "mains"
    case desserts = "desserts"
    case drinks = "drinks"
    
    var title: String {
        switch (self) {
        case .starters:
            return "Starters"
        case .mains:
            return "Mains"
        case .desserts:
            return "Desserts"
        case .drinks:
            return "Drinks"
        }
    }
}

struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
    let category: String
}
