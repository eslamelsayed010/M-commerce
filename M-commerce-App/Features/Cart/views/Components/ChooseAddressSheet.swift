//
//  ChooseAddressSheet.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import SwiftUI

struct ChooseAddressSheet: View {
    @EnvironmentObject var viewModel: CartViewModel
    @State private var selectedAddressId: Int?
    @State var slectedAddress: ShopifyAddress?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if !viewModel.address.isEmpty{
                        
                        VStack { ForEach(viewModel.address, id: \.id) { address in
                            ChooseAddressRow(
                                address: address,
                                isSelected: selectedAddressId == address.id,
                                onTap: {
                                    selectedAddressId = address.id
                                    slectedAddress = address
                                 }
                              )
                           }
                            
                            Spacer()

                            PaymentButton(){}
                                .padding()
                        }
                    }else{
                        Text("Choose Address to complete checkout!")
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Choose Address")
        }
        .onAppear {
            Task {
                await viewModel.fetchCustomerAddress()
                if let defaultAddress = viewModel.address.first(where: { $0.isDefault == true }) {
                    selectedAddressId = defaultAddress.id
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}


struct ChooseAddressSheet_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAddressSheet()
            .environmentObject(CartViewModel(cartServices: CartServices()))
    }
}
