
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct SignUpView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var emailError = false
    @State private var usernameError = false
    @State private var passwordError = false
    @State private var confirmPasswordError = false
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var isSigningUp = false
    @State private var customerId: Int64?
    @State private var isCustomerExisting = false
    @State private var showingSuccessAlert = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Welcome!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                    .padding(.top, 20)
                
                Text("Create your account")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                VStack(spacing: 25) {
                    // Email Field
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
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                        if emailError {
                            Text(emailErrorMessage)
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Username Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Username")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                        
                        TextField("Enter your username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(usernameError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                        if usernameError {
                            Text("This field is required")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Password Field
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
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            
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
                            Text(passwordErrorMessage)
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Confirm Password Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Confirm Password")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                        
                        HStack {
                            Group {
                                if showConfirmPassword {
                                    TextField("Confirm your password", text: $confirmPassword)
                                } else {
                                    SecureField("Confirm your password", text: $confirmPassword)
                                }
                            }
                            .padding()
                            .textInputAutocapitalization(.never) 
                            .disableAutocorrection(true)
                            
                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 10)
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(confirmPasswordError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        
                        if confirmPasswordError {
                            Text("This field is required")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Sign Up Button
                    NavigationLink(
                        destination: EmailVerificationView().environmentObject(authViewModel),
                        isActive: Binding(
                            get: { authViewModel.currentView == .emailVerification },
                            set: { if $0 { authViewModel.currentView = .emailVerification } }
                        )
                    ) {
                        Button(action: {
                            signUpWithEmail()
                        }) {
                            ZStack {
                                Color(red: 0.2, green: 0.2, blue: 0.4)
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                    .cornerRadius(10)
                                
                                if isSigningUp {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(width: 24, height: 24)
                                } else {
                                    Text("Sign Up")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 20)
                            .disabled(isSigningUp)
                        }
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        Text("Or continue with")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                    }
                    .padding(.horizontal, 20)
                    
//                    // Google Sign-In Button
//                    Button(action: {
//                        signInWithGoogle()
//                    }) {
//                        Image("google")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 45, height: 45)
//                    }
                   // .padding(.horizontal, 20)
                    
                    // Guest Sign-In Button
                    Button(action: {
                        signInAsGuest()
                    }) {
                        Text("Continue as a guest")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                            .underline()
                    }
                    .padding(.vertical, 5)
                    
                    // Navigation to Login
                    NavigationLink(
                        destination: LoginView()
                            .environmentObject(authViewModel)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    ) {
                        HStack {
                            Text("Already have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text("Sign in")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard)
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingSuccessAlert) {
            SuccessAlertView(customerId: customerId ?? 0, isExisting: isCustomerExisting) {
                showingSuccessAlert = false
                authViewModel.currentView = .emailVerification
            }
        }
    }
    
    private func validateEmail() -> Bool {
        if email.isEmpty {
            emailErrorMessage = "This field is required"
            emailError = true
            return false
        } else if !email.contains("@") {
            emailErrorMessage = "Email must include '@' symbol"
            emailError = true
            return false
        }
        emailError = false
        return true
    }
    
    private func validatePassword() -> Bool {
        if password.isEmpty {
            passwordErrorMessage = "This field is required"
            passwordError = true
            return false
        } else if password.count <= 4 {
            passwordErrorMessage = "Password must be more than 4 characters"
            passwordError = true
            return false
        } else if !password.contains(where: { $0.isLetter }) || !password.contains(where: { $0.isNumber }) {
            passwordErrorMessage = "Password must include both letters and numbers"
            passwordError = true
            return false
        } else if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            passwordErrorMessage = "Password must include at least one capital letter"
            passwordError = true
            return false
        }
        passwordError = false
        return true
    }
    
    private func signUpWithEmail() {
        // Reset error states before validation
        emailError = false
        usernameError = false
        passwordError = false
        confirmPasswordError = false
        showingError = false

        // Track if all inputs are valid
        var isValid = true

        // Validate username
        if username.isEmpty {
            usernameError = true
            isValid = false
        }

        // Validate email
        if !validateEmail() {
            isValid = false
        }

        // Validate password
        if !validatePassword() {
            isValid = false
        }

        // Validate confirm password
        if confirmPassword.isEmpty {
            confirmPasswordError = true
            isValid = false
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match"
            showingError = true
            isValid = false
        }

        // Exit if validation fails
        if !isValid {
            return
        }

        // Start signup process
        isSigningUp = true
        authViewModel.beginSignUp()

        // Create Firebase user with email and password
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                // Handle Firebase errors
                if let error = error as NSError? {
                    print("Firebase Error Code: \(error.code)")
                    print("Firebase Error Description: \(error.localizedDescription)")

                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        errorMessage = "This email is already in use. Please try a different email."
                    case AuthErrorCode.invalidEmail.rawValue:
                        errorMessage = "The email format is invalid. Please enter a valid email."
                    case AuthErrorCode.weakPassword.rawValue:
                        errorMessage = "The password is too weak. Please use a stronger password."
                    case AuthErrorCode.networkError.rawValue:
                        errorMessage = "Network error. Please check your internet connection and try again."
                    case 17499:
                        errorMessage = "An unexpected error occurred. Please try again or contact support."
                    default:
                        errorMessage = "An error occurred: \(error.localizedDescription)"
                    }
                    showingError = true
                    authViewModel.isSigningUp = false
                    isSigningUp = false
                    return
                }

                // Ensure user was created
                guard let user = result?.user else {
                    errorMessage = "Failed to create user. Please try again."
                    showingError = true
                    authViewModel.isSigningUp = false
                    isSigningUp = false
                    return
                }

                // Create or fetch Shopify customer
                authViewModel.createShopifyCustomer(email: email, username: username) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let newCustomerId):
                            // Log and store new customer ID
                            print("New Shopify Customer Created - Customer ID: \(newCustomerId)")
                            self.customerId = newCustomerId
                            self.isCustomerExisting = false
                            UserDefaults.standard.set("\(username)|\(newCustomerId)", forKey: "pendingDisplayName")
                            self.showingSuccessAlert = true
                            // Send email verification
                            authViewModel.sendEmailVerification { error in
                                if let error = error {
                                    errorMessage = "Failed to send verification email: \(error.localizedDescription)"
                                    showingError = true
                                    authViewModel.cancelSignUpAndDeleteAccount { _ in
                                        authViewModel.isSigningUp = false
                                        isSigningUp = false
                                    }
                                }
                            }
                        case .failure(let error):
                            // Handle Shopify creation failure
                            if let nsError = error as? NSError, nsError.code == 422 {
                                // Fetch existing customer if creation fails due to duplicate email
                                authViewModel.fetchShopifyCustomer(email: email) { fetchResult in
                                    DispatchQueue.main.async {
                                        switch fetchResult {
                                        case .success(let existingCustomerId):
                                            // Log and store existing customer ID
                                            print("Existing Shopify Customer Retrieved - Customer ID: \(existingCustomerId)")
                                            self.customerId = existingCustomerId
                                            self.isCustomerExisting = true
                                            UserDefaults.standard.set("\(username)|\(existingCustomerId)", forKey: "pendingDisplayName")
                                            self.showingSuccessAlert = true
                                            // Send email verification
                                            authViewModel.sendEmailVerification { error in
                                                if let error = error {
                                                    errorMessage = "Failed to send verification email: \(error.localizedDescription)"
                                                    showingError = true
                                                    authViewModel.cancelSignUpAndDeleteAccount { _ in
                                                        authViewModel.isSigningUp = false
                                                        isSigningUp = false
                                                    }
                                                }
                                            }
                                        case .failure(let fetchError):
                                            // Handle fetch failure
                                            errorMessage = "Failed to fetch existing customer: \(fetchError.localizedDescription)"
                                            showingError = true
                                            authViewModel.cancelSignUpAndDeleteAccount { _ in
                                                authViewModel.isSigningUp = false
                                                isSigningUp = false
                                            }
                                        }
                                    }
                                }
                            } else {
                                // Handle other Shopify errors
                                errorMessage = "Failed to create Shopify customer: \(error.localizedDescription)"
                                showingError = true
                                authViewModel.cancelSignUpAndDeleteAccount { _ in
                                    authViewModel.isSigningUp = false
                                    isSigningUp = false
                                }
                            }
                        }
                    }
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
        
        isSigningUp = true
        authViewModel.beginSignUp()
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            DispatchQueue.main.async {
                isSigningUp = false
                if let error = error {
                    errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                    showingError = true
                    authViewModel.isSigningUp = false
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    errorMessage = "Failed to retrieve Google authentication token."
                    showingError = true
                    authViewModel.isSigningUp = false
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                
    
                authViewModel.signInWithGoogle(credential: credential) { error in
                    if let error = error {
                        self.errorMessage = "Failed to sign in with Google: \(error.localizedDescription)"
                        self.showingError = true
                        authViewModel.isSigningUp = false
                    }
                }
            }
        }
    }
    
    private func signInAsGuest() {
        isSigningUp = true
        DispatchQueue.main.async {
            self.isSigningUp = false
            self.authViewModel.signInAsGuest()
        }
    }
}

struct SuccessAlertView: View {
    let customerId: Int64
    let isExisting: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            
            Text(isExisting ? "Welcome Back!" : "Account Created!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Text("Your Customer ID: \(customerId)")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Text("Please verify your email to complete registration.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                onDismiss()
            }) {
                Text("OK")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.4))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
