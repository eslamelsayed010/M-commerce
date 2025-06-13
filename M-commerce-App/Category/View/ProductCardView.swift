//
//  ProductCardView.swift
//  M-commerce-App
//
//  Created by Macos on 12/06/2025.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                        .padding(6)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                        .padding(6)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
            }

            if let urlString = product.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(height: 100).frame(maxWidth: .infinity)
                    case .success(let image):
                        image.resizable().scaledToFill().frame(height: 100).clipped().cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo").resizable().scaledToFit().frame(height: 100).foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo").resizable().scaledToFit().frame(height: 100).foregroundColor(.gray)
            }

            Spacer()

            Text(product.title)
                .font(.caption)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text("\(product.price ?? 0, specifier: "%.2f") \(product.currencyCode ?? "EGP")") .foregroundColor(.orange)

            Spacer()
        }
        .padding()
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
