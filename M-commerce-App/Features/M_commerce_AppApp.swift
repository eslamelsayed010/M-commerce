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
    @Published var isLoggedIn = false
    @Published var currentView: NavigationDestination = .splash
    @Published var isNewUser = false
    @Published var isSigningUp = false
    @Published var isCheckingAuth = false
    @Published var isEmailVerified = false

    private var hasSeenSplash: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenSplash") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenSplash") }
    }

    enum NavigationDestination {
        case splash
        case login
        case onboarding
        case onboarding2
        case home
        case emailVerification
    }

    init() {
        currentView = .splash
    }

    func checkAuthState() {
        guard !isCheckingAuth else { return }
        isCheckingAuth = true

        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.isLoggedIn = user != nil
                self.isEmailVerified = user?.isEmailVerified ?? false

                if user != nil {
                    if !self.isSigningUp {
                        if self.isEmailVerified {
                            self.currentView = self.isNewUser ? .onboarding : .home
                        } else {
                            self.currentView = .emailVerification
                        }
                    }
                } else {
                    self.currentView = .login
                    self.isNewUser = false
                    self.isSigningUp = false
                    self.isEmailVerified = false
                }
                self.isCheckingAuth = false
            }
        }
    }

    func sendEmailVerification(completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                completion(error)
            }
        } else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."]))
        }
    }

    func checkEmailVerification() {
        if let user = Auth.auth().currentUser {
            user.reload { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error reloading user: \(error.localizedDescription)")
                    } else {
                        self.isEmailVerified = user.isEmailVerified
                        if self.isEmailVerified {
                            self.currentView = self.isNewUser ? .onboarding : .home
                        }
                    }
                }
            }
        }
    }

    func completeSplash() {
        hasSeenSplash = true
        currentView = isLoggedIn ? (isEmailVerified ? (isNewUser ? .onboarding : .home) : .emailVerification) : .login
    }

    func startOnboarding() {
        isNewUser = true
        isSigningUp = false
        currentView = isEmailVerified ? .onboarding : .emailVerification
    }

    func goToOnboarding2() {
        currentView = .onboarding2
    }

    func completeOnboarding() {
        isNewUser = false
        currentView = .home
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            isNewUser = false
            isSigningUp = false
            isEmailVerified = false
            currentView = .login
        } catch {
            print("Error signing out: \(error)")
        }
    }

    func beginSignUp() {
        isSigningUp = true
        isNewUser = true
    }
}
