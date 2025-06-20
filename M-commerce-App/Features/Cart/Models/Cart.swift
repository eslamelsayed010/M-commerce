//
//  Cart.swift
//  M-commerce-App
//
//  Created by Macos on 19/06/2025.
//

import Foundation

struct DraftOrderWrapper: Encodable {
    let draft_order: DraftOrder
}

struct DraftOrder: Encodable {
    let line_items: [LineItem]
    let customer: Customer
    let use_customer_default_address: Bool
    let note: String?
}

struct LineItem: Encodable {
    let variant_id: Int
    let quantity: Int
}

struct Customer: Encodable {
    let id: Int
}


