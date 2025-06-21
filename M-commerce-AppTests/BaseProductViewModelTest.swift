//
//  BaseProductViewModel.swift
//  M-commerce-AppTests
//
//  Created by Macos on 22/06/2025.
//

import XCTest
@testable import M_commerce_App

final class BaseProductViewModelTest: XCTestCase {

    var viewModel: BaseProductViewModel!

    override func setUpWithError() throws {
        viewModel = BaseProductViewModel()

        viewModel.products = [
            Product(id: "1", title: "Blue Shirt", description: "", imageUrls: [], price: 100, currencyCode: nil, productType: "Shirts", size: "M", color: "Blue", variantId: "v1"),
            Product(id: "2", title: "Red Pants", description: "", imageUrls: [], price: 150, currencyCode: nil, productType: "Pants", size: "L", color: "Red", variantId: "v2"),
            Product(id: "3", title: "Green Shirt", description: "", imageUrls: [], price: 200, currencyCode: nil, productType: "Shirts", size: "S", color: "Green", variantId: "v3")
        ]
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFilterBySubcategory() {
        viewModel.filterProducts(by: "Shirts")
        let result = viewModel.filteredProducts
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.allSatisfy { $0.productType == "Shirts" })
    }

    func testFilterBySearchText() {
        viewModel.filterProducts(bySearch: "pants")
        let result = viewModel.filteredProducts
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Red Pants")
    }

    func testCombinedSearchAndSubcategoryFilter() {
        viewModel.filterProducts(by: "Shirts")
        viewModel.filterProducts(bySearch: "green")
        let result = viewModel.filteredProducts
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Green Shirt")
    }

    func testSelectProduct() {
        let product = viewModel.products[0]
        viewModel.selectProduct(product)
        XCTAssertEqual(viewModel.selectedProductId, product.id)
    }

    func testApplyCurrencyConversion() {
        // Simulate stored currency in UserDefaults
        UserDefaults.standard.set(2.0, forKey: UserDefaultsKeys.Currency.currency)

        let converted = viewModel.applyCurrency(to: viewModel.products)
        XCTAssertEqual(converted[0].price, 200) // 100 * 2
        XCTAssertEqual(converted[1].price, 300) // 150 * 2
    }
}
