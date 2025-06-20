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
    @Published private var searchText: String = "" // Store search text for filtering
    @Published var selectedProductId: String? = nil // Track selected product for navigation

    var categoryKeyword: String { "" }
    private var cancellables = Set<AnyCancellable>()

    var filteredProducts: [Product] {
        var filtered = products
        // Apply subcategory filter
        if let sub = selectedSubcategory, !sub.isEmpty {
            filtered = filtered.filter {
                $0.productType?.localizedCaseInsensitiveContains(sub) == true
            }
        }
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        return filtered
    }

    func filterProducts(by sub: String?) {
        selectedSubcategory = sub
    }

    func filterProducts(bySearch searchText: String) {
        self.searchText = searchText
    }

    func selectProduct(_ product: Product) {
        selectedProductId = product.id
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
                      id   
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


        let variables: [String: Any] = [
            "first": 50,
            "query": "tag:\(categoryKeyword)"
        ]

        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2024-04/graphql.json")!
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
                          let id = node["id"] as? String,
                          let description = node["descriptionHtml"] as? String else {
                        return nil
                    }

                    let imageUrls: [String] = (((node["images"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []).compactMap {
                        ($0["node"] as? [String: Any])?["url"] as? String
                    }

                    let variantEdges = ((node["variants"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                    let variant = variantEdges.first?["node"] as? [String: Any]
                    let priceString = variant?["price"] as? String
                    let priceValue = Double(priceString ?? "")
                    let variantId = variant?["id"] as? String ?? ""

                    let options = (variant?["selectedOptions"] as? [[String: Any]]) ?? []
                    let size = options.first(where: { ($0["name"] as? String) == "Size" })?["value"] as? String
                    let color = options.first(where: { ($0["name"] as? String) == "Color" })?["value"] as? String

                    // MARK: Currency
                    var currencyCode: String
                    let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
                    currencyCode = currency < 10 ? "$" : "E£"

                    
                    print("variantId: \(variantId)")

                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        imageUrls: imageUrls,
                        price: priceValue,
                        currencyCode: currencyCode,
                        productType: node["productType"] as? String,
                        size: size,
                        color: color,
                        variantId: variantId
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
                self?.products = self?.applyCurrency(to: fetched) ?? []
            })
            .store(in: &cancellables)
    }
    
    //MARK: Currency
    func applyCurrency(to products: [Product]) -> [Product] {
        let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
        let isCurrencySet = UserDefaults.standard.object(forKey: UserDefaultsKeys.Currency.currency) != nil
        let finalCurrency = isCurrencySet ? currency : 1.0

        return products.map { product in
            var updated = product
            if let price = product.price {
                updated.price = price * finalCurrency
            }
            return updated
        }
    }
}
