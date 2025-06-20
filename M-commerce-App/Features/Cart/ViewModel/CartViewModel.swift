//
//  CartViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class CartViewModel: ObservableObject{
    @Published private(set) var draftOrder: [GetDraftOrder] = []
    @Published private(set) var total: Double = 0
    
    @Published var isLoading = false
   
    @Published var productImages: [Int: String] = [:]
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
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func fetchCartsByCustomerId(customerId: Int) async {
        isLoading = true
        do {
            self.draftOrder = try await cartServices.fetchCartsByCustomerId(cutomerId: customerId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func fetchProductImage(productId: Int) async {
        do {
            let response = try await cartServices.fetchProductDetails(productId: productId)
            
            guard let product = response?.product else {
                return
            }
                    
            if let firstImage = product.images.first {
                let imageUrl = firstImage.src
                self.productImages[productId] = imageUrl
            } else {
                self.productImages[productId] = "placeholder_image_url"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func fetchAllProductImages() async {
        let productIds = Set(draftOrder.flatMap { $0.lineItems.compactMap { Int($0.productId ?? 0) } })
        await withTaskGroup(of: Void.self) { group in
            for productId in productIds {
                group.addTask {
                    await self.fetchProductImage(productId: productId)
                }
            }
        }
    }
    
    @MainActor
    func removeFromCart(productID: Int) async {
        do {
            try await cartServices.deleteFromCart(cartId: productID)
            successMessage = "Remove From cart!"
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

