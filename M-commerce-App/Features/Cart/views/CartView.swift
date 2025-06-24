//
//  CartView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct CartView: View {
    @StateObject var cartViewModel: CartViewModel = CartViewModel(cartServices: CartServices())
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager
    @State private var showToast = false
    @State private var goToPlaceOrder = false

    var body: some View {
        NavigationView{
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
                            
                            ProductRow(item: item, imageUrl: imageUrl, draftOrder: draftOrder)
                                .environmentObject(cartViewModel)
                        }
                    }
                    
                    HStack {
                        Text("Your cart total is")
                        Spacer()
                        Text("$\(String(format: "%.2f", cartViewModel.totalPrice))")
                            .bold()
                    }
                    .padding()
                    
                    CustomProceedButton(text: "Proceed to checkout"){
                        goToPlaceOrder = true
                    }
                    .padding(.bottom, 50)
                    
                    NavigationLink(destination: PlaceOrderSheet()
                        .environmentObject(cartViewModel)
                        .environmentObject(visibilityManager)
                                   , isActive: $goToPlaceOrder) {
                        EmptyView()
                    }
                }
                else {
                    Text("Your cart is empty!")
                        .padding(.top, 50)
                }
            }
        }
    }
        .padding(.top)
        .onAppear {
            //visibilityManager.isTabBarHidden = false
            let customerId = Int(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
            Task {
                cartViewModel.isLoading = true
                await cartViewModel.fetchCartsByCustomerId(customerId: customerId)
                cartViewModel.isLoading = false
                await cartViewModel.fetchAllProductImages()
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
