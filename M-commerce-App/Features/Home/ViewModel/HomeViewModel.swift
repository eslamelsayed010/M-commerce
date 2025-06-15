//
//  HomeViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var brands: [Brand] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedBrand: Brand?

    func loadBrands() {
        isLoading = true
        Task {
            do {
                let fetchedBrands = try await fetchBrandsFromGraphQL()
                await MainActor.run {
                    self.brands = fetchedBrands
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    func selectBrand(_ brand: Brand) {
            selectedBrand = brand
        }


    private func fetchBrandsFromGraphQL() async throws -> [Brand] {
        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2024-04/graphql.json")!

        let query = """
        {
          collections(first: 20, query: "collection_type:smart") {
            edges {
              node {
                title
                image {
                  url
                }
              }
            }
          }
        }
        """

        let body = try JSONSerialization.data(withJSONObject: ["query": query])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let edges = (((json?["data"] as? [String: Any])?["collections"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []

        return edges.compactMap { edge in
            guard let node = edge["node"] as? [String: Any],
                  let title = node["title"] as? String else {
                return nil
            }
            let imageUrl = (node["image"] as? [String: Any])?["url"] as? String
            return Brand(name: title, imageUrl: imageUrl)
        }
    }
}
