//
//  KidsView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import Foundation
import SwiftUI

struct KidsView: View {
    @StateObject var viewModel = KidsProductViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kids Products")
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
