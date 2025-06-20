//
//  CartView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct CartView: View {
    @StateObject var cartViewModel: CartViewModel = CartViewModel(cartServices: CartServices())
    @State private var showToast = false

    var body: some View {
        ScrollView {
            Text("My Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                
            if cartViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.0)
                    .padding(20)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
            } else {
                if cartViewModel.draftOrder.count > 0 {
                    
                    ForEach(cartViewModel.draftOrder, id: \.id) { draftOrder in
                        ForEach(draftOrder.lineItems, id: \.id) { item in
                            
                            let productId = Int(item.productId ?? 0)
                            let imageUrl = cartViewModel.productImages[productId] ?? ""
                            let draftOrderId = Int(draftOrder.id )
                            
                            ProductRow(item: item, imageUrl: imageUrl, draftOrderId: draftOrderId)
                                .environmentObject(cartViewModel)
                        }
                    }
                    
                    HStack {
                        Text("Your cart total is")
                        Spacer()
                        Text("$300.00")
                            .bold()
                    }
                    .padding()
                    
                    PaymentButton(action: {})
                        .padding()
                        .padding(.bottom, 50)
                } else {
                    Text("Your cart is empty!")
                        .padding(.top, 50)
                }
            }
        }
        .padding(.top)
        .onAppear {
            let customerId = Int(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
            Task {
                await cartViewModel.fetchCartsByCustomerId(customerId: customerId)
                await cartViewModel.fetchAllProductImages()
            }
        }
        .toast(successMessage: cartViewModel.successMessage, errorMessage: cartViewModel.errorMessage, isShowing: $showToast)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
