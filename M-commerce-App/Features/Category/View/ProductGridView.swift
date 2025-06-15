//
//  ProductGridView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct ProductGridView<T: BaseProductViewModel>: View {
    @ObservedObject var viewModel: T

    let subcategories = ["Shirts", "Shoes", "Accessories", "All"]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showFilters = false

    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filteredProducts) { product in
                                ProductCardView(product: product)
                            }
                        }.padding()
                    }
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    if showFilters {
                        VStack(spacing: 8) {
                            ForEach(subcategories, id: \.self) { sub in
                                Button(action: {
                                    withAnimation {
                                        viewModel.filterProducts(by: sub == "All" ? nil : sub)
                                        showFilters = false
                                    }
                                }) {
                                    Text(sub)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .padding(.bottom, 70)
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
                    .padding(.trailing, 16)
                }
            }
        }
    }
}

