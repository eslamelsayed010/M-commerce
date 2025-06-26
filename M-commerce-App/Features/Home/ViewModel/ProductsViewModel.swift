//
//  ProductsViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 09/06/2025.
//

import Foundation
import Combine

protocol ProductServiceProtocol {
    func fetchProductsForBrand(_ brand: String) -> AnyPublisher<[Product], Error>
}

class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private var searchText: String = ""
    @Published var selectedProductId: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let brandName: String
    private let service: ProductServiceProtocol

    init(brandName: String, service: ProductServiceProtocol) {
        self.brandName = brandName
        self.service = service
        loadProducts()
    }

    func loadProducts() {
        isLoading = true
        errorMessage = nil

        service.fetchProductsForBrand(brandName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] products in
                let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
                let isCurrencySet = UserDefaults.standard.object(forKey: UserDefaultsKeys.Currency.currency) != nil
                let finalCurrency = isCurrencySet ? currency : 1.0

                let updatedProducts = products.map {
                    var updated = $0
                    if let price = $0.price {
                        updated.price = price * finalCurrency
                    }
                    return updated
                }

                self?.products = updatedProducts
                self?.filteredProducts = updatedProducts
            }
            .store(in: &cancellables)
    }

    func filterProducts(bySearch searchText: String) {
        self.searchText = searchText
        filteredProducts = searchText.isEmpty
            ? products
            : products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    func selectProduct(_ product: Product) {
        selectedProductId = product.id
    }
}
//======
// DefaultProductService.swift

import Foundation
import Combine

class DefaultProductService: ProductServiceProtocol {
    func fetchProductsForBrand(_ brand: String) -> AnyPublisher<[Product], Error> {
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

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let edges = (((json?["data"] as? [String: Any])?["products"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []

                return edges.compactMap { edge in
                    guard let node = edge["node"] as? [String: Any],
                          let id = node["id"] as? String,
                          let title = node["title"] as? String,
                          let description = node["descriptionHtml"] as? String,
                          let productType = node["productType"] as? String else {
                        return nil
                    }

                    let imageEdges = ((node["images"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                    let imageUrls = imageEdges.compactMap {
                        ($0["node"] as? [String: Any])?["url"] as? String
                    }

                    let variantEdges = ((node["variants"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                    guard let variant = variantEdges.first?["node"] as? [String: Any],
                          let variantId = variant["id"] as? String,
                          let priceString = variant["price"] as? String,
                          let price = Double(priceString) else {
                        return nil
                    }

                    let options = (variant["selectedOptions"] as? [[String: Any]]) ?? []
                    let size = options.first(where: { ($0["name"] as? String)?.lowercased() == "size" })?["value"] as? String
                    let color = options.first(where: { ($0["name"] as? String)?.lowercased() == "color" })?["value"] as? String

                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        imageUrls: imageUrls,
                        price: price,
                        currencyCode: nil,
                        productType: productType,
                        size: size,
                        color: color,
                        variantId: variantId
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

