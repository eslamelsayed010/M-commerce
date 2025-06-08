//
//  SettingsViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import Foundation

protocol SettingsViewModelProtocol{
    func fetchCities()
    func fetchUserInfo()
    func setToUserDefault(field: UserField)
}

class SettingsViewModel:ObservableObject, SettingsViewModelProtocol{
    
    private var networkManager: SettingsNetworkProtocol
    @Published var cities: [City] = []
    @Published var user: UserInfo?
    
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
    
    func setToUserDefault(field: UserField) {
        switch field {
        case .name(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.User.name)
        case .phone(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.User.phone)
        case .address(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.Location.address)
        case .city(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.Location.city)
        case .country(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.Location.country)
        case .cityId(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.Location.cityId)
        case .cityCode(let value):
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.Location.cityCode)
        }
    }
    
    func fetchUserInfo(){
        self.user = UserInfo(
            name: UserDefaults.standard.string(forKey: UserDefaultsKeys.User.name),
            phone: UserDefaults.standard.string(forKey: UserDefaultsKeys.User.phone),
            city: UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.city),
            cityId: UserDefaults.standard.integer(forKey: UserDefaultsKeys.Location.cityId),
            cityCode: UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.cityCode),
            country: UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.country),
            address: UserDefaults.standard.string(forKey: UserDefaultsKeys.Location.address)
        )
    }
}
