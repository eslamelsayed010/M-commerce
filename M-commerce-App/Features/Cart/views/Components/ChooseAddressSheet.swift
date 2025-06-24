//
//  ChooseAddressSheet.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import SwiftUI

struct ChooseAddressSheet: View {
    @EnvironmentObject var viewModel: CartViewModel
    @State var totalPrice: Double = 0
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager
    @State private var selectedAddressId: Int?
    @State var selectedAddress: ShopifyAddress?
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 16) {
                if !viewModel.address.isEmpty {
                    VStack {
                        ForEach(viewModel.address, id: \.id) { address in
                            ChooseAddressRow(
                                address: address,
                                isSelected: selectedAddressId == address.id,
                                onTap: {
                                    selectedAddressId = address.id
                                    selectedAddress = address
                                }
                            )
                        }
                        
                        Spacer()
                        
                        CustomProceedButton(text: "Cash on delivery(COD)", Icon: "creditcard") {
                            
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                        
                        PaymentButton {
                             Task{
                                 await viewModel.pay(selectedAddress: selectedAddress, total: totalPrice)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                    }
                    
                    NavigationLink(destination: CartView()
                                   , isActive: $viewModel.paymentSuccess) {
                        EmptyView()
                    }
                    
                } else {
                    Text("Choose Address to complete checkout!")
                }
                
            }
            .padding(.vertical)
        }
        .navigationTitle("Choose Address")
        .onAppear {
            Task {
                await viewModel.fetchCustomerAddress()
                if let defaultAddress = viewModel.address.first(where: { $0.isDefault == true }) {
                    selectedAddressId = defaultAddress.id
                    selectedAddress = defaultAddress
                }
            }
        }
    }
}

struct ChooseAddressSheet_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAddressSheet()
            .environmentObject(CartViewModel(cartServices: CartServices()))
    }
}
