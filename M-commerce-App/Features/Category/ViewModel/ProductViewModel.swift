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
    @Published private var searchText: String = ""
    @Published var selectedProductId: String? = nil
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

    func filterProducts(by subcategory: String?) {
        selectedSubcategory = subcategory
    }

    func filterProducts(bySearch searchText: String) {
        self.searchText = searchText
    }

    func selectProduct(_ product: Product) {
        selectedProductId = product.id
    }

    private func fetchNextPage() {
        guard hasNextPage else { return }

        isLoading = true
        errorMessage = nil

        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2024-04/graphql.json")!
        let query = """
        query ($first: Int!, $after: String) {
          products(first: $first, after: $after) {
            edges {
              cursor
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

                    let variantId = variant?["id"] as? String ?? ""

                    let options = (variant?["selectedOptions"] as? [[String: Any]]) ?? []
                    let size = options.first(where: { ($0["name"] as? String) == "Size" })?["value"] as? String
                    let color = options.first(where: { ($0["name"] as? String) == "Color" })?["value"] as? String

                    //MARK: Currency
                    var currencyCode: String
                    let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
                    currencyCode = currency < 10 ? "$" : "E£"
                    
                    print("variantId: \(variantId)")
                    
                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        imageUrls: imageUrls,
                        price: price,
                        currencyCode: currencyCode,
                        productType: productType,
                        size: size,
                        color: color,
                        variantId: variantId
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
                
                //MARK: Currency
                let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
                let isCurrencySet = UserDefaults.standard.object(forKey: UserDefaultsKeys.Currency.currency) != nil
                let finalCurrency = isCurrencySet ? currency : 1.0
                
                let updatedProducts = self?.products.map { product in
                    var updatedProduct = product
                    if let price = product.price {
                        updatedProduct.price = price * finalCurrency
                    }
                    return updatedProduct
                }

                self?.products = updatedProducts ?? []
            }
            .store(in: &cancellables)
    }
}

