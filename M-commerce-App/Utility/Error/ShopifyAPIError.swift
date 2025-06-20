//
//  ShopifyAPIError.swift
//  M-commerce-App
//
//  Created by Macos on 20/06/2025.
//

import Foundation

enum ShopifyAPIError: Error, LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let data):
            if let errorString = String(data: data, encoding: .utf8) {
                print("Error \(statusCode): \(errorString)")
                return "\(errorString)"
            } else {
                print("HTTP Error: \(statusCode)")
                return "\(statusCode)"
            }
        case .networkError(let error):
            print("Network error: \(error.localizedDescription)")
            return "\(error.localizedDescription)"
        }
    }
}
