//
//  HomeView.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    let rows = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    @State private var isNavigationActive = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    ToolBar()
                    
                    
                    ImgCouponView()
                    
                    Text("Brands")
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 16) {
                            if viewModel.isLoading {
                                ProgressView("Loading brands…")
                                    .gridCellColumns(2)
                            } else if let error = viewModel.errorMessage {
                                Text("Error: \(error)")
                                    .foregroundColor(.red)
                                    .gridCellColumns(2)
                            } else {
                                ForEach(viewModel.brands) { brand in
                                    Button {
                                        viewModel.selectBrand(brand)
                                        isNavigationActive = true
                                    } label: {
                                        VStack {
                                            if let url = brand.imageUrl.flatMap(URL.init) {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 100, height: 100)
                                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    case .failure:
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .frame(width: 100, height: 100)
                                                            .foregroundColor(.gray)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .foregroundColor(.gray)
                                            }

                                            Text(brand.name)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 120, height: 150)
                                        .background(Color(.systemBackground))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                        .shadow(radius: 5)
                                    }
                                }
                            }
                        }
                        .padding()
                    }

                   
                    NavigationLink(
                        destination: ProductsView(brandName: viewModel.selectedBrand?.name ?? ""),
                        isActive: $isNavigationActive,
                        label: {
                            EmptyView()
                        }
                    )
                    .hidden()



                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
           
            
            .onAppear {
                viewModel.loadBrands()
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
