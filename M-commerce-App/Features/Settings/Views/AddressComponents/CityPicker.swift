//
//  CityPicker.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CityPicker: View {
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
        }.padding(.horizontal)
        

    }
}

struct CityPicker_Previews: PreviewProvider {
    static var previews: some View {
        CityPicker()
    }
}
