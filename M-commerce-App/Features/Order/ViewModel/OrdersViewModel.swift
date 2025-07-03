//
//  OrdersViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import Foundation
class OrdersViewModel: ObservableObject {
    @Published var orders: [ShopifyOrder] = []
    @Published var isLoading = false
    @Published var error: String?

    private let service = OrderService()
    private let customerId: Int

    init(customerId: Int) {
        self.customerId = customerId
    }

    @MainActor
    func loadOrders() async {
        isLoading = true
        defer { isLoading = false }

        do {
            self.orders = try await service.fetchOrders(for: customerId)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
