//
//  CityPickerModal.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CityPickerModal: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    
    @Binding var selectedCity: City
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var animateIn = false
    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return viewModel.cities
        } else {
            return viewModel.cities.filter { city in
                city.name!.localizedCaseInsensitiveContains(searchText) ||
                city.code!.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchCountryBar(placeHolder: "Search cities...", text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredCities) { city in
                            CityRow(
                                city: city,
                                isSelected: city.id == selectedCity.id
                            ) {
                                selectCity(city)
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: filteredCities.count)
                }
            }
            .navigationTitle("Select City")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    dismissModal()
                }
                .foregroundColor(.orange)
                .fontWeight(.semibold)
            )
        }
        .onAppear {
            viewModel.fetchCities()
            withAnimation(.easeOut(duration: 0.3)) {
                animateIn = true
            }
        }
    }
    
    private func selectCity(_ city: City) {
        selectedCity = city
        viewModel.setToUserDefault(field: .city(city.name!))
        viewModel.setToUserDefault(field: .cityId(city.id!))
        viewModel.setToUserDefault(field: .cityCode(city.code!))
        dismissModal()
    }
    
    private func dismissModal() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
        }
    }
}

struct CityPickerModal_Previews: PreviewProvider {
    static var previews: some View {
        CityPickerModal(selectedCity: .constant(City(id: 7755221794881, name: "6th of October", code: "SU")), isPresented: .constant(true))
    }
}
