//
//  SubmitAddrressButton.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct SubmitAddrressButton: View {
    let isLoading: Bool
    let isFormValid: Bool
    let selectedAction: LocationAction
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                    
                    Text("Updating...")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: iconForAction(selectedAction))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(selectedAction.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
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
                    .opacity(isFormValid ? 1.0 : 0.6)
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
            .scaleEffect(isLoading || !isFormValid ? 0.98 : 1.0)
        }
        .disabled(isLoading || !isFormValid)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
        .animation(.easeInOut(duration: 0.2), value: selectedAction)
    }
    
    private func iconForAction(_ action: LocationAction) -> String {
        switch action {
        case .addNew:
            return "plus.circle.fill"
        case .updateExisting:
            return "pencil.circle.fill"
        case .updateDefault:
            return "trash.circle.fill"
        }
    }
}

struct SubmitAddrressButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SubmitAddrressButton(
                isLoading: false,
                isFormValid: true,
                selectedAction: .addNew,
                action: {}
            )
            
            SubmitAddrressButton(
                isLoading: true,
                isFormValid: true,
                selectedAction: .addNew,
                action: {}
            )
            
            SubmitAddrressButton(
                isLoading: false,
                isFormValid: false,
                selectedAction: .addNew,
                action: {}
            )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
