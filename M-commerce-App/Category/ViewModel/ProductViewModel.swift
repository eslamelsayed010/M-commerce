//
//  ProductViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 12/06/2025.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedSubcategory: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let pageSize = 50
    private var lastCursor: String? = nil
    private var hasNextPage = true

    func loadAllProducts() {
        products = []
        lastCursor = nil
        hasNextPage = true
        fetchNextPage()
    }

    var filteredProducts: [Product] {
        guard let sub = selectedSubcategory, !sub.isEmpty else {
            return products
        }
        return products.filter {
            $0.productType?.localizedCaseInsensitiveContains(sub) == true
        }
    }

    func filterProducts(by subcategory: String?) {
        selectedSubcategory = subcategory
       
    }

    private func fetchNextPage() {
        guard hasNextPage else { return }

        isLoading = true
        errorMessage = nil

        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2023-07/graphql.json")!
        let query = """
        query ($first: Int!, $after: String) {
          products(first: $first, after: $after) {
            edges {
              cursor
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
            pageInfo {
              hasNextPage
            }
          }
        }
        """

        var variables: [String: Any] = ["first": pageSize]
        if let cursor = lastCursor {
            variables["after"] = cursor
        }

        let bodyDict: [String: Any] = ["query": query, "variables": variables]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> (products: [Product], lastCursor: String?, hasNextPage: Bool) in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard
                    let dataDict = json?["data"] as? [String: Any],
                    let productsDict = dataDict["products"] as? [String: Any],
                    let edges = productsDict["edges"] as? [[String: Any]],
                    let pageInfo = productsDict["pageInfo"] as? [String: Any],
                    let hasNextPage = pageInfo["hasNextPage"] as? Bool
                else {
                    throw URLError(.cannotParseResponse)
                }

                let products: [Product] = edges.compactMap { edge in
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


                let lastCursor = edges.last?["cursor"] as? String
                return (products, lastCursor, hasNextPage)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                self?.products.append(contentsOf: result.products)
                self?.lastCursor = result.lastCursor
                self?.hasNextPage = result.hasNextPage

                
                let types = Set(result.products.compactMap { $0.productType })
                print("Loaded product types: \(types)")

                if self?.hasNextPage == true {
                    self?.fetchNextPage()
                }
            }
            .store(in: &cancellables)
    }
}
