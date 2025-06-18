
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var emailError = false
    @State private var passwordError = false
    @State private var isLoggingIn = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Text("Welcome Back!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                        .padding(.top, 70)

                    Text("Login to your account")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)

                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                            
                            TextField("Enter your email", text: $email)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(emailError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textContentType(.none)
                            
                            if emailError {
                                Text("This field is required")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 5)
                            }
                        }
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))

                            HStack {
                                Group {
                                    if showPassword {
                                        TextField("Enter your password", text: $password)
                                    } else {
                                        SecureField("Enter your password", text: $password)
                                    }
                                }
                                .padding()
                                .disableAutocorrection(true)
                                .textContentType(.none)

                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 10)
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(passwordError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            
                            if passwordError {
                                Text("This field is required")
                                    .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                            }
                        }
                        .padding(.horizontal, 20)

                        NavigationLink(
                            destination: destinationView(),
                            isActive: Binding(
                                get: { authViewModel.currentView == .onboarding || authViewModel.currentView == .home },
                                set: { _ in }
                            )
                        ) {
                            Button(action: {
                                loginWithEmail()
                            }) {
                                ZStack {
                                    Color(red: 0.2, green: 0.2, blue: 0.4)
                                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                        .cornerRadius(10)
                                    
                                    if isLoggingIn {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(width: 24, height: 24)
                                    } else {
                                        Text("Login")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .disabled(isLoggingIn)
                            }
                        }

                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .frame(maxWidth: .infinity / 2)
                            Text("Or login with")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .frame(maxWidth: .infinity / 2)
                        }
                        .padding(.horizontal, 20)

                        Button(action: {
                            signInWithGoogle()
                        }) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                        }
                        .padding(.horizontal, 20)

                        Button(action: {
                            signInAsGuest()
                        }) {
                            Text("Continue as a guest")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                                .underline()
                        }

                        NavigationLink(
                            destination: SignUpView()
                                .environmentObject(authViewModel)
                                .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                            }
                        }
                    }
                    .padding(.top, 20)
                    Spacer()
                }
                .alert(isPresented: $showingError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        if authViewModel.isNewUser {
            OnboardingView()
                .environmentObject(authViewModel)
        } else {
            HomeView()
                .environmentObject(authViewModel)
        }
    }

    private func loginWithEmail() {
        emailError = false
        passwordError = false
        showingError = false

        if email.isEmpty && password.isEmpty {
            emailError = true
            passwordError = true
            return
        } else if email.isEmpty {
            emailError = true
            return
        } else if password.isEmpty {
            passwordError = true
            return
        }

        isLoggingIn = true

        // استخدام الدالة من AuthViewModel
        authViewModel.signInWithEmail(email: email, password: password) { error in
            DispatchQueue.main.async {
                self.isLoggingIn = false
                if let error = error as NSError? {
                    print("Firebase Error Code: \(error.code)")
                    print("Firebase Error Description: \(error.localizedDescription)")

                    switch error.code {
                    case AuthErrorCode.wrongPassword.rawValue,
                         AuthErrorCode.invalidEmail.rawValue,
                         AuthErrorCode.invalidCredential.rawValue:
                        self.errorMessage = "The email or password is incorrect. Please check your credentials and try again."
                    case AuthErrorCode.userNotFound.rawValue:
                        self.errorMessage = "No account found with this email. Please sign up."
                    case AuthErrorCode.tooManyRequests.rawValue:
                        self.errorMessage = "Too many attempts. Please try again later."
                    case AuthErrorCode.networkError.rawValue:
                        self.errorMessage = "Network error. Please check your internet connection and try again."
                    case 17499:
                        self.errorMessage = "An unexpected error occurred. Please try again or contact support."
                    default:
                        self.errorMessage = "An error occurred: \(error.localizedDescription)"
                    }
                    self.showingError = true
                }
            }
        }
    }

    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Unable to configure Google Sign-In. Please try again."
            showingError = true
            return
        }
        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "Unable to access the app's root view. Please try again."
            showingError = true
            return
        }

        isLoggingIn = true
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            DispatchQueue.main.async {
                self.isLoggingIn = false
                if let error = error {
                    self.errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                    self.showingError = true
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self.errorMessage = "Failed to retrieve Google authentication token."
                    self.showingError = true
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            
                self.authViewModel.signInWithGoogle(credential: credential) { error in
                    if let error = error {
                        self.errorMessage = "Failed to sign in with Google: \(error.localizedDescription)"
                        self.showingError = true
                    }
                }
            }
        }
    }

    private func signInAsGuest() {
        isLoggingIn = true
        DispatchQueue.main.async {
            self.isLoggingIn = false
            self.authViewModel.signInAsGuest()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
