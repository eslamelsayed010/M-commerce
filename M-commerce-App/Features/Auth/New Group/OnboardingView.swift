// Updated OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            authViewModel.completeOnboarding()
                        }) {
                            Text("Skip")
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                                .padding(8)
                        }
                        .padding(.trailing, 16)
                    }
                    
                    LottieView(name: "onboard")
                        .frame(width: 300, height: 250)
                        .padding(.top, 150)

                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 5) {
                            Text("Discover the")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                            Text("best deals")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                        }
                        Text("at your fingertips.")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Simplicity meets elegance")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Text("design trends for 2025.")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    
                    NavigationLink(
                        destination: OnboardingView2().environmentObject(authViewModel),
                        isActive: Binding(
                            get: { authViewModel.currentView == .onboarding2 },
                            set: { _ in }
                        )
                    ) {
                        Button(action: {
                            authViewModel.goToOnboarding2()
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.4))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
                
                Circle()
                    .stroke(Color(red: 0.96, green: 0.65, blue: 0.42), lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color(red: 0.96, green: 0.65, blue: 0.42), lineWidth: 2)
                            .frame(width: 80, height: 80)
                    )
                    .offset(x: -135, y: -330)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
