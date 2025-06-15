//
//  CountryPickerModal.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CountryPickerModal: View {
    @Binding var selectedCountry: Country
    @EnvironmentObject var viewModel: SettingsViewModel
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var animateIn = false
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return Countries.all
        } else {
            return Countries.all.filter { country in
                country.name.localizedCaseInsensitiveContains(searchText) ||
                country.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchCountryBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredCountries) { country in
                            CountryRow(
                                country: country,
                                isSelected: country.id == selectedCountry.id
                            ) {
                                selectCountry(country)
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: filteredCountries.count)
                }
            }
            .navigationTitle("Select Country")
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
            withAnimation(.easeOut(duration: 0.3)) {
                animateIn = true
            }
        }
    }
    
    private func selectCountry(_ country: Country) {
        selectedCountry = country
        viewModel.setToUserDefault(field: .country(country.name))
        dismissModal()
    }
    
    private func dismissModal() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
        }
    }
}


struct CountryPickerModal_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerModal(selectedCountry: .constant(Countries.all.first!), isPresented: .constant(true))
    }
}
