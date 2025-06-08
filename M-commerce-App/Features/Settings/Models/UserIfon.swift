//
//  User.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import Foundation

struct UserInfo{
    let id = UUID()
    let name: String?
    let phone: String?
    let city: String?
    let cityId: Int?
    let cityCode: String?
    let country: String?
    let address: String?
}

enum UserField {
    case name(String)
    case phone(String)
    case address(String)
    case city(String)
    case cityId(Int)
    case cityCode(String)
    case country(String)
}

