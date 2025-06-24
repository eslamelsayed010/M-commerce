//
//  LocationViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 13/06/2025.
//

import Foundation
import Combine

@MainActor
class LocationUpdateViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    @Published var customerId: String = String(AuthViewModel().getCustomerIdAndUsername().customerId ?? 0)
    @Published var addressId: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var address1: String = ""
    @Published var address2: String = "Work"
    @Published var city: String = ""
    @Published var province: String = ""
    @Published var zip: String = ""
    @Published var phone: String = ""
    @Published var country: String = "Egypt"
    @Published var selectedAction: LocationAction = .addNew
    @Published var customer: ShopifyCustomer? = nil
    
    private let apiService: ShopifyAPIServiceProtocol
    
    init(apiService: ShopifyAPIServiceProtocol = ShopifyAPIService()) {
        self.apiService = apiService
    }
    
    var isFormValid: Bool {
        //!customerId.isEmpty &&
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !address1.isEmpty &&
        !city.isEmpty &&
        !province.isEmpty &&
        //!zip.isEmpty &&
        //!country.isEmpty &&
        (selectedAction != .updateExisting || !addressId.isEmpty)
    }
    
    func submitLocationUpdate() {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            return
        }
        
        let address = createAddress()
        
        guard let customerIdInt = Int(customerId) else {
            errorMessage = "Invalid customer ID"
            return
        }
        
        Task {
            await performLocationUpdate(customerId: customerIdInt, address: address)
        }
    }
    
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    func resetForm() {
        firstName = ""
        lastName = ""
        address1 = ""
        address2 = ""
        city = ""
        province = ""
        zip = ""
        phone = ""
        country = ""
        customerId = "0"
        addressId = "0"
        clearMessages()
    }

    func existingAddress() {
        addressId = String(customer?.addresses?.first?.id ?? 0)
        firstName = customer?.addresses?.first?.firstName ?? ""
        lastName = customer?.addresses?.first?.lastName ?? ""
        address1 = customer?.addresses?.first?.address1 ?? ""
        city = customer?.addresses?.first?.city ?? ""
        province = customer?.addresses?.first?.province ?? ""
        phone = customer?.addresses?.first?.phone ?? ""
        country = customer?.addresses?.first?.country ?? ""
        selectedAction = .updateExisting
        clearMessages()
    }

    func defaultAddress() {
        firstName = customer?.default_address?.firstName ?? ""
        lastName = customer?.default_address?.lastName ?? ""
        address1 = customer?.default_address?.address1 ?? ""
        city = customer?.default_address?.city ?? ""
        province = customer?.default_address?.province ?? ""
        phone = customer?.default_address?.phone ?? ""
        country = customer?.default_address?.country ?? ""
        selectedAction = .updateDefault
        clearMessages()
    }
    
    private func createAddress() -> ShopifyAddress {
        return ShopifyAddress(
            id: selectedAction == .updateExisting ? Int(addressId) : nil,
            address1: address1,
            address2: address2.isEmpty ? nil : address2,
            city: city,
            province: province,
            phone: phone.isEmpty ? nil : phone,
            zip: zip,
            lastName: lastName,
            firstName: firstName,
            country: country,
            isDefault: selectedAction == .updateDefault
        )
    }
    
    private func performLocationUpdate(customerId: Int, address: ShopifyAddress) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            switch selectedAction {
            case .updateExisting:
                guard let addressIdInt = Int(addressId) else {
                    errorMessage = "Invalid address ID"
                    return
                }
                try await apiService.updateCustomerAddress(
                    customerId: customerId,
                    addressId: addressIdInt,
                    address: address
                )
                successMessage = "Address updated successfully!"
                
            case .addNew:
                try await apiService.addNewAddress(
                    customerId: customerId,
                    address: address
                )
                successMessage = "New address added successfully!"
                
            case .updateDefault:
                try await apiService.updateCustomerDefaultAddress(
                    customerId: customerId,
                    address: address
                )
                successMessage = "Default address updated successfully!"
            }
        } catch let error as ShopifyAPIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func fetchCustomer(customerId: Int) async {
        do {
            self.customer = try await apiService.fetchCustomer(customerId: customerId)
        } catch {
            errorMessage = "An unexpected error (customer): \(error.localizedDescription)"
        }
    }

}
