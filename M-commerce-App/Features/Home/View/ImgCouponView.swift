//
//  ImageGridView.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//
import SwiftUI

struct ImgCouponView: View {
    let imageNames = ["clothes", "shoes", "bag", "shopping"]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 10) {
            // Carousel
            TabView(selection: $currentIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    ZStack {
                        Image(imageNames[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 170)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack {
                            Spacer()
                            Text("Click to get coupon")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.orange, .red]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                                .padding(.bottom, 20)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            .onAppear {
                startTimer()
            }
            
            // Page dots
            HStack(spacing: 6) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? .orange : .gray)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % imageNames.count
            }
        }
    }
}

struct ImgCouponView_Previews: PreviewProvider {
    static var previews: some View {
        ImgCouponView()
    }
}
