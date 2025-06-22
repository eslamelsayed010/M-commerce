//
//  CouponViewModel.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import Foundation

class CouponViewModel: ObservableObject{
    @Published var coupons: [Coupon] = []
    
    private let apiService: CouponServicesProtocol
    
    init(apiService: CouponServicesProtocol) {
        self.apiService = apiService
    }
    
    func getCoupons() async {
        do {
            self.coupons = try await apiService.fetchCoupons().price_rules
        } catch{
            print(error.localizedDescription)
        }
    }
}
