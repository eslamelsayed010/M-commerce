

import SwiftUI

struct ProductDetailsView: View {
    let product: Product
    @State private var selectedImageIndex = 0
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showGuestAuthentication = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Spacer(minLength: 20)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(height: 260)

                    VStack {
                        TabView(selection: $selectedImageIndex) {
                            ForEach(Array(product.imageUrls.enumerated()), id: \.offset) { index, imageUrl in
                                if let imageUrl = URL(string: imageUrl) {
                                    AsyncImage(url: imageUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 220, height: 220)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 270, height: 285)
                                                .clipped()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 220, height: 220)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .tag(index)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 220)

                        HStack(spacing: 8) {
                            ForEach(0..<product.imageUrls.count, id: \.self) { index in
                                Circle()
                                    .fill(selectedImageIndex == index ? Color.brown : Color.gray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 4)
                    }
                }
                .padding(.horizontal)

                HStack {
                    if let price = product.price, let currencyCode = product.currencyCode {
                        HStack(spacing: 2) {
                            Text("\(currencyCode)")
                                .foregroundColor(Color.brown.opacity(0.7))
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("\(price, specifier: "%.2f")")
                                .foregroundColor(.primary)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("4.3 (440)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Text(product.title)
                    .font(.headline)
                    .padding(.horizontal)

                if let description = product.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }

                if let size = product.size, let color = product.color {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Size")
                                .font(.headline)
                            Text(size)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 6) {
                            Text("Color")
                                .font(.headline)
                            ColorView(colorName: color)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 12) {
                Button {
                    if authViewModel.isGuest {
                        showGuestAuthentication = true
                    } else {
                        print("Add to Cart pressed for product: \(product.title)")
                    }
                } label: {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .cornerRadius(20)
                }

                Button {
                    if authViewModel.isGuest {
                        showGuestAuthentication = true
                    } else {
                        favoritesManager.toggleFavorite(product: product)
                    }
                } label: {
                    Image(systemName: authViewModel.isGuest ? "heart" : (favoritesManager.isFavorite(productID: product.id) ? "heart.fill" : "heart"))
                        .font(.title2)
                        .foregroundColor(authViewModel.isGuest ? .red : (favoritesManager.isFavorite(productID: product.id) ? .red.opacity(0.8) : .red))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .environmentObject(favoritesManager)
        .alert(isPresented: $showGuestAuthentication) {
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

struct ColorView: View {
    let colorName: String

    var body: some View {
        let color = colorFromName(colorName.lowercased())
        return Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }

    func colorFromName(_ name: String) -> Color {
        switch name {
        case "black": return .black
        case "red": return .red
        case "blue": return .blue
        case "yellow": return .yellow
        case "brown": return .brown
        case "green": return .green
        case "white": return .white
        default: return .gray
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(
            product: Product(
                id: "7575128211521",
                title: "ADIDAS | CLASSIC BACKPACK",
                description: "This women's backpack has a glam look...",
                imageUrls: [
                    "https://cdn.shopify.com/s/files/1/0657/0177/3377/files/product_29.jpg"
                ],
                price: 70.00,
                currencyCode: "EGP",
                productType: "ACCESSORIES",
                size: "OS",
                color: "black",
                variantId: ""
            )
        )
        .environmentObject(FavoritesManager.shared)
        .environmentObject(AuthViewModel())
    }
}
