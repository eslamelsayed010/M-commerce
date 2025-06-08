//
//  AddressView.swift
//  M-commerce-App
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct AddressView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 40){
                ZStack {
                    Circle()
                        .fill(.red.opacity(0.15))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 65, weight: .medium))
                        .foregroundColor(.red)
                }
                
                AdderssBody()
                
            }
            .padding(.top, 15)
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView()
    }
}
