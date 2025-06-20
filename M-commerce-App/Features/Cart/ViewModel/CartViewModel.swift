//
//  CartViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class CartViewModel: ObservableObject{
    @Published private(set) var products: [Product] = []
    @Published private(set) var total: Double = 0
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    private var cartServices: CartServices
    
    init(cartServices: CartServices) {
        self.cartServices = cartServices
    }
    
    @MainActor
    func addToCart(cart: DraftOrderWrapper) async {
        isLoading = true
        do {
            try await cartServices.addToCart(cart: cart)
            successMessage = "Add to cart!"
        } catch let error as ShopifyAPIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func removeFromCart(product: Product){

    }
}

