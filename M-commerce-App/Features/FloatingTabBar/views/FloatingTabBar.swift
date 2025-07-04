import SwiftUI

struct FloatingTabBar: View {
    @StateObject var visibilityManager = TabBarVisibilityManager()
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var cartViewModel = CartViewModel(cartServices: CartServices())

    @State private var showGuestAlert = false

    var tabs = ["house", "circle.grid.2x2", "cart", "heart", "person"]
    var tabLabels = ["Home", "Categories", "Cart", "Favorites", "Profile"]

    @State var selectedTab = "house"
    @State var xAxis: CGFloat = 0
    @Namespace var animation

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Color.black.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                HomeView().tag("house")
                CategoryView().tag("circle.grid.2x2")
                CartView().environmentObject(cartViewModel).tag("cart")
                FavoriteView().tag("heart")
                SettingsView().environmentObject(visibilityManager).tag("person")
            }
            .environmentObject(visibilityManager)

            if !visibilityManager.isTabBarHidden {
                tabBarView
            }
        }
        .ignoresSafeArea()
        .alert(isPresented: $showGuestAlert) {
            Alert(
                title: Text("Sign In Required"),
                message: Text("You need to sign in to access this feature. Would you like to sign in now?"),
                primaryButton: .default(Text("Login")) {
                    authViewModel.currentView = .login
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }

    var tabBarView: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.element) { index, image in
                GeometryReader { reader in
                    Button(action: {
                        if authViewModel.isGuest && image != "house" && image != "circle.grid.2x2" {
                            showGuestAlert = true
                        } else {
                            if selectedTab != image {
                                withAnimation {
                                    selectedTab = image
                                    xAxis = reader.frame(in: .global).minX
                                }
                            }
                        }
                    }) {
                        VStack(spacing: 2) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: image)
                                    .font(.system(size: 22, weight: .regular))                                    .foregroundColor(selectedTab == image ? .black : .gray)
                                    .padding(selectedTab == image ? 10 : 0) // smaller highlight circle
                                    .background(
                                        Color.yellow.opacity(selectedTab == image ? 1 : 0)
                                            .clipShape(Circle())
                                    )
                                    .matchedGeometryEffect(id: image, in: animation)
                                    .offset(x: selectedTab == image ? -8 : 0, y: selectedTab == image ? -35 : 0)

                                if image == "cart", cartViewModel.draftOrder.count > 0 {
                                    Text("\(cartViewModel.draftOrder.count)")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: selectedTab == image ? -12 : 0, y: selectedTab == image ? -30 : 0)
                                        .offset(x: 8, y: -8)
                                }
                            }

                           
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .onAppear {
                        if image == tabs.first && xAxis == 0 {
                            DispatchQueue.main.async {
                                xAxis = reader.frame(in: .global).minX
                            }
                        }
                    }
                }
                .frame(width: 40, height: 50) // smaller tab area

                if image != tabs.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .onAppear {
            let customerId = Int(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
            Task {
                cartViewModel.isLoading = true
                await cartViewModel.fetchCartsByCustomerId(customerId: customerId)
                cartViewModel.isLoading = false
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(
            Color.black
                .clipShape(CustomShape(xAxis: xAxis == 0 ? 50 : xAxis))
                .cornerRadius(25)
                .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: -2)
        )
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
}

struct CustomShape: Shape {
    var xAxis: CGFloat

    var animatableData: CGFloat {
        get { xAxis }
        set { xAxis = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        let center = xAxis
        path.move(to: CGPoint(x: center - 50, y: 0))

        let to1 = CGPoint(x: center, y: 30)
        let control1 = CGPoint(x: center - 25, y: 0)
        let control2 = CGPoint(x: center - 25, y: 30)

        let to2 = CGPoint(x: center + 50, y: 0)
        let control3 = CGPoint(x: center + 25, y: 30)
        let control4 = CGPoint(x: center + 25, y: 0)

        path.addCurve(to: to1, control1: control1, control2: control2)
        path.addCurve(to: to2, control1: control3, control2: control4)

        return path
    }
}

struct FloatingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBar()
            .environmentObject(AuthViewModel())
    }
}
