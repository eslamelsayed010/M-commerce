//
//  CartViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class CartViewModel: ObservableObject{
    @Published private(set) var draftOrder: [GetDraftOrder] = []
    @Published private(set) var address: [ShopifyAddress] = []
    
    @Published var isLoading = false
    @Published var productImages: [Int: String] = [:]
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var totalPrice: Double = 0.0
    
    let paymentHandler = PaymentHandler()
    @Published var paymentSuccess = false
    
    
    private let customerId: Int = Int(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
    
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
    func updateCart(cart: UpdateDraftOrderRequest, orderId: Int) async {
        do {
            try await cartServices.updateCart(cart: cart, orderId: orderId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func fetchCartsByCustomerId(customerId: Int) async {
        do {
            self.draftOrder = try await cartServices.fetchCartsByCustomerId(cutomerId: customerId)
            self.totalPrice = 0.0
            for order in draftOrder {
                if let price = Double(order.totalPrice) {
                    self.totalPrice += price
                }
            }

        } catch {
            errorMessage = error.localizedDescription
        }
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
            errorMessage = "Remove From cart!"
        }
    }
    
    @MainActor
    func fetchCustomerAddress() async {
        do {
            let response = try await cartServices.fetchUserAddresses(customerId: customerId)
            self.address = response.addresses
        }catch {
            print(error.localizedDescription)
        }
    }
    func pay(selectedAddress: ShopifyAddress? = nil, total: Double,
             onSuccess: @escaping (GetDraftOrder, String) -> Void,
             onFailure: @escaping (String) -> Void) {

        paymentHandler.startPayment(products: draftOrder, total: total, selectedAddress: selectedAddress) { success in
            Task {
                await MainActor.run {
                    self.paymentSuccess = success
                }

                if success, let order = self.draftOrder.first {
                    await self.completeOrder(
                        orderId: Int(order.id),
                        order: order,
                        email: order.customer?.email ?? "guest@example.com",
                        onSuccess: { confirmed, email in
                            onSuccess(confirmed, email)
                        },
                        onFailure: { error in
                            onFailure(error)
                        }
                    )
                }
            }
        }
    }



    @MainActor
    func clearCart() {
        draftOrder = []
        totalPrice = 0.0
        productImages = [:]
    }

    @MainActor
    func completeOrder(
        orderId: Int,
        order: GetDraftOrder,
        email: String,
        onSuccess: @escaping (GetDraftOrder, String) -> Void,
        onFailure: @escaping (String) -> Void
    ) async {
        do {
            try await cartServices.completeDraftOrder(draftOrderId: orderId)

            let confirmed = order
            let confirmedEmail = email

            onSuccess(confirmed, confirmedEmail)

        } catch {
            errorMessage = "Failed to place order: \(error.localizedDescription)"
            onFailure(error.localizedDescription)
        }
    }
    func removeAllProductInCart() async {
        for item in self.draftOrder{
            await removeFromCart(productID: Int(item.id))
        }
    }

}


    
   
    


