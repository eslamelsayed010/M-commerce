//
//  AccountSettings.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct AccountSettings: View {
    @State private var showingLogoutAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Account")
            
            Button(action: {
                showingLogoutAlert = true
            }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.red.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.red)
                    }
                    
                    Text("Logout")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red.opacity(0.6))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(showingLogoutAlert ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: showingLogoutAlert)
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                print("User logged out")
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

struct AccountSettings_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettings()
    }
}
