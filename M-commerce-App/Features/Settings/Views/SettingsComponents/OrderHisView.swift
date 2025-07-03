//
//  OrderHisView.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import SwiftUI

struct OrderHisView: View {
    let customerId: Int

    var body: some View {
        OrderHistoryView(viewModel: OrdersViewModel(customerId: customerId))
    }
}
