//
//  Country.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import Foundation

struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
    let dialCode: String
}

struct Countries {
    static let all: [Country] = [
        Country(name: "United States", code: "US", flag: "🇺🇸", dialCode: "+1"),
        Country(name: "United Kingdom", code: "GB", flag: "🇬🇧", dialCode: "+44"),
        Country(name: "Canada", code: "CA", flag: "🇨🇦", dialCode: "+1"),
        Country(name: "Australia", code: "AU", flag: "🇦🇺", dialCode: "+61"),
        Country(name: "Germany", code: "DE", flag: "🇩🇪", dialCode: "+49"),
        Country(name: "France", code: "FR", flag: "🇫🇷", dialCode: "+33"),
        Country(name: "Italy", code: "IT", flag: "🇮🇹", dialCode: "+39"),
        Country(name: "Spain", code: "ES", flag: "🇪🇸", dialCode: "+34"),
        Country(name: "Japan", code: "JP", flag: "🇯🇵", dialCode: "+81"),
        Country(name: "South Korea", code: "KR", flag: "🇰🇷", dialCode: "+82"),
        Country(name: "China", code: "CN", flag: "🇨🇳", dialCode: "+86"),
        Country(name: "India", code: "IN", flag: "🇮🇳", dialCode: "+91"),
        Country(name: "Brazil", code: "BR", flag: "🇧🇷", dialCode: "+55"),
        Country(name: "Mexico", code: "MX", flag: "🇲🇽", dialCode: "+52"),
        Country(name: "Argentina", code: "AR", flag: "🇦🇷", dialCode: "+54"),
        Country(name: "Russia", code: "RU", flag: "🇷🇺", dialCode: "+7"),
        Country(name: "Turkey", code: "TR", flag: "🇹🇷", dialCode: "+90"),
        Country(name: "Saudi Arabia", code: "SA", flag: "🇸🇦", dialCode: "+966"),
        Country(name: "UAE", code: "AE", flag: "🇦🇪", dialCode: "+971"),
        Country(name: "Egypt", code: "EG", flag: "🇪🇬", dialCode: "+20"),
        Country(name: "South Africa", code: "ZA", flag: "🇿🇦", dialCode: "+27"),
        Country(name: "Nigeria", code: "NG", flag: "🇳🇬", dialCode: "+234"),
        Country(name: "Kenya", code: "KE", flag: "🇰🇪", dialCode: "+254"),
        Country(name: "Thailand", code: "TH", flag: "🇹🇭", dialCode: "+66"),
        Country(name: "Singapore", code: "SG", flag: "🇸🇬", dialCode: "+65"),
        Country(name: "Malaysia", code: "MY", flag: "🇲🇾", dialCode: "+60"),
        Country(name: "Indonesia", code: "ID", flag: "🇮🇩", dialCode: "+62"),
        Country(name: "Philippines", code: "PH", flag: "🇵🇭", dialCode: "+63"),
        Country(name: "Vietnam", code: "VN", flag: "🇻🇳", dialCode: "+84"),
        Country(name: "Netherlands", code: "NL", flag: "🇳🇱", dialCode: "+31")
    ].sorted { $0.name < $1.name }
}
