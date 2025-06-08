//
//  AdderssBody.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct AdderssBody: View {
    @State private var addressName = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        VStack(spacing: 20) {
            CountryPicker()
            Divider()
            CityPicker()
            Divider()
            CustomSettingField(addressName: $addressName)
            Divider()
            CustomSettingField(
                addressName: $phoneNumber,
                title: "Phone",
                placeholder: "Enter your phone number",
                icon: "phone.fill"
            )
            Spacer()
        }
    }
}

struct AdderssBody_Previews: PreviewProvider {
    static var previews: some View {
        AdderssBody()
    }
}
