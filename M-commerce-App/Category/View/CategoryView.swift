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
    @ObservedObject var viewModel = ProductViewModel()

    @State private var showFilters = false

    let subcategories = ["Shirts", "Shoes", "Accessories", "All"]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView().padding()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(.red).padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredProducts) { product in
                            ProductCardView(product: product)
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
                    .padding(.bottom , 40)
                }
            }
        }
        .onAppear {
            viewModel.loadAllProducts()
        }

    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
