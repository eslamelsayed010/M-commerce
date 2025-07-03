//
//  ProductsViewModelTest.swift
//  M-commerce-AppTests
//
//  Created by Macos on 22/06/2025.
//

import XCTest
import Combine
@testable import M_commerce_App

final class ProductsViewModelTest: XCTestCase {
    
    var viewModel: ProductsViewModel!
    var cancellables = Set<AnyCancellable>()

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFilterProductsWithSearchText() {
        // Arrange
        let mockService = MockProductService()
        mockService.mockProducts = [
            Product(id: "1", title: "Nike Shoes", description: "", imageUrls: [], price: 100, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v1"),
            Product(id: "2", title: "Nike Shirt", description: "", imageUrls: [], price: 50, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v2"),
            Product(id: "3", title: "Adidas Pants", description: "", imageUrls: [], price: 70, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v3")
        ]
        
        viewModel = ProductsViewModel(brandName: "Nike", service: mockService)
        
        // Wait for async loading
        let expectation = expectation(description: "Products Loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.filterProducts(bySearch: "nike")
            XCTAssertEqual(self.viewModel.filteredProducts.count, 2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFilterProductsWithEmptySearch() {
        let mockService = MockProductService()
        mockService.mockProducts = [
            Product(id: "1", title: "Nike", description: "", imageUrls: [], price: 100, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v1")
        ]
        viewModel = ProductsViewModel(brandName: "Nike", service: mockService)

        let expectation = expectation(description: "Products Loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.filterProducts(bySearch: "")
            XCTAssertEqual(self.viewModel.filteredProducts.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testSelectProduct() {
        let product = Product(id: "123", title: "Shoe", description: "", imageUrls: [], price: 99, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v1")
        let mockService = MockProductService()
        mockService.mockProducts = [product]
        viewModel = ProductsViewModel(brandName: "Nike", service: mockService)

        let expectation = expectation(description: "Loaded and selected")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.selectProduct(product)
            XCTAssertEqual(self.viewModel.selectedProductId, "123")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadProductsSuccess() {
        let mockService = MockProductService()
        mockService.mockProducts = [
            Product(id: "1", title: "Nike Cap", description: "", imageUrls: [], price: 20, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v1")
        ]
        viewModel = ProductsViewModel(brandName: "Nike", service: mockService)

        let expectation = expectation(description: "Products loaded successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.products.count, 1)
            XCTAssertEqual(self.viewModel.filteredProducts.count, 1)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadProductsFailure() {
        let mockService = MockProductService()
        mockService.shouldFail = true
        viewModel = ProductsViewModel(brandName: "Nike", service: mockService)

        let expectation = expectation(description: "Error loading products")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.viewModel.products.isEmpty)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockProductService: ProductServiceProtocol {
    var shouldFail = false
    var mockProducts: [Product] = []

    func fetchProductsForBrand(_ brand: String) -> AnyPublisher<[Product], Error> {
        if shouldFail {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            return Just(mockProducts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

