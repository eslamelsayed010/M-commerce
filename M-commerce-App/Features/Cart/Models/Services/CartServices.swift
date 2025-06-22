//
//  CartServices.swift
//  M-commerce-App
//
//  Created by Macos on 20/06/2025.
//

import Foundation

import Foundation

protocol CartServicesProtocol{
    func addToCart(cart: DraftOrderWrapper) async throws
    func updateCart(cart: UpdateDraftOrderRequest, orderId: Int) async throws
    func deleteFromCart(cartId: Int) async throws
    func fetchProductDetails(productId: Int) async throws  -> ProductImagesResponse?
    func fetchCartsByCustomerId(cutomerId: Int) async throws -> [GetDraftOrder]
    
    func fetchUserAddresses(customerId: Int) async throws -> AddressResponse
}

class CartServices: CartServicesProtocol{
    private let baseURL = "https://c30da1df66b50be0ea97b5d360a732e2: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@ios2-ism.myshopify.com/admin/api/2024-10"
    
    func fetchCartsByCustomerId(cutomerId: Int) async throws -> [GetDraftOrder] {
        let strUrl = baseURL + "/draft_orders.json"
        let url = URL(string: strUrl)
        guard let url = url else{
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(DraftOrdersResponse.self, from: data)
        return response.draftOrders.filter { $0.customer?.id ?? 0 == cutomerId }
    }
    
    func fetchProductDetails(productId: Int) async throws -> ProductImagesResponse? {
        let strUrl = baseURL + "/products/\(productId).json"
        guard let url = URL(string: strUrl) else {
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    return nil
                }
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                _ = String(jsonString.prefix(500))
            }
            
            let decodedResponse = try JSONDecoder().decode(ProductImagesResponse.self, from: data)
            return decodedResponse
            
        } catch let decodingError as DecodingError {
            throw decodingError
        } catch {
            throw error
        }
    }
    
    func addToCart(cart: DraftOrderWrapper) async throws {
        let strUrl = baseURL + "/draft_orders.json"
        guard let url = URL(string: strUrl) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode(cart)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }

        if httpResponse.statusCode != 201 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }

    func updateCart(cart: UpdateDraftOrderRequest, orderId: Int) async throws {
        let strUrl = baseURL + "/draft_orders/\(orderId).json"
        guard let url = URL(string: strUrl) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode(cart)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }

        if httpResponse.statusCode != 201 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }

    
    func deleteFromCart(cartId: Int) async throws {
        let strUrl = baseURL + "/draft_orders/\(cartId).json"
        let url = URL(string: strUrl)
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }
        
        if httpResponse.statusCode != 201 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    func fetchUserAddresses(customerId: Int) async throws -> AddressResponse{
        let url = URL(string: "\(baseURL)/customers/\(customerId)/addresses.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AddressResponse.self, from: data)
        return response
    }
}
