//
//  OrderService.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import Foundation
class OrderService {
    private let baseURL = "https://ios2-ism.myshopify.com/admin/api/2024-10"
    private let token = "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"

    func fetchOrders(for customerId: Int) async throws -> [ShopifyOrder] {
        let urlStr = "\(baseURL)/orders.json?status=any&customer_id=\(customerId)"
        guard let url = URL(string: urlStr) else { return [] }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Access-Token")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode([String: [ShopifyOrder]].self, from: data)
        return decoded["orders"] ?? []
    }
}
