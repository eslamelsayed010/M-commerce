//
//  CartServices.swift
//  M-commerce-App
//
//  Created by Macos on 20/06/2025.
//

import Foundation

protocol CartServicesProtocol{
    func addToCart(cart: DraftOrderWrapper) async throws
}

class CartServices: CartServicesProtocol{
    private let baseURL = "https://c30da1df66b50be0ea97b5d360a732e2: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@ios2-ism.myshopify.com/admin/api/2024-10"
    
    func addToCart(cart: DraftOrderWrapper) async throws {
        let strUrl = baseURL + "/draft_orders.json"
        let url = URL(string: strUrl)
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody =  cart
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }
        
        if httpResponse.statusCode != 201 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
}
