//
//  OrderHistoryView.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject var viewModel: OrdersViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Orders...")
                } else if !viewModel.orders.isEmpty {
                    List(viewModel.orders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            VStack(alignment: .leading) {
                                Text(order.name)
                                    .font(.headline)
                                Text("$ \(order.totalPrice)")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                Text("Placed on \(formattedDate(order.createdAt))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } else {
                    Text("No orders found.")
                }
            }
            .navigationTitle("My Orders")
            .task {
                await viewModel.loadOrders()
            }
        }
    }

    func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let display = DateFormatter()
            display.dateStyle = .medium
            return display.string(from: date)
        }
        return isoDate
    }
}
