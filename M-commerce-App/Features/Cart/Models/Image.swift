//
//  Image.swift
//  M-commerce-App
//
//  Created by Macos on 20/06/2025.
//

import Foundation

struct ProductImagesResponse: Decodable {
    let product: ProductImageData
}

struct ProductImageData: Decodable {
    let images: [ProductImage]
}

struct ProductImage: Decodable {
    let id: Int
    let alt: String?
    let position: Int
    let src: String
}

struct CartItemWithImage: Identifiable {
    let id: Int
    let lineItem: LineItem
    let imageUrl: String
}

