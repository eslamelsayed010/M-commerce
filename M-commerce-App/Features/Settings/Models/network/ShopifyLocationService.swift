//
//  ShopifyLocationService.swift
//  M-commerce-App
//
//  Created by Macos on 13/06/2025.
//

import Foundation

protocol ShopifyAPIServiceProtocol {
    func updateCustomerAddress(customerId: Int, addressId: Int, address: ShopifyAddress) async throws
    func addNewAddress(customerId: Int, address: ShopifyAddress) async throws
    func updateCustomerDefaultAddress(customerId: Int, address: ShopifyAddress) async throws
    func fetchCustomer(customerId: Int) async throws -> ShopifyCustomer
}

class ShopifyAPIService: ShopifyAPIServiceProtocol {
    private let baseURL = "https://c30da1df66b50be0ea97b5d360a732e2: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@ios2-ism.myshopify.com/admin/api/2024-10"
    
    func updateCustomerAddress(customerId: Int, addressId: Int, address: ShopifyAddress) async throws {
        let url = URL(string: "\(baseURL)/customers/\(customerId)/addresses/\(addressId).json")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = AddressRequest(address: address)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    func addNewAddress(customerId: Int, address: ShopifyAddress) async throws {
        let url = URL(string: "\(baseURL)/customers/\(customerId)/addresses.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = AddressRequest(address: address)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }
        
        if httpResponse.statusCode != 201 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    func updateCustomerDefaultAddress(customerId: Int, address: ShopifyAddress) async throws {
        let url = URL(string: "\(baseURL)/customers/\(customerId).json")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var defaultAddress = address
        defaultAddress.isDefault = true
        
        let customer = ShopifyCustomer(id: customerId, addresses: [defaultAddress])
        let requestBody = CustomerRequest(customer: customer)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ShopifyAPIError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw ShopifyAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    func fetchCustomer(customerId: Int) async throws -> ShopifyCustomer {
        let url = URL(string: "\(baseURL)/customers/\(customerId).json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CustomerResponse.self, from: data)
        return response.customer
    }
}

enum ShopifyAPIError: Error, LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let data):
            if let errorString = String(data: data, encoding: .utf8) {
                print("Error \(statusCode): \(errorString)")
                return "\(errorString)"
            } else {
                print("HTTP Error: \(statusCode)")
                return "\(statusCode)"
            }
        case .networkError(let error):
            print("Network error: \(error.localizedDescription)")
            return "\(error.localizedDescription)"
        }
    }
}
