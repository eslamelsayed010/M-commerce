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
    let draftOrder: GetDraftOrder
    let customerId = Int(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
    
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
                
                Text("$\(draftOrder.totalPrice)")
                HStack {
                    Text("Quantity:")
                    Spacer()
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                            updateCartQuantity(quantity)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
                    .opacity(quantity == 1 ? 0.6 : 1.0)
                    .disabled(quantity == 1)
                    

                    Text("\(quantity)")
                        .frame(width: 20)

                    Button(action: {
                        if quantity < 10 {
                            quantity += 1
                            updateCartQuantity(quantity)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
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
                Task {
                    await viewModel.removeFromCart(productID: Int(draftOrder.id))
                    await viewModel.fetchCartsByCustomerId(customerId: customerId)
                }
            }
        }
        //.toast(successMessage: viewModel.successMessage, errorMessage: viewModel.errorMessage, isShowing: $showToast)
    }
    
    func updateCartQuantity(_ quantity: Int) {
        let item = PutLineItem(id: Int(item.id), variant_id: Int(item.variantId!), product_id: Int(item.productId!), quantity: quantity)
        let darft = PutDraftOrder(id: Int(draftOrder.id), line_items: [item])
        let updateDraft = UpdateDraftOrderRequest(draft_order: darft)
        Task{
            await viewModel.updateCart(cart:updateDraft, orderId:Int(draftOrder.id))
            await viewModel.fetchCartsByCustomerId(customerId: customerId)
        }
    }
    
}
