//
//  MenView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI
struct MenView: View {
    @StateObject var viewModel = MenProductViewModel()

    var body: some View {
        ProductGridView(viewModel: viewModel)
            .onAppear { viewModel.loadCategoryProducts() }
    }
}

struct MenView_Previews: PreviewProvider {
    static var previews: some View {
        MenView()
    }
}
