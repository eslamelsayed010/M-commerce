//
//  ChooseAddressRow.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import SwiftUI

struct ChooseAddressRow: View {
    let address: ShopifyAddress
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.headline)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(address.country)
                    .font(.title3)
                
                Text("\(address.address1), \(address.city)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
    }
}


struct ChooseAddressRow_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAddressRow(
            address: ShopifyAddress(
                id: 1,
                address1: "Amber Street",
                address2: nil,
                city: "Cairo",
                province: "Cairo",
                phone: "01000000000",
                zip: "",
                lastName: "Eslayed",
                firstName: "Eslam",
                country: "Egypt",
                isDefault: true
            ),
            isSelected: true,
            onTap: {}
        )
        .background(Color(.systemGroupedBackground))
    }
}

