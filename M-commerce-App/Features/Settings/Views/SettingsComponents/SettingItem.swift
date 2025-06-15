//
//  SettingItem.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct SettingItem: View {
    var icon: String
    var settingName: String
    var subtitle: String = ""
    var isSubtitle: Bool = true
    var iconColor: Color = .orange
    var backgroundColor: Color = Color(.systemBackground)
    var onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(settingName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if isSubtitle {
                    Text(subtitle)
                         .font(.system(size: 14))
                         .foregroundColor(.secondary)
                }

            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.tertiary)

        }
        .padding(.horizontal, 10)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 2
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct SettingItem_Previews: PreviewProvider {
    static var previews: some View {
        SettingItem(
            icon: "person.circle",
            settingName: "Profile",
            subtitle: "subtitle",
            onTap: {}
        )
    }
}

