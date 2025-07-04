//
//  EmailVerificationView.swift
//  M-commerce-App
//
//  Created by mac on 17/06/2025.
//

import SwiftUI
import FirebaseAuth

struct EmailVerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var isSendingVerification = false
    @State private var isCancelingSignUp = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Verify Your Email")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                        .padding(.top, 50)

                    Text("We have sent a verification email to your registered email address. Please check your inbox (and spam/junk folder) and click the link to verify your account.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Button(action: {
                        checkEmailVerification()
                    }) {
                        ZStack {
                            Color(red: 0.2, green: 0.2, blue: 0.4)
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                .cornerRadius(10)
                            Text("I Have Verified My Email")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)

                    Button(action: {
                        isSendingVerification = true
                        authViewModel.sendEmailVerification { error in
                            isSendingVerification = false
                            if let error = error {
                                errorMessage = "Failed to resend verification email: \(error.localizedDescription)"
                                showingError = true
                            } else {
                                errorMessage = "Verification email sent. Please check your inbox."
                                showingError = true
                            }
                        }
                    }) {
                        ZStack {
                            Color.gray.opacity(0.1)
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                .cornerRadius(10)
                            if isSendingVerification {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .frame(width: 24, height: 24)
                            } else {
                                Text("Resend Verification Email")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .disabled(isSendingVerification)

                    Button(action: {
                        isCancelingSignUp = true
                        authViewModel.cancelSignUpAndDeleteAccount { error in
                            DispatchQueue.main.async {
                                isCancelingSignUp = false
                                if let error = error {
                                    errorMessage = "Failed to cancel sign-up: \(error.localizedDescription)"
                                    showingError = true
                                }
                            }
                        }
                    }) {
                        ZStack {
                            if isCancelingSignUp {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                    .frame(width: 24, height: 24)
                            } else {
                                Text("Sign Out")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.red)
                                    .underline()
                            }
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showingError) {
                Alert(title: Text("Message"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func checkEmailVerification() {
        authViewModel.checkEmailVerification { isVerified, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Failed to check verification: \(error.localizedDescription)"
                    showingError = true
                } else if isVerified {
                    if let user = Auth.auth().currentUser {
                        if let displayName = UserDefaults.standard.string(forKey: "pendingDisplayName") {
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.displayName = displayName
                            changeRequest.commitChanges { error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        errorMessage = "Failed to complete registration: \(error.localizedDescription)"
                                        showingError = true
                                        authViewModel.cancelSignUpAndDeleteAccount { _ in }
                                    } else {
                                        UserDefaults.standard.removeObject(forKey: "pendingDisplayName")
                                        // Navigation is handled in AuthViewModel.checkEmailVerification
                                    }
                                }
                            }
                        } else {
                            errorMessage = "Registration data missing. Please try again."
                            showingError = true
                            authViewModel.cancelSignUpAndDeleteAccount { _ in }
                        }
                    }
                }
            }
        }
    }
    struct EmailVerificationView_Previews: PreviewProvider {
        static var previews: some View {
            EmailVerificationView()
                .environmentObject(AuthViewModel())
        }
    }
}
