//
//  SwiftUIView.swift
//  M-commerce-App
//
//  Created by mac on 04/06/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.18, blue: 0.31)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                
                HStack(spacing: 0) {
                    Text("S")
                        .foregroundColor(.white)
                    Text("h")
                        .foregroundColor(.white)
                    Text("o")
                        .foregroundColor(.white)
                    Text("p")
                        .foregroundColor(.white)
                    Text("T")
                        .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                    Text("r")
                        .foregroundColor(.white)
                    Text("e")
                        .foregroundColor(.white)
                    Text("n")
                        .foregroundColor(.white)
                    Text("d")
                        .foregroundColor(.white)
                }
                .font(.system(size: 40, weight: .bold))
            }
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            OnboardingView()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

