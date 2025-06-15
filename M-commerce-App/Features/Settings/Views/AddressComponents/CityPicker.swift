//
//  CityPicker.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CityPicker: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    @State private var isPickerPresented = false
    @State private var selectedCity: City = City(id: 7755221794881, name: "6th of October", code: "SU")
    
    var body: some View {
        VStack {
            HStack{
                Text("City")
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .font(.headline)
                Spacer()
            }
            CitySelectionButton(
                city: selectedCity,
                action: {isPickerPresented = true}
            )
            .sheet(isPresented: $isPickerPresented) {
                    CityPickerModal(
                        selectedCity: $selectedCity,
                        isPresented: $isPickerPresented
                    )
                
                }
        }
        .padding(.horizontal)
        .onAppear{
            viewModel.fetchUserInfo()
            print(viewModel.user?.city ?? "nil")
            selectedCity = City(id: viewModel.user?.cityId ?? 1, name: viewModel.user?.city ?? "Your City", code: viewModel.user?.cityCode ?? "CI")
        }
    }
}

struct CityPicker_Previews: PreviewProvider {
    static var previews: some View {
        CityPicker()
    }
}
