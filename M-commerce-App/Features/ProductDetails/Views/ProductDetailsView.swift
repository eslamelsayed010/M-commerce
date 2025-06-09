//
//  ProductDetailsView.swift
//  M-commerce-App
//
//  Created by mac on 10/06/2025.
//

import SwiftUI

struct ProductDetailsView: View {
    @State private var selectedImageIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                Spacer(minLength: 20)

                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.nescafeLight)
                        .frame(height: 260)

                    VStack {
                        TabView(selection: $selectedImageIndex) {
                            ForEach(0..<3) { index in
                                Image("jackets")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 220, height: 300)
                                    .clipped()
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 220)
                        HStack(spacing: 8) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(selectedImageIndex == index ? Color.brown : Color.white.opacity(0.6))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 4)
                    }
                }
                .padding(.horizontal)

                HStack {
                    Text("$110")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("$174")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .strikethrough()

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

                
                Text("Wool Sweater")
                    .font(.headline)
                    .padding(.horizontal)

              
                Text("Lorem ipsum dolor sit amet consectetur. Quam nullam sagittis ut nunc egestas hendrerit. Fermentum sed nunc morbi sed id.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

               
                VStack(alignment: .leading, spacing: 12) {
                    Text("Size")
                        .font(.headline)
                    HStack(spacing: 12) {
                        ForEach(["L", "XL", "XXL"], id: \.self) { size in
                            Text(size)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)

              
                VStack(alignment: .leading, spacing: 12) {
                    Text("Color")
                        .font(.headline)
                    HStack(spacing: 12) {
                        ForEach([Color.black, Color.yellow, Color.red, Color.blue, Color.brown, Color.green], id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            
            HStack(spacing: 12) {
                Button(action: {

                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .cornerRadius(12)
                }

                Button(action: {
                    
                }) {
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.brown)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                }) {
                    Image(systemName: "chevron.left")
                   .foregroundColor(.primary)
                }
            }
        }
    }
}


extension Color {
    static let nescafeLight = Color(red: 0.96, green: 0.92, blue: 0.87)}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailsView()
        }
    }
}
