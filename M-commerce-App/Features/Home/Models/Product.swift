//
//  Product.swift
//  M-commerce-App
//
//  Created by Macos on 09/06/2025.
//

import Foundation
struct Product: Identifiable {
    let id: String
    let title: String
    let description: String?
    let imageUrls: [String]
    var price: Double?
    let currencyCode: String?
    let productType: String?
    let size: String?
    let color: String? 
}
