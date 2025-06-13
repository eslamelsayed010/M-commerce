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
        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2023-07/graphql.json")!

        let query = """
        {
          products(first: 20, query: "tag:\(brand)") {
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

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> [Product] in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    print("HTTP Response: \(response)") // Debug
                    throw URLError(.badServerResponse)
                }

               
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                
                print("JSON Response: \(String(describing: json))")

                let edges = (((json?["data"] as? [String: Any])?["products"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []

                return edges.compactMap { edge in
                    guard let node = edge["node"] as? [String: Any],
                          let title = node["title"] as? String,
                          let productType = node["productType"] as? String,
                          let id = node["id"] as? String else {
                        return nil
                    }

                    let imageUrl = (((node["images"] as? [String: Any])?["edges"] as? [[String: Any]])?.first?["node"] as? [String: Any])?["url"] as? String

                    let minVariantPrice = (node["priceRange"] as? [String: Any])?["minVariantPrice"] as? [String: Any]
                    let priceString = minVariantPrice?["amount"] as? String
                    let price = Double(priceString ?? "")

                    let currencyCode: String? = nil

                    return Product(
                        id: id,
                        title: title,
                        imageUrl: imageUrl,
                        price: price,
                        currencyCode: currencyCode,
                        productType: productType
                    )
                }

            }
            .eraseToAnyPublisher()
    }
}
