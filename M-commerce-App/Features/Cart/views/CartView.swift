//
//  CartView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        ScrollView {
            //if cartViewModel.products.count > 0 {
                //ForEach(cartViewModel.products, id: \.id){ product in
                    ProductRow().environmentObject(cartViewModel)
                //}
                
                HStack{
                    Text("Your cart total is")
                    Spacer()
                    Text("$300.00")
                        .bold()
                }
                .padding()
                
                PaymentButton(action: {})
                    .padding()
//            }else{
//                Text("Your cart is empty!")
//            }
            
        }.navigationTitle(Text("My Cart"))
            .padding(.top)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView().environmentObject(CartViewModel())
    }
}
