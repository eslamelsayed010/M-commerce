//
//  ProductsViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 09/06/2025.
//

import Foundation
import Combine

class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let brandName: String

    init(brandName: String) {
        self.brandName = brandName
        loadProducts()
    }

    func loadProducts() {
        isLoading = true
        errorMessage = nil

        fetchProductsForBrand(brandName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    print("Error fetching products: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] products in
                print("Fetched products count: \(products.count)")
                self?.products = products
            }
            .store(in: &cancellables)
    }

    private func fetchProductsForBrand(_ brand: String) -> AnyPublisher<[Product], Error> {
        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2024-04/graphql.json")!

        let query = """
        {
          products(first: 20, query: "tag:\(brand)") {
            edges {
              node {
                id
                title
                descriptionHtml
                productType
                images(first: 3) {
                  edges {
                    node {
                      url
                    }
                  }
                }
                variants(first: 1) {
                  edges {
                    node {
                      price
                      selectedOptions {
                        name
                        value
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> [Product] in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    print("HTTP Response: \(response)")
                    throw URLError(.badServerResponse)
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                let edges = (((json?["data"] as? [String: Any])?["products"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []

                return edges.compactMap { edge in
                    guard let node = edge["node"] as? [String: Any],
                          let title = node["title"] as? String,
                          let productType = node["productType"] as? String,
                          let id = node["id"] as? String,
                          let description = node["descriptionHtml"] as? String else {
                        return nil
                    }

                    let imageEdges = ((node["images"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                    let imageUrls = imageEdges.compactMap { edge in
                        (edge["node"] as? [String: Any])?["url"] as? String
                    }

                    let variantEdges = ((node["variants"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                    let variant = variantEdges.first?["node"] as? [String: Any]
                    let priceString = variant?["price"] as? String
                    let price = Double(priceString ?? "")

                    let options = (variant?["selectedOptions"] as? [[String: Any]]) ?? []
                    let size = options.first(where: { ($0["name"] as? String) == "Size" })?["value"] as? String
                    let color = options.first(where: { ($0["name"] as? String) == "Color" })?["value"] as? String

                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        imageUrls: imageUrls,
                        price: price,
                        currencyCode: "$", 
                        productType: productType,
                        size: size,
                        color: color
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
