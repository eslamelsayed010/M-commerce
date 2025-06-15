//
//  CustomSegment.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct CustomSegment: View {
    @Binding var selectedAction: LocationAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Actions")
                .font(.headline)
                .foregroundColor(.primary)
            
            CustomSegmentedControl(
                selectedAction: $selectedAction
            )
        }
        .padding(.horizontal)
    }
}

struct CustomSegmentedControl: View {
    @Binding var selectedAction: LocationAction
    @Namespace private var animationNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(LocationAction.allCases, id: \.self) { action in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedAction = action
                    }
                }) {
                    Text(action.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedAction == action ? .white : .orange)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(
                            ZStack {
                                if selectedAction == action {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.orange,
                                                    Color.orange.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .matchedGeometryEffect(id: "selectedSegment", in: animationNamespace)
                                        .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                            }
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct CustomSegment_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegment(selectedAction: .constant(.addNew))
    }
}
