//
//  OrderConfirmationView.swift
//  M-commerce-App
//
//  Created by Macos on 25/06/2025.
//

import SwiftUI

import SwiftUI

struct OrderConfirmationView: View {
    let order: GetDraftOrder
    let email: String
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
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
                Text("Total Price: $\(order.totalPrice)")
                Text("Items:")
                ForEach(order.lineItems, id: \.id) { item in
                    Text("- \(item.title) x\(item.quantity)")
                }
            }
            .padding()

            Button("Back to Home") {
                cartViewModel.clearCart()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Optional: clear after a delay if needed
            // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //     cartViewModel.clearCart()
            // }
        }
    }
}
