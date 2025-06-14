import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct M_commerce_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch authViewModel.currentView {
                case .splash:
                    SplashView()
                        .environmentObject(authViewModel)
                case .login:
                    LoginView()
                        .environmentObject(authViewModel)
                case .onboarding:
                    OnboardingView()
                        .environmentObject(authViewModel)
                case .onboarding2:
                    OnboardingView2()
                        .environmentObject(authViewModel)
                case .home:
                    FloatingTabBar()
                        .environmentObject(authViewModel)
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
                if user != nil {
                    if !self.isSigningUp {
                        self.currentView = self.isNewUser ? .onboarding : .home
                    }
                } else {
                    self.currentView = .login
                    self.isNewUser = false
                    self.isSigningUp = false
                }
                self.isCheckingAuth = false
            }
        }
    }
    func completeSplash() {
            hasSeenSplash = true
            currentView = isLoggedIn ? .home : .login
        }
        
        
    
    func startOnboarding() {
        isNewUser = true
        isSigningUp = false
        currentView = .onboarding
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
            currentView = .login
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    func beginSignUp() {
        isSigningUp = true
    }
}
