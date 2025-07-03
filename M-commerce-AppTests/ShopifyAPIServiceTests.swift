//
//  ShopifyAPIServiceTests.swift
//  M-commerce-AppTests
//
//  Created by mac on 26/06/2025.
//

import XCTest
@testable import M_commerce_App

class ShopifyAPIServiceTests: XCTestCase {
    var mockService: MockShopifyAPIService!
    var address: ShopifyAddress!
    
    override func setUp() {
        super.setUp()
        mockService = MockShopifyAPIService()
        address = ShopifyAddress(
            id: 1,
            address1: "123 Test St",
            address2: nil,
            city: "Test City",
            province: "Test Province",
            phone: nil,
            zip: "12345",
            lastName: "Doe",
            firstName: "John",
            country: "Test Country",
            isDefault: false
        )
    }
    
    override func tearDown() {
        mockService = nil
        address = nil
        super.tearDown()
    }
    
    
    // Success Tests with Mocked Responses
    func testUpdateCustomerAddressSuccessMocked() async throws {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = false
        
        // Act
        do {
            try await mockService.updateCustomerAddress(customerId: 123, addressId: 1, address: address)
        } catch {
            XCTFail("updateCustomerAddress failed with error: \(error)")
        }
    }
    
    func testAddNewAddressSuccessMocked() async throws {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = false
        
        // Act
        do {
            try await mockService.addNewAddress(customerId: 123, address: address)
        } catch {
            XCTFail("addNewAddress failed with error: \(error)")
        }
    }
    
    func testUpdateCustomerDefaultAddressSuccessMocked() async throws {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = false
        
        // Act
        do {
            try await mockService.updateCustomerDefaultAddress(customerId: 123, address: address)
        } catch {
            XCTFail("updateCustomerDefaultAddress failed with error: \(error)")
        }
    }
    
    func testFetchCustomerSuccessMocked() async throws {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = false
        
        // Act
        let customer = try await mockService.fetchCustomer(customerId: 123)
        
        // Assert
        XCTAssertEqual(customer.id, 123)
        XCTAssertEqual(customer.addresses?.count ?? 0, 0, "Expected empty addresses array")
    }
    
    // Failure Tests with Mocked Responses
    func testUpdateCustomerAddressFailureMocked() async {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = true
        
        // Act & Assert
        do {
            try await mockService.updateCustomerAddress(customerId: 123, addressId: 1, address: address)
            XCTFail("Expected error but call succeeded")
        } catch {
            XCTAssertTrue(error is ShopifyAPIError, "Expected ShopifyAPIError")
            if let apiError = error as? ShopifyAPIError {
                switch apiError {
                case .httpError(let statusCode, _):
                    XCTAssertEqual(statusCode, 404, "Expected HTTP 404 error")
                default:
                    XCTFail("Expected httpError, got \(apiError)")
                }
            }
        }
    }
    
    func testAddNewAddressFailureMocked() async {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = true
        
        // Act & Assert
        do {
            try await mockService.addNewAddress(customerId: 123, address: address)
            XCTFail("Expected error but call succeeded")
        } catch {
            XCTAssertTrue(error is ShopifyAPIError, "Expected ShopifyAPIError")
            if let apiError = error as? ShopifyAPIError {
                switch apiError {
                case .httpError(let statusCode, _):
                    XCTAssertEqual(statusCode, 404, "Expected HTTP 404 error")
                default:
                    XCTFail("Expected httpError, got \(apiError)")
                }
            }
        }
    }
    
    func testUpdateCustomerDefaultAddressFailureMocked() async {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = true
        
        // Act & Assert
        do {
            try await mockService.updateCustomerDefaultAddress(customerId: 123, address: address)
            XCTFail("Expected error but call succeeded")
        } catch {
            XCTAssertTrue(error is ShopifyAPIError, "Expected ShopifyAPIError")
            if let apiError = error as? ShopifyAPIError {
                switch apiError {
                case .httpError(let statusCode, _):
                    XCTAssertEqual(statusCode, 404, "Expected HTTP 404 error")
                default:
                    XCTFail("Expected httpError, got \(apiError)")
                }
            }
        }
    }
    
    func testFetchCustomerFailureMocked() async {
        // Arrange
        mockService.shouldUseRealImplementation = false
        mockService.shouldSimulateError = true
        
        // Act & Assert
        do {
            _ = try await mockService.fetchCustomer(customerId: 123)
            XCTFail("Expected error but call succeeded")
        } catch {
            XCTAssertTrue(error is ShopifyAPIError, "Expected ShopifyAPIError")
            if let apiError = error as? ShopifyAPIError {
                switch apiError {
                case .httpError(let statusCode, _):
                    XCTAssertEqual(statusCode, 404, "Expected HTTP 404 error")
                default:
                    XCTFail("Expected httpError, got \(apiError)")
                }
            }
        }
    }
}
