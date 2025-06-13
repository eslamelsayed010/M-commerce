//
//  ImageGridView.swift
//  M-commerce-App
//
//  Created by Macos on 04/06/2025.
//

import SwiftUI

struct ImgCouponView: View {
    let imageNames = ["1", "2"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 16) {
                ForEach(imageNames, id: \.self) { name in
                    Image(name)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 200)
                                .clipped()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                }
            }
            .padding()
        }
        .frame(height: 220)
    }
}

struct ImgCouponView_Previews: PreviewProvider {
    static var previews: some View {
        ImgCouponView()
    }
}
