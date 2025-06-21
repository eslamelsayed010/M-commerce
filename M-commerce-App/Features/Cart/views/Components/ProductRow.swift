//
//  ProductRow.swift
//  M-commerce-App
//
//  Created by Macos on 19/06/2025.
//

import SwiftUI

struct ProductRow: View {
    let item: LineItems
    let imageUrl: String
    let draftOrderId: Int
    
    @State private var showToast = false
    @State private var quantity = 1
    @State private var showDeleteAlert = false
    
    @EnvironmentObject var viewModel: CartViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 70)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(item.title)
                        .bold()
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(.leading)
                        .onTapGesture {
                            showDeleteAlert = true
                        }
                }
                
                Text(item.price)
                HStack {
                    Text("Quantity:")
                    Stepper("\(quantity)", value: $quantity, in: 1...10)
                }
                Divider()
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            quantity = item.quantity
        }
        .alert("Are you sure you want to delete this item?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                showToast = true
                let customerId = Int(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
                Task {
                    await viewModel.removeFromCart(productID: draftOrderId)
                    await viewModel.fetchCartsByCustomerId(customerId: customerId)
                }
            }
        }
        .toast(successMessage: viewModel.successMessage, errorMessage: viewModel.errorMessage, isShowing: $showToast)
    }
}
