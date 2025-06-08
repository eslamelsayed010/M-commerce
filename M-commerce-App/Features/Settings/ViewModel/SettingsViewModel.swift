//
//  SettingsViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import Foundation

protocol SettingsViewModelProtocol{
    func fetchCities()
}

class SettingsViewModel:ObservableObject, SettingsViewModelProtocol{
    private var networkManager: SettingsNetworkProtocol
    @Published var cities: [City] = []
    
    init(networkManager: SettingsNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchCities() {
        networkManager.fetchDataFromJSON{[weak self] result in
            DispatchQueue.main.async {
                self?.cities = result?.shipping_zones.first?.countries.first?.provinces ?? []
            }
        }
    }
}
