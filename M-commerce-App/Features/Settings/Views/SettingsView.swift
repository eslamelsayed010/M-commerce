//
//  SettingsView.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    HeaderSettings()
                    UserSettings()
                        .environmentObject(visibilityManager)
                    SupportSettings()
                    AccountSettings()
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
