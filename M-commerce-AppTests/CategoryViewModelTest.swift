//
//  CategoryViewModelTest.swift
//  M-commerce-AppTests
//
//  Created by Macos on 22/06/2025.
//

import XCTest
@testable import M_commerce_App

final class CategoryViewModelTest: XCTestCase {

    func testMenCategoryKeyword() {
        let vm = MenProductViewModel()
        XCTAssertEqual(vm.categoryKeyword, "Men")
    }

    func testWomenCategoryKeyword() {
        let vm = WomenProductViewModel()
        XCTAssertEqual(vm.categoryKeyword, "Women")
    }

    func testKidsCategoryKeyword() {
        let vm = KidsProductViewModel()
        XCTAssertEqual(vm.categoryKeyword, "Kid")
    }

    func testSaleCategoryKeyword() {
        let vm = SaleProductViewModel()
        XCTAssertEqual(vm.categoryKeyword, "Sale")
    }
}
