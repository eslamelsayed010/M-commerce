//
//  HeaderSettings.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct HeaderSettings: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 50, weight: .thin))
                .foregroundStyle(.linearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("eslimelseyd@gmail.com")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

struct HeaderSettings_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSettings()
    }
}
