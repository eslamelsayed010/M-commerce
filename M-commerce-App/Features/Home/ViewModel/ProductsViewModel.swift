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
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private var searchText: String = ""
    @Published var selectedProductId: String? = nil 

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
                
                //MARK: Currency
                let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
                let isCurrencySet = UserDefaults.standard.object(forKey: UserDefaultsKeys.Currency.currency) != nil
                let finalCurrency = isCurrencySet ? currency : 1.0
                
                let updatedProducts = products.map { product in
                    var updatedProduct = product
                    if let price = product.price {
                        updatedProduct.price = price * finalCurrency
                    }
                    return updatedProduct
                }

                self?.products = updatedProducts
                self?.filteredProducts = updatedProducts
            }
            .store(in: &cancellables)
    }

    func filterProducts(bySearch searchText: String) {
        self.searchText = searchText
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func selectProduct(_ product: Product) {
        selectedProductId = product.id
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

                    //MARK: Currency
                    var currencyCode: String
                    let currency: Double? = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
                    if let newCurrency = currency, newCurrency < 10 {
                        currencyCode = "$"
                    } else {
                        currencyCode = "E£"
                    }
                    
                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        imageUrls: imageUrls,
                        price: price,
                        currencyCode: currencyCode,
                        productType: productType,
                        size: size,
                        color: color
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
