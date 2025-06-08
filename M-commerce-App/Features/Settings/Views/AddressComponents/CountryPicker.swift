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
            }
        }
        .padding(.horizontal)
    }
}
struct CountryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CountryPicker()
    }
}
