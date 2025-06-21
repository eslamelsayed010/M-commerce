//
//  ProductCardView.swift
//  M-commerce-App
//
//  Created by Macos on 12/06/2025.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showGuestAlert = false

    var body: some View {
        NavigationLink(destination: ProductDetailsView(product: product)) {
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
                    .buttonStyle(.plain)

                    Spacer()

//                    Button {
//                        if authViewModel.isGuest {
//                            showGuestAlert = true
//                        } else {
//                            print("Add to Cart pressed for product: \(product.title)")
//                        }
//                    } label: {
//                        Image(systemName: "cart")
//                            .foregroundColor(.black)
//                            .padding(6)
//                            .background(Color.white.opacity(0.8))
//                            .clipShape(Circle())
//                    }
//                    .buttonStyle(.plain)
                }

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

                Text(product.title)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(product.currencyCode ?? "$") \(product.price ?? 0, specifier: "%.2f")")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.orange)
            }
            .padding()
            .frame(width: 160)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
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

struct ProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProductCardView(
                product: Product(
                    id: "7575128211521",
                    title: "ADIDAS | CLASSIC BACKPACK",
                    description: "This women's backpack has a glam look...",
                    imageUrls: [
                        "https://cdn.shopify.com/s/files/1/0657/0177/3377/files/product_29_image1.jpg"
                    ],
                    price: 70.00,
                    currencyCode: "EGP",
                    productType: "ACCESSORIES",
                    size: "OS",
                    color: "black",
                    variantId: " "
                )
            )
            .environmentObject(FavoritesManager.shared)
            .environmentObject(AuthViewModel())
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
