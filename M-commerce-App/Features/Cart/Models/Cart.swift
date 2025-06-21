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

struct UpdateDraftOrderRequest: Encodable {
    var draft_order: PutDraftOrder
}

struct PutDraftOrder: Encodable {
    var id: Int
    var line_items: [PutLineItem]
}

struct PutLineItem: Encodable {
    var id: Int
    var variant_id: Int
    var product_id: Int
    var quantity: Int
}



