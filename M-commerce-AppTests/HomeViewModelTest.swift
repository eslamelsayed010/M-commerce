//
//  HomeViewModelTest.swift
//  M-commerce-AppTests
//
//  Created by Macos on 22/06/2025.
//

import XCTest
@testable import M_commerce_App


final class HomeViewModelTest: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
        viewModel.brands = [
            Brand(name: "Nike", imageUrl: nil),
            Brand(name: "Adidas", imageUrl: nil),
            Brand(name: "Puma", imageUrl: nil)
        ]
        viewModel.filteredBrands = viewModel.brands
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFilterBrandsWithEmptySearch() {
        viewModel.filterBrands(with: "")
        XCTAssertEqual(viewModel.filteredBrands.count, 3)
    }

    func testFilterBrandsWithSearchText() {
        viewModel.filterBrands(with: "ni")
        XCTAssertEqual(viewModel.filteredBrands.count, 1)
        XCTAssertEqual(viewModel.filteredBrands.first?.name, "Nike")
    }

    func testSelectBrand() {
        let brand = Brand(name: "Adidas", imageUrl: nil)
        viewModel.selectBrand(brand)
        XCTAssertEqual(viewModel.selectedBrand?.name, "Adidas")
    }
}
