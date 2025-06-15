//
//  CurrencyView.swift
//  M-commerce-App
//
//  Created by Macos on 10/06/2025.
//

import SwiftUI

struct CurrencyPickerView: View {
    let options: [String]
    @Binding var selectedOption: String
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = SettingsViewModel(networkManager: SettingsNetworkManager())
    
    fileprivate func saveCurrency() {
        if selectedOption == "EGP" {
            let egp = viewModel.currency?.EGP ?? 0.0
            viewModel.setToUserDefault(field: .currency(egp))
        } else {
            let usd = 1 / (viewModel.currency?.EGP ?? 0.0)
            viewModel.setToUserDefault(field: .currency(usd))
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Choose your currency", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.inline) 
            }
            .onChange(of: selectedOption) { newValue in
                saveCurrency()
            }
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveCurrency()
                        dismiss()
                    }
                }
            }
        }
        .onAppear{
            viewModel.fetchCurrency()
            viewModel.fetchUserInfo()
        }
    }
}

//struct CurrencyPickerView: View {
//    let options: [String]
//    @Binding var selectedOption: String
//    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel = SettingsViewModel(networkManager: SettingsNetworkManager())
//    @State private var isLoading = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Background gradient
//                LinearGradient(
//                    colors: [Color(.systemBackground), Color(.systemGray6)],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
//
//                VStack(spacing: 24) {
//                    // Header section with icon
//                    VStack(spacing: 12) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.orange)
//                                .frame(width: 80, height: 80)
//                                .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
//
//                            Image(systemName: "dollarsign.circle.fill")
//                                .font(.system(size: 40, weight: .medium))
//                                .foregroundColor(.white)
//                        }
//
//                        Text("Select Currency")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.primary)
//
//                        Text("Choose your preferred currency for shopping")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.center)
//                    }
//                    .padding(.top, 20)
//
//                    // Currency options
//                    VStack(spacing: 16) {
//                        ForEach(options, id: \.self) { option in
//                            CurrencyOptionCard(
//                                currency: option,
//                                isSelected: selectedOption == option,
//                                onTap: {
//                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                                        selectedOption = option
//                                    }
//                                }
//                            )
//                        }
//                    }
//                    .padding(.horizontal, 20)
//
//                    Spacer()
//
//                    // Action buttons
//                    VStack(spacing: 12) {
//                        Button(action: saveCurrency) {
//                            HStack {
//                                if isLoading {
//                                    ProgressView()
//                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                                        .scaleEffect(0.8)
//                                } else {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .font(.system(size: 16, weight: .medium))
//                                }
//
//                                Text(isLoading ? "Saving..." : "Save Currency")
//                                    .font(.headline)
//                                    .fontWeight(.semibold)
//                            }
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 56)
//                            .background(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .fill(Color.orange)
//                                    .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
//                            )
//                        }
//                        .disabled(isLoading)
//                        .scaleEffect(isLoading ? 0.95 : 1.0)
//                        .animation(.easeInOut(duration: 0.1), value: isLoading)
//
//                        Button("Cancel") {
//                            dismiss()
//                        }
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 20)
//                }
//            }
//            .navigationBarHidden(true)
//        }
//        .onAppear {
//            viewModel.fetchCurrency()
//            viewModel.fetchUserInfo()
//        }
//    }
//
//    private func saveCurrency() {
//        isLoading = true
//
//        // Add a small delay to show the loading state
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if selectedOption == "EGP" {
//                print("EGP => \(viewModel.currency?.EGP ?? 0.0)")
//                let egp = viewModel.currency?.EGP ?? 0.0
//                viewModel.setToUserDefault(field: .currency(egp))
//            } else {
//                print("USD => \(1 / (viewModel.currency?.EGP ?? 0.0))")
//                let usd = 1 / (viewModel.currency?.EGP ?? 0.0)
//                viewModel.setToUserDefault(field: .currency(usd))
//            }
//
//            isLoading = false
//
//            // Dismiss with a slight delay to show completion
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                dismiss()
//            }
//        }
//    }
//}
//
//struct CurrencyOptionCard: View {
//    let currency: String
//    let isSelected: Bool
//    let onTap: () -> Void
//
//    private var currencySymbol: String {
//        switch currency {
//        case "USD": return "$"
//        case "EGP": return "E£"
//        default: return currency
//        }
//    }
//
//    private var currencyName: String {
//        switch currency {
//        case "USD": return "US Dollar"
//        case "EGP": return "Egyptian Pound"
//        default: return currency
//        }
//    }
//
//    var body: some View {
//        Button(action: onTap) {
//            HStack(spacing: 16) {
//                // Currency symbol circle
//                ZStack {
//                    Circle()
//                        .fill(isSelected ? Color.orange : Color.gray.opacity(0.1))
//                        .frame(width: 50, height: 50)
//
//                    Text(currencySymbol)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(isSelected ? .white : .primary)
//                }
//
//                // Currency info
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(currency)
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)
//
//                    Text(currencyName)
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//
//                Spacer()
//
//                // Selection indicator
//                ZStack {
//                    Circle()
//                        .stroke(isSelected ? Color.orange : Color.gray.opacity(0.3), lineWidth: 2)
//                        .frame(width: 24, height: 24)
//
//                    if isSelected {
//                        Circle()
//                            .fill(Color.orange)
//                            .frame(width: 12, height: 12)
//                            .scaleEffect(isSelected ? 1.0 : 0.0)
//                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
//                    }
//                }
//            }
//            .padding(20)
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(Color(.systemBackground))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(
//                                isSelected ? Color.orange : Color.gray.opacity(0.2),
//                                lineWidth: isSelected ? 2 : 1
//                            )
//                    )
//                    .shadow(
//                        color: isSelected ? Color.orange.opacity(0.1) : Color.black.opacity(0.05),
//                        radius: isSelected ? 8 : 4,
//                        x: 0,
//                        y: 2
//                    )
//            )
//        }
//        .buttonStyle(PlainButtonStyle())
//        .scaleEffect(isSelected ? 1.02 : 1.0)
//        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
//    }
//}

// Preview
struct EnhancedCurrencyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView(
            options: ["USD", "EGP"],
            selectedOption: .constant("USD")
        )
    }
}
