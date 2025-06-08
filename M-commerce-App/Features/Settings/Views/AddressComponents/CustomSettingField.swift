//
//  FullAddress.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CustomSettingField: View {
    @Binding var addressName: String
    @State private var isEditing = false
    @State private var isValid = true
    @FocusState private var isFocused: Bool
    
    let title: String
    let placeholder: String
    let icon: String
    
    enum ValidationType {
        case address
        case phone
    }
    let validationType: ValidationType
    
    init(
        addressName: Binding<String>,
        title: String = "Address",
        placeholder: String = "Enter your address",
        icon: String = "house.fill",
        validationType: ValidationType = .address
    ) {
        self._addressName = addressName
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.validationType = validationType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Animated Title
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isFocused ? .orange : .primary)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Spacer()
                
                if !addressName.isEmpty {
                    Image(systemName: isValid ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundColor(isValid ? .green : .red)
                        .font(.system(size: 16))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            
            // Text Field Container
            HStack(spacing: 12) {
                // Icon
                Image(systemName: icon)
                    .foregroundColor(isFocused ? .orange : .secondary)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 20)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                // Text Field
                TextField("", text: $addressName)
                    .placeholder(when: addressName.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.secondary)
                    }
                    .focused($isFocused)
                    .textContentType(.streetAddressLine1)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .font(.body)
                    .foregroundColor(.primary)
                    .onChange(of: addressName) { newValue in
                        switch validationType {
                        case .address:
                            validateStreetName(newValue)
                        case .phone:
                            validatePhoneNumber(newValue)
                        }
                    }

                
                // Clear Button
                if !addressName.isEmpty && isFocused {
                    Button(action: {
                        addressName = ""
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isValid = true
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isFocused ? Color.orange :
                                !isValid ? Color.red :
                                Color(.systemGray4),
                                lineWidth: isFocused ? 2 : 1
                            )
                            .animation(.easeInOut(duration: 0.2), value: isFocused)
                    )
                    .shadow(
                        color: isFocused ? Color.orange.opacity(0.3) : Color.black.opacity(0.05),
                        radius: isFocused ? 8 : 4,
                        x: 0,
                        y: isFocused ? 4 : 2
                    )
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
            )
            
            // Error Message
            if !isValid {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 12))
                    
                    Text(validationType == .phone ? "Please enter a valid phone number" : "Please enter a valid address")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isValid)
        .animation(.easeInOut(duration: 0.2), value: !addressName.isEmpty)
        .padding(.horizontal)
    }
    
    private func validateStreetName(_ name: String) {
        // Basic validation for address
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasValidLength = trimmedName.count >= 2
        let hasValidCharacters = !trimmedName.isEmpty && trimmedName.rangeOfCharacter(from: CharacterSet.letters) != nil
        
        withAnimation(.easeInOut(duration: 0.2)) {
            isValid = hasValidLength && hasValidCharacters
        }
    }
    
    private func validatePhoneNumber(_ number: String) {
        let trimmed = number.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRegex = "^[0-9+]{7,15}$"
        let isValidPhone = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: trimmed)
        
        withAnimation(.easeInOut(duration: 0.2)) {
            isValid = isValidPhone
        }
    }

}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}


struct FullAddress_Previews: PreviewProvider {
    static var previews: some View {
        CustomSettingField(addressName: .constant(""))
    }
}
