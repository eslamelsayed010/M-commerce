//
//  CouponServices.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import Foundation

protocol CouponServicesProtocol{
    func fetchCoupons() async throws -> PriceRules
}

class CouponServices :CouponServicesProtocol{
    private let baseURL = "https://c30da1df66b50be0ea97b5d360a732e2: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@ios2-ism.myshopify.com/admin/api/2024-10"
    
    func fetchCoupons() async throws -> PriceRules {
        let strURL = baseURL + "/price_rules.json"
        let url = URL(string: strURL)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PriceRules.self, from: data)
        return response
    }
}
