//
//  SupportSettings.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct SupportSettings: View {
    @State private var showContactUs = false
    @State private var showAboutUs = false
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Support")
            
            VStack(spacing: 5) {
                SettingItem(
                    icon: "bubble.left.and.bubble.right.fill",
                    settingName: "Contact Us",
                    isSubtitle: false,
                    iconColor: .blue,
                    onTap: {
                        showContactUs = true
                    }
                )
                .sheet(isPresented: $showContactUs) {
                    ContactUsView()
                }
                
                SettingItem(
                    icon: "info.circle.fill",
                    settingName: "About Us",
                    isSubtitle: false,
                    iconColor: .orange,
                    onTap: {
                        showAboutUs = true
                    }
                )
                .sheet(isPresented: $showAboutUs) {
                    AboutUsView()
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct SupportSettings_Previews: PreviewProvider {
    static var previews: some View {
        SupportSettings()
    }
}

