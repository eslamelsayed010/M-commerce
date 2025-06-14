//
//  CustomCollection.swift
//  M-commerce-App
//
//  Created by Macos on 12/06/2025.
//

import Foundation
struct CustomCollection: Identifiable {
    let id: Int
    let title: String
    let handle: String
}
struct Collection: Identifiable, Codable {
    let id: Int
    let title: String
}
