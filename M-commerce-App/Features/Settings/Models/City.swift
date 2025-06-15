//
//  City.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import Foundation

struct ShippingZonesResponse: Decodable {
    let shipping_zones: [ShippingZone]
}

struct ShippingZone: Decodable {
    let id: Int
    let name: String
    let countries: [ShippingCountry]
}

struct ShippingCountry: Decodable {
    let id: Int
    let name: String
    let provinces: [City]
}

struct City: Identifiable, Decodable{
    let id: Int?
    let name: String?
    let code: String?
}
