//
//  Address.swift
//  M-commerce-App
//
//  Created by Macos on 13/06/2025.
//

import Foundation

struct ShopifyAddress: Codable {
    let id: Int?
    var address1: String
    var address2: String?
    var city: String
    var province: String
    var phone: String?
    var zip: String
    var lastName: String
    var firstName: String
    var country: String
    var isDefault: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, address1, address2, city, province, phone, zip, country
        case lastName = "last_name"
        case firstName = "first_name"
        case isDefault = "default"
    }
}

struct ShopifyCustomer: Codable {
    let id: Int
    var addresses: [ShopifyAddress]?
    var default_address: ShopifyAddress?
}

struct CustomerResponse: Codable {
    let customer: ShopifyCustomer
}

struct AddressResponse: Codable {
    let address: ShopifyAddress
}

struct AddressRequest: Codable {
    let address: ShopifyAddress
}

struct CustomerRequest: Codable {
    let customer: ShopifyCustomer
}

enum LocationAction: String, CaseIterable {
    case updateExisting = "Update Existing Address"
    case addNew = "Add New Address"
    case updateDefault = "Update Default Address"
}

