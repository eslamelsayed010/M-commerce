// ToolBar.swift
// M-commerce-App
//
// Created by Macos on 05/06/2025.
//

import SwiftUI

struct ToolBar: View {
    @Binding var searchText: String
    @Binding var filteredProducts: [Product]
    @Binding var resetFilterTrigger: Bool
    var isHomeView: Bool
    var onPriceFilterChanged: (([Product]) -> Void)?
    @Binding var isFilterActive: Bool?
    var showFilterButton: Bool?

    @State private var showPriceFilter = false
    @State private var priceFilter: Double = 0
    @State private var originalProducts: [Product] = []
    @State private var currentFilteredProducts: [Product] = []
    var searchPlaceholder: String

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                TextField(searchPlaceholder, text: $searchText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .onChange(of: searchText) { newValue in
                        performSearch(newValue)
                    }

                if !isHomeView && (showFilterButton ?? !filteredProducts.isEmpty) {
                    Button(action: {
                        withAnimation {
                            showPriceFilter.toggle()
                            if showPriceFilter {
                                originalProducts = filteredProducts
                                currentFilteredProducts = filteredProducts
                                priceFilter = maxPrice
                                if isFilterActive != nil {
                                    isFilterActive = true
                                }
                            } else {
                                onPriceFilterChanged?(originalProducts)
                                currentFilteredProducts = originalProducts
                                priceFilter = maxPrice
                                if isFilterActive != nil {
                                    isFilterActive = false
                                }
                                if !searchText.isEmpty {
                                    performSearch(searchText)
                                }
                            }
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(showPriceFilter ? .orange : .gray)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 5)
                }
            }
            .padding(.horizontal)

            // Show price Slider if filter is active
            if showPriceFilter {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Filter by Price: \(currencySymbol)\(priceFilter, specifier: "%.2f")")
                        .font(.subheadline)
                        .padding(.horizontal)

                    Slider(value: $priceFilter, in: 0...maxPrice, step: 1) {
                        Text("Price Filter")
                    } onEditingChanged: { _ in
                        filterProductsByPrice()
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
        .onAppear {
            // Reset filter and search state when view appears
            resetFilterAndSearchState()
        }
        .onChange(of: resetFilterTrigger) { _ in
            // Reset filter and search when resetFilterTrigger changes (e.g., on product tap)
            resetFilterAndSearchState()
        }
    }

    // Calculate maximum price based on original products
    private var maxPrice: Double {
        originalProducts.compactMap { $0.price }.max() ?? 100.0
    }

    // Currency symbol based on UserDefaults
    private var currencySymbol: String {
        let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
        return currency < 10 ? "$" : "E£"
    }

    // Filter products based on price and notify parent via callback
    private func filterProductsByPrice() {
        guard !originalProducts.isEmpty else {
            onPriceFilterChanged?([])
            currentFilteredProducts = []
            return
        }
        var filtered = originalProducts
        // Apply price filter
        filtered = filtered.filter { product in
            guard let price = product.price else { return false }
            return price <= priceFilter
        }
        // Update currentFilteredProducts
        currentFilteredProducts = filtered
        // Apply search filter if search text exists
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.title.lowercased().contains(searchText.lowercased())
            }
        }
        onPriceFilterChanged?(filtered)
        if isFilterActive != nil {
            isFilterActive = true
        }
    }

    // Perform search based on filter state
    private func performSearch(_ searchText: String) {
        guard !originalProducts.isEmpty else {
            return // Do not update filteredProducts until data is available
        }
        let productsToSearch = showPriceFilter ? currentFilteredProducts : originalProducts
        let filtered = productsToSearch.filter { product in
            searchText.isEmpty || product.title.lowercased().contains(searchText.lowercased())
        }
        onPriceFilterChanged?(filtered)
        if isFilterActive != nil && !searchText.isEmpty {
            isFilterActive = true
        }
    }

    // Reset filter and search state
    private func resetFilterAndSearchState() {
        showPriceFilter = false
        priceFilter = maxPrice
        // Update originalProducts and currentFilteredProducts with latest filteredProducts
        originalProducts = filteredProducts
        currentFilteredProducts = filteredProducts
        searchText = "" // Clear search text
        if isFilterActive != nil {
            isFilterActive = false
        }
        // Reset products to original state
        onPriceFilterChanged?(originalProducts)
    }
}

//struct ToolBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ToolBar(
//            searchText: .constant(""),
//            filteredProducts: .constant([
//                Product(
//                    id: "1",
//                    title: "Sample Product",
//                    description: "Description",
//                    imageUrls: [],
//                    price: 50.0,
//                    currencyCode: "$",
//                    productType: "Sample",
//                    size: nil,
//                    color: nil,
//                    variantId: "1"
//                )
//            ]),
//            resetFilterTrigger: .constant(false),
//            isHomeView: false,
//            onPriceFilterChanged: { _ in },
//            isFilterActive: .constant(nil),
//            showFilterButton: true
//            searchPlaceholder: "Search For Products",
//        )
//    }
//}
