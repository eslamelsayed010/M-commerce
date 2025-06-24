//
//  UserSettings.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct UserSettings: View {
   @EnvironmentObject var visibilityManager: TabBarVisibilityManager
    
    @State private var goToAddress = false
    @State private var city: String = UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.city) ?? "N/A"
    
    @State private var selectedOption = "EGP"
    @State private var showCurrencyPicker = false
    let options = ["USD", "EGP"]
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Hi, Eslam")
            
            VStack(spacing: 5) {
                SettingItem(
                    icon: "location.fill",
                    settingName: "Address",
                    subtitle: city,
                    iconColor: .red,
                    onTap: {
                        goToAddress = true
                    }
                )
                
                NavigationLink(destination: AddressView()
                    .environmentObject(visibilityManager)
                               , isActive: $goToAddress) {
                    EmptyView()
                }
                .hidden()
                
                SettingItem(
                    icon: "dollarsign.circle.fill",
                    settingName: "Currency",
                    subtitle: selectedOption,
                    iconColor: .green,
                    onTap: {
                        showCurrencyPicker = true
                    }
                )
                .sheet(isPresented: $showCurrencyPicker) {
                    CurrencyPickerView(
                        options: options,
                        selectedOption: $selectedOption
                    )
                    .presentationDetents([.medium, .fraction(0.3)]) 
                    .presentationDragIndicator(.visible)
                }
            
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .onAppear {
            let userCity = UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.city)
            if let userCity = userCity, !userCity.isEmpty {
                city = userCity
            }else{
                city =  "N/A"
            }
            
            
            
            let currency: Double? = UserDefaults.standard.double(forKey: UserDefaultsKeys.Currency.currency)
            let price = 5.0
            let test = price * (currency ?? price)
            print("Test => " ,test)
            
            if let newCurrency = currency, newCurrency < 10 {
                selectedOption = "USD"
            } else {
                selectedOption = "EGP"
            }
        }
    }
}


struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
    }
}

