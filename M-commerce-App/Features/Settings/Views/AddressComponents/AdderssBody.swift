//
//  AdderssBody.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct AdderssBody: View {
    @StateObject var settingsViewModel = SettingsViewModel(networkManager: SettingsNetworkManager())
    
    @StateObject private var viewModel = LocationUpdateViewModel()
    @State private var showToast = false
    
    var body: some View {
        LazyVStack(spacing: 20) {
            CustomSegment(selectedAction: $viewModel.selectedAction)
            Divider()
            
            AddressFormField(
                firstName: $viewModel.firstName,
                lastName: $viewModel.lastName,
                address1: $viewModel.address1,
                address2: $viewModel.address2,
                city: $viewModel.city,
                province: $viewModel.province,
                zip: $viewModel.zip,
                phone: $viewModel.phone,
                country: $viewModel.country
            )
            
            SubmitAddrressButton(
                isLoading: viewModel.isLoading,
                isFormValid: viewModel.isFormValid,
                selectedAction: viewModel.selectedAction,
                action: {
                    showToast = true
                    settingsViewModel.setToUserDefault(field: .city(viewModel.customer?.default_address?.city ?? ""))
                    viewModel.submitLocationUpdate()
                }
            )
            .padding(.horizontal)
        }
        .onAppear{
            settingsViewModel.fetchUserInfo()
        }
        .onChange(of: viewModel.selectedAction) { newValue in
            viewModel.customerId = "7614499029057"
            Task {
                await viewModel.fetchCustomer(customerId: 7615556911169)
                if viewModel.selectedAction == .updateExisting {
                    viewModel.existingAddress()
                }else if viewModel.selectedAction == .updateDefault{
                    viewModel.defaultAddress()
                }
                
            }
        }

        .toast(successMessage: viewModel.successMessage, errorMessage: viewModel.errorMessage, isShowing: $showToast)
    }
}

struct AdderssBody_Previews: PreviewProvider {
    static var previews: some View {
        AdderssBody()
    }
}
