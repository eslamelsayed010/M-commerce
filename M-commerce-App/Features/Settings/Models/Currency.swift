//
//  Currency.swift
//  M-commerce-App
//
//  Created by Macos on 11/06/2025.
//

import Foundation

struct CurrencyResponse: Decodable{
    let conversion_rates: Currency
}

struct Currency: Decodable{
    let EGP: Double
}
