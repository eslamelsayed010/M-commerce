//
//  FloatingTabBar.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//

import SwiftUI


import SwiftUI


struct FloatingTabBar: View {
    
    var tabs = ["house", "book", "person","cart","heart"]
    
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
                
                PersonView()
                    .tag("person")
                
                CartView()
                    .tag("cart")
                FavoriteView()
                    .tag("heart")
                
            }
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
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
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
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
        .ignoresSafeArea(.all, edges: .all)
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
    }
}
