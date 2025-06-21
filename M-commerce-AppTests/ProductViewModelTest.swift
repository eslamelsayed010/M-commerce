//
//  ProductViewModelTest.swift
//  M-commerce-AppTests
//
//  Created by Macos on 22/06/2025.
//

import XCTest
@testable import M_commerce_App

final class ProductViewModelTest: XCTestCase {

    var viewModel: ProductViewModel!

    override func setUpWithError() throws {
        viewModel = ProductViewModel()

        // Inject mock data manually
        viewModel.products = [
            Product(id: "1", title: "Blue Shirt", description: "", imageUrls: [], price: 50, currencyCode: "E£", productType: "Shirts", size: "M", color: "Blue", variantId: "v1"),
            Product(id: "2", title: "Red Pants", description: "", imageUrls: [], price: 80, currencyCode: "E£", productType: "Pants", size: "L", color: "Red", variantId: "v2"),
            Product(id: "3", title: "Green Shirt", description: "", imageUrls: [], price: 60, currencyCode: "E£", productType: "Shirts", size: "S", color: "Green", variantId: "v3")
        ]
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFilterBySubcategory() {
        viewModel.filterProducts(by: "Shirts")
        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { $0.productType == "Shirts" })
    }

    func testFilterBySearchText() {
        viewModel.filterProducts(bySearch: "pants")
        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Red Pants")
    }

    func testFilterBySearchTextAndSubcategory() {
        viewModel.filterProducts(by: "Shirts")
        viewModel.filterProducts(bySearch: "green")
        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Green Shirt")
    }

    func testSelectProduct() {
        let product = viewModel.products[2]
        viewModel.selectProduct(product)
        XCTAssertEqual(viewModel.selectedProductId, product.id)
    }

    func testFilteredProductsWhenEmpty() {
        viewModel.products = []
        let filtered = viewModel.filteredProducts
        XCTAssertTrue(filtered.isEmpty)
    }
}
