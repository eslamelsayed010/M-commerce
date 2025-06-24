//
//  AddressFormField.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct AddressFormField: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var address1: String
    @Binding var address2: String
    @Binding var city: String
    @Binding var province: String
    @Binding var zip: String
    @Binding var phone: String
    @Binding var country: String
    let options = ["Work", "Home"]
    
    @StateObject var settingsViewModel = SettingsViewModel(networkManager: SettingsNetworkManager())
    @EnvironmentObject var locationViewModel: LocationUpdateViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                CustomSettingField(
                    addressName: $firstName,
                    title: "First Name",
                    placeholder: "e.g. Ali",
                    icon: "person.fill",
                    validationType: .address
                )
                CustomSettingField(
                    addressName: $lastName,
                    title: "Last Name",
                    placeholder: "e.g. Ahmed",
                    icon: "person.2.fill",
                    validationType: .address
                )
            }
            CustomSettingField(addressName: $address1)
            
            HStack {
                CustomSettingField(
                    addressName: $city,
                    title: "City",
                    placeholder: "e.g. Cairo",
                    icon: "tram.fill",
                    validationType: .address
                )
                .onChange(of: city) { newValue in
                    settingsViewModel.setToUserDefault(field: .city(newValue))
                }
                CustomSettingField(
                    addressName: $province,
                    title: "Province",
                    placeholder: "e.g. Cairo",
                    icon: "building.columns.fill",
                    validationType: .address
                )
            }
            
            CustomSettingField(
                addressName: $phone,
                title: "Phone",
                placeholder: "Enter your phone number",
                icon: "phone.fill",
                validationType: .phone
            )
            
            
            CountryPicker()
                .environmentObject(settingsViewModel)
                .environmentObject(locationViewModel)
            
            HStack{
                Spacer()
                ForEach(options, id: \.self) { option in
                    HStack {
                        Image(systemName: locationViewModel.address2 == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(.orange)
                        Text(option)
                            .font(.body)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        locationViewModel.address2 = option
                        print(locationViewModel.address2)
                    }
                }
                Spacer()
            }
            .padding()
            
        }
        .onAppear{
            settingsViewModel.fetchUserInfo()
            locationViewModel.country = country
            country = settingsViewModel.user?.country ?? ""
        }
    }
}

struct AddressFormField_Previews: PreviewProvider {
    static var previews: some View {
        AddressFormField(firstName: .constant(""), lastName: .constant(""), address1: .constant(""), address2: .constant(""), city: .constant(""), province: .constant(""), zip: .constant(""), phone: .constant(""), country: .constant(""))
            .padding()
    }
}
