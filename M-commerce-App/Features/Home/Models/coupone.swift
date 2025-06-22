//
//  coupone.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import Foundation

struct PriceRules: Decodable{
    let price_rules: [Coupon]
}

struct Coupon: Decodable{
    let id: Int
    let value: String
    let value_type: String
    let title: String
}
