import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct M_commerce_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Group {
                switch authViewModel.currentView {
                case .splash:
                    SplashView()
                        .environmentObject(authViewModel)
                        .environmentObject(FavoritesManager.shared)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .login:
                    LoginView()
                        .environmentObject(authViewModel)
                        .environmentObject(FavoritesManager.shared)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .onboarding:
                    OnboardingView()
                        .environmentObject(authViewModel)
                        .environmentObject(FavoritesManager.shared)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .onboarding2:
                    OnboardingView2()
                        .environmentObject(authViewModel)
                        .environmentObject(FavoritesManager.shared)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .home:
                    FloatingTabBar()
                        .environmentObject(authViewModel)
                        .environmentObject(FavoritesManager.shared)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .emailVerification:
                    EmailVerificationView()
                        .environmentObject(authViewModel)
                        .environmentObject(FavoritesManager.shared)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}


class AuthViewModel: ObservableObject {
    // Published properties to track authentication state and navigation flow
    @Published var isLoggedIn = false
    @Published var currentView: NavigationDestination = .splash
    @Published var isNewUser = false
    @Published var isSigningUp = false
    @Published var isCheckingAuth = false
    @Published var isEmailVerified = false
    @Published var isGuest = false

    // Store splash screen visibility state using UserDefaults
    private var hasSeenSplash: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenSplash") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenSplash") }
    }

    // Define navigation destinations in the app
    enum NavigationDestination {
        case splash
        case login
        case onboarding
        case onboarding2
        case home
        case emailVerification
    }

    // Initializer: Set default view to splash screen
    init() {
        currentView = .splash
    }

    // Check authentication state on app launch
    func checkAuthState() {
        guard !isCheckingAuth else { return }
        isCheckingAuth = true

    
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.isLoggedIn = user != nil
                self.isEmailVerified = user?.isEmailVerified ?? false
        
                if user != nil {
                    self.isGuest = false
                    if !self.isSigningUp {
                        if self.isEmailVerified {
                            self.currentView = self.isNewUser ? .onboarding : .home
                        } else {
                            self.currentView = .emailVerification
                        }
                    }
                } else {
                    
                    self.currentView = self.isGuest ? .home : .login
                    self.isNewUser = false
                    self.isSigningUp = false
                    self.isEmailVerified = false
                }
                self.isCheckingAuth = false
            }
        }
    }

    
    func updateAuthStateAfterLogin(user: User) {
        DispatchQueue.main.async {
            self.isLoggedIn = true
            self.isGuest = false
            self.isEmailVerified = user.isEmailVerified
            self.currentView = self.isEmailVerified ? (self.isNewUser ? .onboarding : .home) : .emailVerification
        }
    }

    // Send email verification from Firebase
    func sendEmailVerification(completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                completion(error)
            }
        } else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."]))
        }
    }

    // Check if email is verified
    func checkEmailVerification(completion: @escaping (Bool, Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.reload { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error reloading user: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        self.isEmailVerified = user.isEmailVerified
                        self.isGuest = false
                        if self.isEmailVerified {
                            self.currentView = self.isNewUser ? .onboarding : .home
                        }
                        completion(user.isEmailVerified, nil)
                    }
                }
            }
        } else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."]))
        }
    }

    // Create a new customer in Shopify
    func createShopifyCustomer(email: String, username: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        let url = URL(string: "https://ios2-ism.myshopify.com/admin/api/2025-04/customers.json")!
        
        let apiKey = "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"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        let customerData: [String: Any] = [
            "customer": [
                "email": email,
                "first_name": username,
                "last_name": "",
                "verified_email": true,
                "send_email_welcome": true
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: customerData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from Shopify"])
                completion(.failure(error))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from Shopify"])
                    completion(.failure(error))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let customer = json["customer"] as? [String: Any],
                       let customerId = customer["id"] as? Int64 {
                        completion(.success(customerId))
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format from Shopify"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                let statusCode = httpResponse.statusCode
                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to create Shopify customer. Status code: \(statusCode)"])
                completion(.failure(error))
            }
        }.resume()
    }

    // Fetch an existing customer from Shopify
    func fetchShopifyCustomer(email: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        let urlString = "https://ios2-ism.myshopify.com/admin/api/2025-04/customers.json?email=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        let apiKey = "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"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch Shopify customer. Status code: \(statusCode)"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from Shopify"])
                completion(.failure(error))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let customers = json["customers"] as? [[String: Any]],
                   let firstCustomer = customers.first,
                   let customerId = firstCustomer["id"] as? Int64 {
                    completion(.success(customerId))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No customer found with this email"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Delete Firebase user account
    func deleteFirebaseUser(completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        } else {
            completion(nil) // No user to delete
        }
    }

    // Cancel sign-up and delete temporary account
    func cancelSignUpAndDeleteAccount(completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(error)
                        return
                    }
                    // Clean up temporary data
                    UserDefaults.standard.removeObject(forKey: "pendingDisplayName")
                    // Reset state
                    self.isLoggedIn = false
                    self.isNewUser = false
                    self.isSigningUp = false
                    self.isEmailVerified = false
                    self.isGuest = false
                    self.currentView = .login
                    // Sign out
                    do {
                        try Auth.auth().signOut()
                        completion(nil)
                    } catch {
                        completion(error)
                    }
                }
            }
        } else {
            // If no user exists, navigate to login
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.isNewUser = false
                self.isSigningUp = false
                self.isEmailVerified = false
                self.isGuest = false
                self.currentView = .login
                UserDefaults.standard.removeObject(forKey: "pendingDisplayName")
                completion(nil)
            }
        }
    }

    // Extract username and customer_id from displayName
    func getCustomerIdAndUsername() -> (username: String?, customerId: Int64?) {
        guard let displayName = Auth.auth().currentUser?.displayName else {
            return (nil, nil)
        }
        let components = displayName.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 2,
              let customerId = Int64(components[1]) else {
            return (displayName, nil)
        }
        return (components[0], customerId)
    }

    // Complete splash screen and navigate to next view
    func completeSplash() {
        hasSeenSplash = true
        currentView = isGuest ? .home : (isLoggedIn ? (isEmailVerified ? (isNewUser ? .onboarding : .home) : .emailVerification) : .login)
    }

    // Start onboarding process
    func startOnboarding() {
        isNewUser = true
        isSigningUp = false
        isGuest = false
        currentView = isEmailVerified ? .onboarding : .emailVerification
    }

    // Navigate to second onboarding view
    func goToOnboarding2() {
        currentView = .onboarding2
    }

    // Complete onboarding and navigate to home view
    func completeOnboarding() {
        isNewUser = false
        currentView = .home
    }

    // Sign out (used in settings)
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            isNewUser = false
            isSigningUp = false
            isEmailVerified = false
            isGuest = false
            currentView = .login
        } catch {
            print("Error signing out: \(error)")
        }
    }

    // Begin sign-up process
    func beginSignUp() {
        isSigningUp = true
        isNewUser = true
        isGuest = false
    }


    func signInAsGuest() {
        DispatchQueue.main.async {
            self.isGuest = true
            self.isLoggedIn = false
            self.isNewUser = false
            self.isSigningUp = false
            self.isEmailVerified = false
            self.currentView = .home
        }
    }


    func signInWithEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                if let user = result?.user {
                    self.isLoggedIn = true
                    self.isGuest = false
                    self.isEmailVerified = user.isEmailVerified
                    self.isNewUser = false
                    self.currentView = user.isEmailVerified ? .home : .emailVerification
                    completion(nil)
                }
            }
        }
    }

    func signInWithGoogle(credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                if let user = result?.user {
                    self.isLoggedIn = true
                    self.isGuest = false
                    self.isEmailVerified = user.isEmailVerified
                    self.startOnboarding()
                    completion(nil)
                }
            }
        }
    }
}
