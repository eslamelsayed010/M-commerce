//
//  ProductRow.swift
//  M-commerce-App
//
//  Created by Macos on 19/06/2025.
//

import SwiftUI

struct ProductRow: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    //var product: Product
    @State private var quantity = 1
    
    var body: some View {
        HStack(spacing: 20){
            Image("jacket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
                .cornerRadius(10)
            
            VStack(alignment: .leading){
                HStack {
                    Text("ADIDAS | CLASSIC BACKPACK")
                        .bold()
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(.leading)
                        .onTapGesture {
                            //cartViewModel.removeFromCart(product: product)
                        }
                }
                
                Text("$300")
                HStack {
                    Text("Quantity:")
                    Stepper("\(quantity)", value: $quantity, in: 1...10)
                }
                Divider()
            }
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct ProductRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow()
    }
}

