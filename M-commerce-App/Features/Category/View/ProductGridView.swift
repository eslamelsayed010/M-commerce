//
//  ProductGridView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct ProductGridView<T: BaseProductViewModel>: View {
    @ObservedObject var viewModel: T
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var hasNavigated = false
    @State private var selectedProduct: Product?
    
   // let subcategories = ["Shirts", "Shoes", "Accessories", "All"]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            ToolBar(
                searchText: $searchText,
                filteredProducts: .constant(viewModel.filteredProducts),
                isHomeView: false,
                onPriceFilterChanged: { viewModel.products = $0 },
                isFilterActive: .constant(nil),
                showFilterButton: true
            )
            ZStack {
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else if viewModel.filteredProducts.isEmpty {
                        Text("No products found")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
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
                                            print("Navigating to ProductDetailsView for product: \(product.title)")
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
                        
//                        if showFilters {
//                            VStack(spacing: 8) {
//                                ForEach(subcategories, id: \.self) { sub in
//                                    Button(action: {
//                                        withAnimation {
//                                            viewModel.filterProducts(by: sub == "All" ? nil : sub)
//                                            showFilters = false
//                                        }
//                                    }) {
//                                        Text(sub)
//                                            .padding(.horizontal)
//                                            .padding(.vertical, 8)
//                                            .background(Color.white)
//                                            .foregroundColor(.black)
//                                            .cornerRadius(10)
//                                            .shadow(radius: 2)
//                                    }
//                                }
//                            }
//                            .padding(.bottom, 70)
//                            .transition(.scale)
//                        }
                        
//                        Button(action: {
//                            withAnimation {
//                                showFilters.toggle()
//                            }
//                        }) {
//                            Image(systemName: "slider.horizontal.3")
//                                .font(.title)
//                                .padding()
//                                .background(Color.black)
//                                .foregroundColor(.white)
//                                .clipShape(Circle())
//                                .shadow(radius: 4)
//                        }
                        .padding(.bottom, 40)
                        .padding(.trailing, 16)
                    }
                }
            }
        }
        .navigationTitle("Products")
        .onAppear {
            print("ProductGridView appeared")
            if hasNavigated {
                searchText = ""
                viewModel.filterProducts(bySearch: "")
                hasNavigated = false
            }
        }
        .onChange(of: searchText) { newValue in
            viewModel.filterProducts(bySearch: newValue)
        }
    }
}
