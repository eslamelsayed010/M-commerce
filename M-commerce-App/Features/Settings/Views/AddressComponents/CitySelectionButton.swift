//
//  CitySelectionButton.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CitySelectionButton: View {
    let city: City
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action){
            HStack(spacing: 15){
                Image(systemName: "building.2.crop.circle")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 25, height: 25)
                
                VStack(alignment: .leading, spacing: 2){
                    Text(city.name ?? "Al Sharqia")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(city.code ?? "SHR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(isPressed ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isPressed)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct CitySelectionButton_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectionButton(city: City(id: 7755221794881, name: "6th of October", code: "SU"),action: {})
    }
}
