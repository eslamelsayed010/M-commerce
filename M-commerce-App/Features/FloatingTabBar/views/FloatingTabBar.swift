import SwiftUI

struct FloatingTabBar: View {
    @StateObject var visibilityManager = TabBarVisibilityManager()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showGuestAlert = false

    var tabs = ["house", "book", "person", "cart", "heart"]
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
                HomeView()
                    .tag("house")
                CategoryView()
                    .tag("book")
                SettingsView()
                    .environmentObject(visibilityManager)
                    .tag("person")
                CartView()
                    .tag("cart")
                FavoriteView()
                    .tag("heart")
            }
            .environmentObject(visibilityManager)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    updateXAxisForSelectedTab()
                }
            }
            .onChange(of: visibilityManager.isTabBarHidden) { isHidden in
                if !isHidden {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        updateXAxisForSelectedTab()
                    }
                }
            }
            .onChange(of: selectedTab) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    updateXAxisForSelectedTab()
                }
            }

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
            ForEach(tabs, id: \.self) { image in
                GeometryReader { reader in
                    Button(action: {
                        if authViewModel.isGuest && image != "house" && image != "book" {
                            showGuestAlert = true
                        } else {
                            withAnimation {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).midX
                            }
                        }
                    }) {
                        Image(systemName: image)
                            .font(.system(size: 22, weight: .regular))
                            .foregroundColor(selectedTab == image ? .black : .gray)
                            .padding(selectedTab == image ? 15 : 0)
                            .background(Color.yellow.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                            .matchedGeometryEffect(id: image, in: animation)
                            .offset(x: selectedTab == image ? -10 : 0, y: selectedTab == image ? -50 : 0)
                    }
                    .onAppear {
                        if image == selectedTab {
                            xAxis = reader.frame(in: .global).midX
                        }
                    }
                }
                .frame(width: 20.0, height: 25.0)

                if image != tabs.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical)
        .background(
            Color.black
                .clipShape(CustomShape(xAxis: xAxis))
                .cornerRadius(30)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal)
        .padding(.bottom, 4)
    }

    private func updateXAxisForSelectedTab() {
        guard let index = tabs.firstIndex(of: selectedTab) else { return }
        let screenWidth = UIScreen.main.bounds.width - 60 
        let tabSpacing = screenWidth / CGFloat(tabs.count)
        withAnimation {
            xAxis = (tabSpacing * CGFloat(index)) + (tabSpacing / 2) + 30
        }
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

        let to1 = CGPoint(x: center, y: 35)
        let control1 = CGPoint(x: center - 25, y: 0)
        let control2 = CGPoint(x: center - 25, y: 35)

        let to2 = CGPoint(x: center + 50, y: 0)
        let control3 = CGPoint(x: center + 25, y: 35)
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
