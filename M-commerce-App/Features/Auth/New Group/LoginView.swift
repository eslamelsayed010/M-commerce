//
//  LoginView.swift
//  M-commerce-App
//
//  Created by mac on 05/06/2025.
//

import SwiftUI


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isActive = false
    @State private var showPassword = false
    @State private var showSignUp = false

    var body: some View {
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
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)

                    Button(action: {
                        isActive = true
                    }) {
                        Text("Login")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.4))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
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
                        
                    }) {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                    }
                    .padding(.horizontal, 20)

                    Button(action: {
                        
                    }) {
                        Text("Continue as a guest")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                            .underline()
                    }

                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)

                        Button(action: {
                            showSignUp = true
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                        }
                    }
                }
                .padding(.top, 20)

                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
        }
        .navigationBarHidden(true) 
        .navigationBarBackButtonHidden(true)
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
