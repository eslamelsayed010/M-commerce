import Foundation
@testable import M_commerce_App

class MockShopifyAPIService: ShopifyAPIServiceProtocol {
    private let realService: ShopifyAPIService
    var shouldUseRealImplementation = true
    var shouldSimulateError = false
    
    init(realService: ShopifyAPIService = ShopifyAPIService()) {
        self.realService = realService
    }
    
    func updateCustomerAddress(customerId: Int, addressId: Int, address: ShopifyAddress) async throws {
        if shouldUseRealImplementation {
            try await realService.updateCustomerAddress(customerId: customerId, addressId: addressId, address: address)
        } else if shouldSimulateError {
            throw ShopifyAPIError.httpError(statusCode: 404, data: Data())
        } else {
        }
    }
    
    func addNewAddress(customerId: Int, address: ShopifyAddress) async throws {
        if shouldUseRealImplementation {
            try await realService.addNewAddress(customerId: customerId, address: address)
        } else if shouldSimulateError {
            throw ShopifyAPIError.httpError(statusCode: 404, data: Data())
        } else {
        }
    }
    
    func updateCustomerDefaultAddress(customerId: Int, address: ShopifyAddress) async throws {
        if shouldUseRealImplementation {
            try await realService.updateCustomerDefaultAddress(customerId: customerId, address: address)
        } else if shouldSimulateError {
            throw ShopifyAPIError.httpError(statusCode: 404, data: Data())
        } else {
        }
    }
    
    func fetchCustomer(customerId: Int) async throws -> ShopifyCustomer {
        if shouldUseRealImplementation {
            return try await realService.fetchCustomer(customerId: customerId)
        } else if shouldSimulateError {
            throw ShopifyAPIError.httpError(statusCode: 404, data: Data())
        } else {
            return ShopifyCustomer(id: customerId, addresses: [])
        }
    }
}
