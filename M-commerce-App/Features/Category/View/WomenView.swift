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
        VStack(alignment: .leading, spacing: 12) {
            Text("Women Products")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top)

            ProductGridView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadCategoryProducts()
        }
    }
}
