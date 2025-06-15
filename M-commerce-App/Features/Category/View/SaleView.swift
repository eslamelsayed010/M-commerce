//
//  SaleView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI
struct SaleView: View {
    @StateObject var viewModel = SaleProductViewModel()

    var body: some View {
        ProductGridView(viewModel: viewModel)
            .onAppear { viewModel.loadCategoryProducts() }
    }
}
