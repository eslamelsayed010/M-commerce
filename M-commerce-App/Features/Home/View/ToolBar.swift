// ToolBar.swift
// M-commerce-App
//
// Created by Macos on 05/06/2025.
//

import SwiftUI

struct ToolBar: View {
    @Binding var searchText: String
    @Binding var filteredProducts: [Product]
    var isHomeView: Bool
    var onPriceFilterChanged: (([Product]) -> Void)?
    @Binding var isFilterActive: Bool?
    var showFilterButton: Bool?

    @State private var showPriceFilter = false
    @State private var priceFilter: Double = 0
    @State private var originalProducts: [Product] = []
    @State private var currentFilteredProducts: [Product] = []

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                TextField("Search ...", text: $searchText)
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
                            .foregroundColor(showPriceFilter ? .orange : .black)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 5)
                }

                Button(action: { print("App logo tapped") }) {
                    Image("online-shop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
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
            originalProducts = filteredProducts
            currentFilteredProducts = filteredProducts
        }
    }
    private var maxPrice: Double {
        originalProducts.compactMap { $0.price }.max() ?? 100.0
    }
    private var currencySymbol: String {
        let currency = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
        return currency < 10 ? "$" : "E£"
    }
    private func filterProductsByPrice() {
        var filtered = originalProducts
        filtered = filtered.filter { product in
            guard let price = product.price else { return false }
            return price <= priceFilter
        }
        currentFilteredProducts = filtered
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
    private func performSearch(_ searchText: String) {
        let productsToSearch = showPriceFilter ? currentFilteredProducts : originalProducts
        let filtered = productsToSearch.filter { product in
            searchText.isEmpty || product.title.lowercased().contains(searchText.lowercased())
        }
        onPriceFilterChanged?(filtered)
        if isFilterActive != nil && !searchText.isEmpty {
            isFilterActive = true
        }
    }
}

struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolBar(
            searchText: .constant(""),
            filteredProducts: .constant([
                Product(
                    id: "1",
                    title: "Sample Product",
                    description: "Description",
                    imageUrls: [],
                    price: 50.0,
                    currencyCode: "$",
                    productType: "Sample",
                    size: nil,
                    color: nil,
                    variantId: "1"
                )
            ]),
            isHomeView: false,
            onPriceFilterChanged: { _ in },
            isFilterActive: .constant(nil),
            showFilterButton: true
        )
    }
}

