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
    
    func addToCart(product: Product){
        products.append(product)
        total += product.price ?? 0.0
    }
    
    func removeFromCart(product: Product){
        products = products.filter{$0.id != product.id}
        total -= product.price ?? 0.0
    }
}
