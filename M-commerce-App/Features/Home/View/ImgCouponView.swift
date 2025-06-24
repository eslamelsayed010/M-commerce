//
//  ImageGridView.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//
import SwiftUI

struct ImgCouponView: View {
    let imageNames = ["clothes", "bag", "shoes", "shopping"]
    @State private var currentIndex = 0
    @StateObject var viewModel: CouponViewModel = CouponViewModel(apiService: CouponServices())
    @State private var showCopyMessage = false

    var body: some View {
        VStack(spacing: 10) {
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
                            Text("get coupon")
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
                    .onTapGesture {
                        let couponTitle: String
                        if index == 0 || index == 1 {
                            guard viewModel.coupons.indices.contains(0) else { return }
                            couponTitle = viewModel.coupons[0].title + viewModel.coupons[0].value
                        } else {
                            guard viewModel.coupons.indices.contains(1) else { return }
                            couponTitle = viewModel.coupons[1].title + viewModel.coupons[1].value
                        }

                        UIPasteboard.general.string = couponTitle
                        showCopyMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopyMessage = false
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            .onAppear {
                //startTimer()
            }
            
            HStack(spacing: 6) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? .orange : .gray)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding()
        .overlay(
            Group {
                if showCopyMessage {
                    Text("Coupon copied!")
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }, alignment: .top
        )

        .onAppear{
            Task{
                await viewModel.getCoupons()
            }
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
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
