//
//  ShopifyOrder.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import Foundation
struct ShopifyOrder: Identifiable, Decodable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let totalPrice: String
    let currency: String
    let lineItems: [OrderLineItem]

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case totalPrice = "total_price"
        case currency
        case lineItems = "line_items"
    }
}

struct OrderLineItem: Identifiable, Decodable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String
}
