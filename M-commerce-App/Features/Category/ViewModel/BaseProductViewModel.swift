//
//  BaseProductViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import Foundation
import Combine
class BaseProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedSubcategory: String?

    var categoryKeyword: String { "" }
    private var cancellables = Set<AnyCancellable>()

    var filteredProducts: [Product] {
        guard let filter = selectedSubcategory, !filter.isEmpty else {
            return products
        }
        return products.filter {
            $0.productType?.localizedCaseInsensitiveContains(filter) == true
        }
    }

    func filterProducts(by sub: String?) {
        selectedSubcategory = sub
    }

    func loadCategoryProducts() {
        isLoading = true
        errorMessage = nil

        let query = """
        query ($first: Int!, $query: String) {
          products(first: $first, query: $query) {
            edges {
              node {
                id
                title
                productType
                images(first: 1) {
                  edges {
                    node {
                      url
                    }
                  }
                }
                priceRange {
                  minVariantPrice {
                    amount
                  }
                }
              }
            }
          }
        }
        """

        let variables: [String: Any] = [
            "first": 50,
            "query": "tag:\(categoryKeyword)"
        ]

        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2023-07/graphql.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query, "variables": variables])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, _ in
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard
                    let dataDict = json?["data"] as? [String: Any],
                    let productsDict = dataDict["products"] as? [String: Any],
                    let edges = productsDict["edges"] as? [[String: Any]]
                else {
                    throw URLError(.cannotParseResponse)
                }

                return edges.compactMap { edge in
                    guard let node = edge["node"] as? [String: Any],
                          let title = node["title"] as? String,
                          let id = node["id"] as? String else {
                        return nil
                    }

                    let description = node["description"] as? String

                    let imageUrls: [String] = (((node["images"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []).compactMap {
                        ($0["node"] as? [String: Any])?["url"] as? String
                    }

                    let price = ((node["priceRange"] as? [String: Any])?["minVariantPrice"] as? [String: Any])?["amount"] as? String
                    let priceValue = Double(price ?? "")

                    let currencyCode: String? = nil 
                    let productType = node["productType"] as? String
                    let size = node["size"] as? String
                    let color = node["color"] as? String

                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        imageUrls: imageUrls,
                        price: priceValue,
                        currencyCode: currencyCode,
                        productType: productType,
                        size: size,
                        color: color
                    )
                }

            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] fetched in
                self?.products = fetched
            })
            .store(in: &cancellables)
    }
}
