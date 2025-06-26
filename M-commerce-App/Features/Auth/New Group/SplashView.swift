
import SwiftUI

struct SplashView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
            guard !authViewModel.isSigningOut else {
                print("Skipping checkAuthState and completeSplash due to sign-out")
                return
            }
            
            authViewModel.checkAuthState()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    authViewModel.completeSplash()
                }
            }
        }
    }
}
