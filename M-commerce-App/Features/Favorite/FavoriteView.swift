//
//  FavoriteView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI
import CoreData
import Combine

struct FavoriteView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @State private var selectedProduct: Product?
    @State private var showDeleteAlert = false
    @State private var showNoInternetAlert = false
    @State private var productToDelete: FavoriteProduct?
    @State private var isLoading = false
    @State private var navigateToDetails = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var refreshID = UUID()

    @FetchRequest(
        entity: FavoriteProduct.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteProduct.title, ascending: true)]
    ) var favoriteProducts: FetchedResults<FavoriteProduct>

    private let columns = [
        GridItem(.fixed(160), spacing: 12),
        GridItem(.fixed(160), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            VStack {
                if favoriteProducts.isEmpty {
                    VStack {
                        Text("No favorite products yet 😊")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(favoriteProducts, id: \.id) { favorite in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Button {
                                            productToDelete = favorite
                                            showDeleteAlert = true
                                        } label: {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red.opacity(0.8))
                                                .padding(6)
                                                .background(Color.white.opacity(0.8))
                                                .clipShape(Circle())
                                        }

                                        Spacer()

                                        Button {
                                        } label: {
                                            Image(systemName: "cart")
                                                .foregroundColor(.black)
                                                .padding(6)
                                                .background(Color.white.opacity(0.8))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding(.horizontal, 2)

                                    if let imageData = favorite.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 100)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                            .cornerRadius(8)
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .foregroundColor(.gray)
                                    }

                                    if isLoading && selectedProduct?.id == favorite.id {
                                        ProgressView()
                                            .frame(height: 20)
                                    } else {
                                        Spacer()
                                    }
                                    
                                    Text(favorite.title ?? "Unknown")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("\(productCurrencyCode(favorite)) \(favorite.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.orange)

                                    Spacer()
                                }
                                .padding()
                                .frame(width: 160)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                .onTapGesture {
                                    handleProductTap(favorite: favorite)
                                }
                            }
                        }
                        .padding()
                        .id(refreshID)
                    }
                }
            }
            .navigationTitle("Favorites")
            .alert("Remove from Favorites?", isPresented: $showDeleteAlert) {
                Button("Yes") {
                    if let productToDelete = productToDelete {
                        favoritesManager.toggleFavorite(product: mapFavoriteToProduct(productToDelete))
                        self.productToDelete = nil
                        refreshID = UUID()
                    }
                }
                Button("Cancel", role: .cancel) {
                    productToDelete = nil
                }
            } message: {
                Text("Are you sure you want to remove this product from your favorites?")
            }
            .alert("No Internet Connection", isPresented: $showNoInternetAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please check your internet connection to view product details.")
            }
            .background(
                NavigationLink(
                    destination: selectedProduct.map { ProductDetailsView(product: $0) },
                    isActive: $navigateToDetails
                ) {
                    EmptyView()
                }
                .hidden()
            )
            
            .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)) { _ in
                refreshID = UUID()
            }
        }
    }

    private func handleProductTap(favorite: FavoriteProduct) {
        print("Tapped product: \(favorite.title ?? "Unknown"), Network: \(networkMonitor.isConnected)")
        
        if networkMonitor.isConnected {
            let productId = extractProductId(from: favorite.id ?? "")
            fetchProductDetails(productId: productId)
        } else {
            showNoInternetAlert = true
        }
    }
    
    private func extractProductId(from graphqlId: String) -> String {
        if graphqlId.contains("gid://shopify/Product/") {
            return graphqlId.replacingOccurrences(of: "gid://shopify/Product/", with: "")
        }
        return graphqlId
    }

    private func fetchProductDetails(productId: String) {
        isLoading = true
        
        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2024-04/graphql.json")!

        let query = """
        {
          product(id: "gid://shopify/Product/\(productId)") {
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
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Product in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    print("HTTP Response: \(response)")
                    throw URLError(.badServerResponse)
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let productData = ((json?["data"] as? [String: Any])?["product"] as? [String: Any]),
                      let title = productData["title"] as? String,
                      let productType = productData["productType"] as? String,
                      let id = productData["id"] as? String,
                      let description = productData["descriptionHtml"] as? String else {
                    throw URLError(.cannotParseResponse)
                }

                let imageEdges = ((productData["images"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                let imageUrls = imageEdges.compactMap { edge in
                    (edge["node"] as? [String: Any])?["url"] as? String
                }

                let variantEdges = ((productData["variants"] as? [String: Any])?["edges"] as? [[String: Any]]) ?? []
                let variant = variantEdges.first?["node"] as? [String: Any]
                let priceString = variant?["price"] as? String
                let price = Double(priceString ?? "")

                let options = (variant?["selectedOptions"] as? [[String: Any]]) ?? []
                let size = options.first(where: { ($0["name"] as? String) == "Size" })?["value"] as? String
                let color = options.first(where: { ($0["name"] as? String) == "Color" })?["value"] as? String
                let variantId = variant?["id"] as? String ?? ""

                return Product(
                    id: id,
                    title: title,
                    description: description,
                    imageUrls: imageUrls,
                    price: price,
                    currencyCode: "$",
                    productType: productType,
                    size: size,
                    color: color,
                    variantId: variantId
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Failed to fetch product: \(error)")
                }
            } receiveValue: { product in
                self.selectedProduct = product
                self.navigateToDetails = true
                print("Fetched product: \(product.title)")
            }
            .store(in: &cancellables)
    }

    private func mapFavoriteToProduct(_ favorite: FavoriteProduct) -> Product {
        return Product(
            id: favorite.id ?? UUID().uuidString,
            title: favorite.title ?? "Unknown",
            description: nil,
            imageUrls: [],
            price: favorite.price,
            currencyCode: productCurrencyCode(favorite),
            productType: nil,
            size: nil,
            color: nil,
            variantId: favorite.variantId ?? ""
        )
    }

    private func productCurrencyCode(_ favorite: FavoriteProduct) -> String {
        return favorite.currencyCode ?? "$"
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(FavoritesManager.shared)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
