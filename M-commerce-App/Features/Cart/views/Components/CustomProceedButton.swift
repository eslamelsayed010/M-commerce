//
//  CustomProceedButton.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import SwiftUI

struct CustomProceedButton: View {
    var text: String
    var Icon: String = "cart.badge.plus"
    var action: () async -> Void

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: Icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.0, green: 0.584, blue: 0.0),
                                Color(red: 1.0, green: 0.451, blue: 0.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                Color.clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color(red: 1.0, green: 0.4, blue: 0.0).opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
            .scaleEffect(0.98)
        }
        .padding(.horizontal)
    }
}

struct CustomProceedButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomProceedButton(text:"Proceed to checkout", action: {})
    }
}
