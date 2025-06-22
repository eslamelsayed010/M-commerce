//
//  PlaceOrderSheet.swift
//  M-commerce-App
//
//  Created by Macos on 22/06/2025.
//

import SwiftUI

struct PlaceOrderSheet: View {
    @State private var discount: String = ""
    @EnvironmentObject var viewModel: CartViewModel
    @State var totalPrice: Double = 0
    @State private var isDiscountApplied = false
    @State private var showAlert = false
    @State private var discountAmount: Double = 0
    
    @State private var showAddressSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20){
                HStack {
                    Text("Sub Total")
                        .font(.title2)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.totalPrice))")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Shipping Fees")
                        .font(.title2)
                    Spacer()
                    Text("30$")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }

                HStack {
                    TextField("Discount code and press validate", text: $discount)
                        .padding(.horizontal)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .cornerRadius(12)
                        .padding(.trailing)

                    Spacer()

                    Button("Validate") {
                        if isDiscountApplied {
                            showAlert = true
                        } else if !discount.isEmpty {
                            if let discount = discount.components(separatedBy: "-").last,
                               let discountValue = Double(discount) {
                                discountAmount = totalPrice * (discountValue / 100)
                                totalPrice -= discountAmount
                                isDiscountApplied = true
                            }
                        }
                    }
                }

                HStack {
                    Text("Discount")
                        .font(.title2)
                    Spacer()
                    Text("-$\(String(format: "%.2f", discountAmount))")
                        .font(.title2)
                        .foregroundColor(.red)
                }

                Text("Grand Total")
                    .font(.title2)

                Divider()

                Text("$\(String(format: "%.2f", totalPrice))")
                    .font(.title2)
                    .foregroundColor(.green)

                Spacer()

                CustomProceedButton(text: "Place Order") {
                    showAddressSheet = true
                }
                .sheet(isPresented: $showAddressSheet) {
                    ChooseAddressSheet()
                        .environmentObject(viewModel)
                    .presentationDragIndicator(.visible)
                }
            }
            .padding()
            .onAppear {
                totalPrice = viewModel.totalPrice
            }
            .alert("Discount Already Applied", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You have already used a discount code.")
            }
        }
    }
}

struct PlaceOrderSheet_Previews: PreviewProvider {
    static var previews: some View {
        PlaceOrderSheet()
    }
}
