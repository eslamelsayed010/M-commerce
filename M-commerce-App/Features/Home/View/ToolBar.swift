//
//  ToolBar.swift
//  M-commerce-App
//
//  Created by Macos on 05/06/2025.
//

import SwiftUI

struct ToolBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 10) {
            TextField("Search ...", text: $searchText)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding()
            Button(action: { print("let's navigate to favorites ") }) {
                Image(systemName: "heart")
                    .foregroundColor(.black)
            }
            Button(action: { print("let's navigate to cart ") }) {
                Image(systemName: "cart")
                    .foregroundColor(.black)
            }
            .padding()
        }
    }
}

struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolBar(searchText: .constant("")) 
    }
}
