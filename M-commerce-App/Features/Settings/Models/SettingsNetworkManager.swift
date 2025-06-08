//
//  SettingsNetworkManager.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import Foundation

protocol SettingsNetworkProtocol{
    func fetchDataFromJSON(completionHandler: @escaping (ShippingZonesResponse?) -> Void)
}
class SettingsNetworkManager: SettingsNetworkProtocol{
    func fetchDataFromJSON(completionHandler: @escaping (ShippingZonesResponse?) -> Void) {
        let strUrl = "https://c30da1df66b50be0ea97b5d360a732e2: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@ios2-ism.myshopify.com/admin/api/2024-10/shipping_zones.json"
        let url = URL(string: strUrl)
        guard let newUrl = url else {
            return
        }
        
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(ShippingZonesResponse.self, from: data)
                //print(result)
                completionHandler(result)
            } catch let error {
                print("Here")
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    
}

