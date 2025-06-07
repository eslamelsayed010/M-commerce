//
//  UserSettings.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct UserSettings: View {
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "User")
            
            VStack(spacing: 12) {
                NavigationLink{

                }label: {
                    SettingItem(
                        icon: "location.fill",
                        settingName: "Address",
                        subtitle: "Ismailia",
                        iconColor: .red,
                        onTap: {
                            print("Address")
                        }
                    )
                }
                
                SettingItem(
                    icon: "dollarsign.circle.fill",
                    settingName: "Currency",
                    subtitle: "EGP",
                    iconColor: .green,
                    onTap: {
                        print("Currency")
                    }
                )
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
    }
}

