//
//  ProductsViewModelTest.swift
//  M-commerce-AppTests
//
//  Created by Macos on 22/06/2025.
//

import XCTest
@testable import M_commerce_App

final class ProductsViewModelTest: XCTestCase {

    var viewModel: ProductsViewModel!

    override func setUpWithError() throws {
        // Set up a dummy view model with a fake brand name (it will trigger real network fetch!)
        viewModel = ProductsViewModel(brandName: "Nike")

        // Inject mock product data manually for testable functions
        viewModel.products = [
            Product(id: "1", title: "Nike Shoes", description: "", imageUrls: [], price: 100, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v1"),
            Product(id: "2", title: "Nike Shirt", description: "", imageUrls: [], price: 50, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v2"),
            Product(id: "3", title: "Adidas Pants", description: "", imageUrls: [], price: 70, currencyCode: nil, productType: "", size: nil, color: nil, variantId: "v3")
        ]
        viewModel.filteredProducts = viewModel.products
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFilterProductsWithSearchText() throws {
        viewModel.filterProducts(bySearch: "nike")
        XCTAssertEqual(viewModel.filteredProducts.count, 2)
        XCTAssertTrue(viewModel.filteredProducts.allSatisfy { $0.title.lowercased().contains("nike") })
    }

    func testFilterProductsWithEmptySearch() throws {
        viewModel.filterProducts(bySearch: "")
        XCTAssertEqual(viewModel.filteredProducts.count, viewModel.products.count)
    }

    func testSelectProduct() throws {
        let product = viewModel.products[1]
        viewModel.selectProduct(product)
        XCTAssertEqual(viewModel.selectedProductId, product.id)
    }
}
