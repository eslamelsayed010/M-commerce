
import SwiftUI

// نوع بيانات مخصص لإدارة التنقل عشان خاطري خلي بالكو بلاش لعب هنا
enum NavigationDestination: Hashable {
    case brand(String)
    case category(String)
}

struct HomeView: View {
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var resetFilterTrigger = false
    let rows = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    @State private var navigationPath = NavigationPath()
    @State private var selected: Int? = nil

    let categories = ["Men", "Women", "Kids", "Sale"]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Image("online-shop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 1))
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)

                        Text("ShopTrend")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(.primary)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    ToolBar(
                        searchText: $searchText,
                        filteredProducts: .constant([]),
                        resetFilterTrigger: $resetFilterTrigger,
                        isHomeView: true,
                        onPriceFilterChanged: nil,
                        isFilterActive: .constant(nil),
                        showFilterButton: true,searchPlaceholder: "Search For Brand" );
                    ImgCouponView()
                    
                    VStack {
                        HStack(spacing: 12) {
                            ForEach(0..<categories.count, id: \.self) { index in
                                Button(action: {
                                    selected = index
                                    print("Navigating to category: \(categories[index])")
                                    navigationPath = NavigationPath([NavigationDestination.category(categories[index])])
                                    print("NavigationPath updated: \(navigationPath)")
                                }) {
                                    Text(categories[index])
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(selected == index ? Color.black : Color.gray.opacity(0.3))
                                        .foregroundColor(selected == index ? .white : .black)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 16) {
                            if viewModel.isLoading {
                                ProgressView("Loading brands…")
                                    .gridCellColumns(2)
                            } else if let error = viewModel.errorMessage {
                                Text("Error: \(error)")
                                    .foregroundColor(.red)
                                    .gridCellColumns(2)
                            } else if viewModel.filteredBrands.isEmpty {
                                Text("No brands found")
                                    .foregroundColor(.gray)
                                    .gridCellColumns(2)
                            } else {
                                ForEach(viewModel.filteredBrands) { brand in
                                    Button {
                                        print("Selecting brand: \(brand.name)")
                                        viewModel.selectBrand(brand)
                                        navigationPath = NavigationPath([NavigationDestination.brand(brand.name.lowercased())])
                                        print("NavigationPath updated: \(navigationPath)")
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
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .onAppear {
                viewModel.loadBrands()
                
            }
            .onChange(of: searchText) { newValue in
                viewModel.filterBrands(with: newValue)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .brand(let brandName):
                    ProductsView(brandName: brandName)
                case .category(let categoryName):
                    switch categoryName {
                    case "Men": MenView()
                    case "Women": WomenView()
                    case "Kids": KidsView()
                    case "Sale": SaleView()
                    default: EmptyView()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

