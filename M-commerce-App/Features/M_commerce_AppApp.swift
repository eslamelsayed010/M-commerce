//
//  M_commerce_AppApp.swift
//  M-commerce-App
//
//  Created by mac on 25/05/2025.
//

import SwiftUI

@main
struct M_commerce_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SettingsView()
//                SplashView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
