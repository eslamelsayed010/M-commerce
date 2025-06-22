//
//  CountryPicker.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CountryPicker: View {
    @State private var selectedCountry: Country = Countries.all[5]
    @State private var isPickerPresented = false
    @EnvironmentObject var viewModel: SettingsViewModel
    @EnvironmentObject var locationViewModel: LocationUpdateViewModel
    
    var body: some View {

        VStack {
            HStack {
                Text("Country")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            CountrySelectionButton(
                country: selectedCountry,
                action: { isPickerPresented = true }
            )
            .sheet(isPresented: $isPickerPresented) {
                CountryPickerModal(
                    selectedCountry: $selectedCountry,
                    isPresented: $isPickerPresented
                )
                .environmentObject(viewModel)
                .environmentObject(locationViewModel)
            }
        }
        .padding(.horizontal)
        .onAppear{
            viewModel.fetchUserInfo()
            locationViewModel.country = selectedCountry.name
            
            selectedCountry = Countries.all.first{
                $0.name.contains(viewModel.user?.country ?? "nil")
            } ?? Country(name: "Your country", code: "00", flag: "🇺🇳", dialCode: "COU")
        }
    }
}
struct CountryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CountryPicker()
    }
}
