import SwiftUI
import FirebaseAuth

struct HeaderSettings: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 50, weight: .thin))
                .foregroundStyle(.linearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(authViewModel.isLoggedIn ? (Auth.auth().currentUser?.email ?? "No email available") : "Guest")
                .font(.title3)
                .foregroundColor(.orange)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

struct HeaderSettings_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSettings()
            .environmentObject(AuthViewModel())
    }
}
