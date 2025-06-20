//
//  DraftOrders.swift
//  M-commerce-App
//
//  Created by Macos on 20/06/2025.
//

import Foundation

struct DraftOrdersResponse: Codable {
    let draftOrders: [GetDraftOrder]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}

struct GetDraftOrder: Codable {
    let id: Int64
    let note: String?
    let currency: String
    let allowDiscountCodesInCheckout: Bool?
    let lineItems: [LineItems]
    let shippingAddress: Address?
    let appliedDiscount: Discount?
    let orderId: Int64?
    let shippingLine: ShippingLine?
    let totalPrice: String
    let customer: Customers?

    enum CodingKeys: String, CodingKey {
        case id, note, currency, customer
        case allowDiscountCodesInCheckout = "allow_discount_codes_in_checkout?"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case shippingLine = "shipping_line"
        case appliedDiscount = "applied_discount"
        case orderId = "order_id"
        case totalPrice = "total_price"
    }
}

struct LineItems: Codable {
    let id: Int64
    let variantId: Int64?
    let productId: Int64?
    let title: String
    let variantTitle: String?
    let sku: String?
    let vendor: String?
    let quantity: Int
    let requiresShipping: Bool
    let taxable: Bool
    let giftCard: Bool
    let fulfillmentService: String
    let grams: Int
    let appliedDiscount: Discount?
    let name: String
    let custom: Bool
    let price: String
    let adminGraphqlApiId: String

    enum CodingKeys: String, CodingKey {
        case id
        case variantId = "variant_id"
        case productId = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku
        case vendor
        case quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case appliedDiscount = "applied_discount"
        case name
        case custom
        case price
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct Customers: Codable {
    let id: Int64
    let email: String?
    let createdAt: String
    let updatedAt: String
    let firstName: String?
    let lastName: String?
    let ordersCount: Int
    let state: String
    let totalSpent: String
    let lastOrderId: Int64?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency: String
    let phone: String?
    let taxExemptions: [String]
    let adminGraphqlApiId: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderId = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency
        case phone
        case taxExemptions = "tax_exemptions"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct Discount: Codable {
    let amount: String?
    let description: String?
    let value: String?
    let valueType: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case amount, description, value
        case valueType = "value_type"
        case title
    }
}

struct Address: Codable {
    let address1: String?
    let city: String?
    let country: String?
    let zip: String?
    let name: String?
    let phone: String?
}

struct ShippingLine: Codable {
    let title: String?
    let price: String?
    let code: String?
}

