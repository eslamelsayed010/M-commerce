//
//  ProductsView.swift
//  M-commerce-App
//
//  Created by Macos on 09/06/2025.
//
import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel: ProductsViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var hasNavigated = false
    @State private var selectedProduct: Product?
    @State private var showGuestAlert = false

    private let columns = [
        GridItem(.fixed(160), spacing: 12),
        GridItem(.fixed(160), spacing: 12)
    ]

    init(brandName: String) {
        _viewModel = StateObject(wrappedValue: ProductsViewModel(brandName: brandName))
    }

    var body: some View {
        VStack {
            ToolBar(searchText: $searchText)
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading products…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredProducts.isEmpty {
                    Text("No products found")
                        .italic()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredProducts) { product in
                            NavigationLink(
                                destination: ProductDetailsView(product: product),
                                isActive: Binding(
                                    get: { selectedProduct?.id == product.id },
                                    set: { isActive in
                                        if !isActive { selectedProduct = nil }
                                    }
                                )
                            ) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Button {
                                            if authViewModel.isGuest {
                                                showGuestAlert = true
                                            } else {
                                                favoritesManager.toggleFavorite(product: product)
                                            }
                                        } label: {
                                            Image(systemName: authViewModel.isGuest ? "heart" : (favoritesManager.isFavorite(productID: product.id) ? "heart.fill" : "heart"))
                                                .foregroundColor(authViewModel.isGuest ? .red : (favoritesManager.isFavorite(productID: product.id) ? .red.opacity(0.8) : .red))
                                                .padding(6)
                                                .background(Color.white.opacity(0.8))
                                                .clipShape(Circle())
                                        }

                                        Spacer()

                                        Button {
                                            if authViewModel.isGuest {
                                                showGuestAlert = true
                                            } else {
                                                print("Add to Cart pressed for product: \(product.title)")
                                            }
                                        } label: {
                                            Image(systemName: "cart")
                                                .foregroundColor(.black)
                                                .padding(6)
                                                .background(Color.white.opacity(0.8))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding(.horizontal, 2)

                                    if let urlString = product.imageUrls.first, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 100)
                                                    .frame(maxWidth: .infinity)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: 100)
                                                    .frame(maxWidth: .infinity)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 100)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                    Text(product.title)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("\(product.currencyCode ?? "$") \(product.price ?? 0, specifier: "%.2f")")
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
                            }
                            .onTapGesture {
                                print("Navigating to ProductDetailsView for product: \(product.title)")
                                viewModel.selectProduct(product)
                                selectedProduct = product
                                hasNavigated = true
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Products")
        .onAppear {
            viewModel.loadProducts()
            if hasNavigated {
                searchText = ""
                hasNavigated = false
            }
        }
        .onChange(of: searchText) { newValue in
            viewModel.filterProducts(bySearch: newValue)
        }
        .environmentObject(favoritesManager)
        .alert(isPresented: $showGuestAlert) {
            Alert(
                title: Text("Sign In Required"),
                message: Text("You need to sign in to add this product to your cart or favorites. Would you like to sign in now?"),
                primaryButton: .default(Text("Login")) {
                    authViewModel.currentView = .login
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(brandName: "Sample Brand")
            .environmentObject(FavoritesManager.shared)
            .environmentObject(AuthViewModel())
    }
}
