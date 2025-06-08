//
//  UserSettings.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct UserSettings: View {
    @State private var goToAddress = false
    @State private var goToCurrency = false
    @State private var city: String = UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.city) ?? "N/A"
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "User")
            
            VStack(spacing: 5) {
                SettingItem(
                    icon: "location.fill",
                    settingName: "Address",
                    subtitle: city,
                    iconColor: .red,
                    onTap: {
                        goToAddress = true
                    }
                )
                
                NavigationLink(destination: AddressView(), isActive: $goToAddress) {
                    EmptyView()
                }
                .hidden()
                
                SettingItem(
                    icon: "dollarsign.circle.fill",
                    settingName: "Currency",
                    subtitle: "EGP",
                    iconColor: .green,
                    onTap: {
                        goToCurrency = true
                    }
                )
                
                NavigationLink(destination: AddressView(), isActive: $goToCurrency) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .onAppear {
            city = UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.city) ?? "N/A"
        }
    }
}


struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
    }
}

