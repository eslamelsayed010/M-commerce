//
//  WomenView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct WomenView: View {
    @StateObject var viewModel = WomenProductViewModel()

    var body: some View {
        ProductGridView(viewModel: viewModel)
            .onAppear { viewModel.loadCategoryProducts() }
    }
}
