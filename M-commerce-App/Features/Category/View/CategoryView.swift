//
//  CategoryView.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//

import SwiftUI
import Combine
import Foundation

struct CategoryView: View {
    @StateObject var viewModel = ProductViewModel()

    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var hasNavigated = false
    @State private var selectedProduct: Product?

    let subcategories = ["Shirts", "Shoes", "Accessories", "All"]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        ToolBar(
                            searchText: $searchText,
                            filteredProducts: .constant(viewModel.filteredProducts),
                            isHomeView: false,
                            onPriceFilterChanged: { viewModel.products = $0 },
                            isFilterActive: .constant(nil),
                            showFilterButton: true
                        )
                    }
                    if viewModel.isLoading {
                        ProgressView().padding()
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)").foregroundColor(.red).padding()
                    } else if viewModel.filteredProducts.isEmpty {
                        Text("No products found").foregroundColor(.gray).padding()
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
                                    ProductCardView(product: product)
                                        .onTapGesture {
                                            viewModel.selectProduct(product)
                                            selectedProduct = product
                                            hasNavigated = true
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()

                        if showFilters {
                            VStack(spacing: 8) {
                                ForEach(subcategories, id: \.self) { category in
                                    Button(action: {
                                        withAnimation {
                                            viewModel.filterProducts(by: category == "All" ? nil : category)
                                            showFilters = false
                                        }
                                    }) {
                                        Text(category)
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
                                    }
                                }
                            }
                            .padding(.bottom, 60)
                            .transition(.scale)
                        }

                        Button(action: {
                            withAnimation {
                                showFilters.toggle()
                            }
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .onAppear {
                if viewModel.products.isEmpty {
                    viewModel.loadAllProducts()
                }
                if hasNavigated {
                    searchText = ""
                    hasNavigated = false
                    selectedProduct = nil
                }
            }

            .onChange(of: searchText) { newValue in
                viewModel.filterProducts(bySearch: newValue)
            }
            .environmentObject(favoritesManager)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
            .environmentObject(FavoritesManager.shared)
    }
}
