//
//  ProductsView.swift
//  M-commerce-App
//
//  Created by Macos on 09/06/2025.
//
import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel: ProductsViewModel

    private let columns = [
        GridItem(.fixed(160), spacing: 12),
        GridItem(.fixed(160), spacing: 12)
    ]

    init(brandName: String) {
        _viewModel = StateObject(wrappedValue: ProductsViewModel(brandName: brandName))
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading products…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.products.isEmpty {
                Text("No products found")
                    .italic()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.products) { product in
                        VStack(alignment: .leading, spacing: 8) {

                           
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "heart")
                                        .foregroundColor(.red)
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

                           
                            if let urlString = product.imageUrl, let url = URL(string: urlString) {
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

                         
                            Text("\(product.price ?? 0, specifier: "%.2f") \(product.currencyCode ?? "EGP")")

                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.green)

                            Spacer()
                        }
                        .padding()
                        .frame(width: 160)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Products")
    }
}


struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(brandName: "brandName")
    }
}
