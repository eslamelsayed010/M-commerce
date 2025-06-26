//
//  OrderConfirmationView.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import SwiftUI

struct OrderConfirmationView: View {
    let order: GetDraftOrder
    let email: String
    let finalTotal : Double

    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)

                Text("Thank you for your order!")
                    .font(.title)
                    .bold()

                Text("A confirmation email has been sent to:")
                Text(email)
                    .bold()
                    .foregroundColor(.blue)

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Order Number: \(order.id)")
                    Text("Total Price: $\(String(format: "%.2f", finalTotal))")
                    Text("Items:")
                    ForEach(order.lineItems, id: \.id) { item in
                        Text("- \(item.title) x\(item.quantity)")
                    }
                }
                .padding()

                Button("Back to cart") {
                    //cartViewModel.clearCart()
                    navigateToHome = true
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(
                    destination: CartView()
                        .navigationBarBackButtonHidden(true),
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}
