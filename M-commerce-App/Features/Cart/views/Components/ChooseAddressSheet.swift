//
//  ChooseAddressSheet.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import SwiftUI

struct ChooseAddressSheet: View {
    @EnvironmentObject var viewModel: CartViewModel
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager
    var totalPrice: Double
    
    @State private var selectedAddressId: Int?
    @State private var selectedAddress: ShopifyAddress?
    
    @State private var confirmedOrder: GetDraftOrder?
    @State private var confirmedEmail: String = ""
    @State private var selectedOrderID: Int? = nil
    
    var body: some View {
        NavigationStack {
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
                                guard let order = viewModel.draftOrder.first else { return }
                                Task {
                                    await viewModel.completeOrder(
                                        orderId: Int(order.id),
                                        order: order,
                                        email: order.customer?.email ?? "guest@example.com",
                                        onSuccess: { confirmed, email in
                                            DispatchQueue.main.async {
                                                confirmedOrder = confirmed
                                                confirmedEmail = email
                                                selectedOrderID = Int(confirmed.id)
                                            }
                                        },
                                        onFailure: { error in
                                            DispatchQueue.main.async {
                                                print(" COD Order failed: \(error)")
                                            }
                                        }
                                    )
                                }
                            }
                            
                            
                            .padding(.top, 50)
                            .padding(.bottom, 10)
                            
                            PaymentButton {
                                
                                viewModel.pay(
                                    selectedAddress: selectedAddress,
                                    total: totalPrice,
                                    onSuccess: { order, email in
                                        DispatchQueue.main.async {
                                            confirmedOrder = order
                                            confirmedEmail = email
                                            selectedOrderID = Int(order.id)
                                        }
                                    },
                                    onFailure: { error in
                                        DispatchQueue.main.async {
                                            print("Apple Pay failed: \(error)")
                                        }
                                    }
                                )
                                
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 50)
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
            
            
            NavigationLink(
                tag: Int(confirmedOrder?.id ?? -1),
                selection: $selectedOrderID,
                destination: {
                    if let order = confirmedOrder {
                        OrderConfirmationView(order: order, email: confirmedEmail)
                    }
                },
                label: {
                    EmptyView()
                }
            )
            .hidden()
        }
    }
}

