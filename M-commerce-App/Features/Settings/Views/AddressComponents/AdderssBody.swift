//
//  AdderssBody.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct AdderssBody: View {
    @StateObject var viewModel = SettingsViewModel(networkManager: SettingsNetworkManager())
    @State private var addressName = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        VStack(spacing: 20) {
            CountryPicker()
                .environmentObject(viewModel)
            Divider()
            
            CityPicker()
                .environmentObject(viewModel)
            Divider()
            
            CustomSettingField(addressName: $addressName)
            Divider()
            
            CustomSettingField(
                addressName: $phoneNumber,
                title: "Phone",
                placeholder: "Enter your phone number",
                icon: "phone.fill",
                validationType: .phone
            )
            Spacer()
        }.onAppear{
            viewModel.fetchUserInfo()
            viewModel.fetchCities()
            addressName = viewModel.user?.address ?? ""
            phoneNumber = viewModel.user?.phone ?? ""
        }
        .onChange(of: addressName) { newValue in
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.Location.address)
        }
        .onChange(of: phoneNumber) { newValue in
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.User.phone)
        }
    }
}

struct AdderssBody_Previews: PreviewProvider {
    static var previews: some View {
        AdderssBody()
    }
}
