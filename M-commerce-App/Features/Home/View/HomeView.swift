//
//  HomeView.swift
//  M-commerce-App
//
//  Created by mac on 11/06/2025.
//

import SwiftUI
import FirebaseAuth


struct HomeeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Welcome to Home!")
                .font(.title)
                .padding()
            
            Button(action: {
                authViewModel.signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
