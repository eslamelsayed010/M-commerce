//
//  SignUpView.swift
//  M-commerce-App
//
//  Created by mac on 05/06/2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    var body: some View { 
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    
                    Text("Welcome!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                        .padding(.top, 50)

                    VStack(spacing: 15) {
            
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
                            Text("Username")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                            
                            TextField("Enter your username", text: $username)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
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
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)

                        Button(action: {
                            
                        }) {
                            Text("Sign Up")
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
                            Text("Or sign up with")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                        }
                        .padding(.horizontal, 20)

                        Button(action: {
                            
                        }) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                        }
                        .padding(.horizontal, 20)

                        Button(action: {
                            
                        }) {
                            Text("Continue as a guest")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                                .underline()
                        }
                        .padding(.bottom, 20)
                        HStack {
                            Text("Already have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)

                            NavigationLink(destination: LoginView()) {
                                Text("Sign in")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(red: 0.96, green: 0.65, blue: 0.42))
                            }
                        }
                    }

                
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true) 
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
