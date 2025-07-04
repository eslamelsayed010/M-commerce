//
//  PaymentHandler.swift
//  M-commerce-App
//
//  Created by Macos on 23/06/2025.
//

import Foundation
import PassKit
import Contacts

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
    ]
    
    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStart = calendar.date(byAdding: .day, value: 5, to: today)
        let shippingEnd = calendar.date(byAdding: .day, value: 10, to: today)
        
        if let shippingEnd = shippingEnd, let shippingStart = shippingStart {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
            let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
            
            let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00"))
            shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
            shippingDelivery.detail = "Sweaters sent to your address"
            shippingDelivery.identifier = "DELIVERY"
            
            return [shippingDelivery]
        }
        return []
    }
    
    func createPKContact(from address: ShopifyAddress) -> PKContact {
        let contact = PKContact()
        
        if !address.firstName.isEmpty || !address.lastName.isEmpty {
            let personName = PersonNameComponents()
            var nameComponents = personName
            nameComponents.givenName = address.firstName
            nameComponents.familyName = address.lastName
            contact.name = nameComponents
        }
        
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = "\(address.address1) \(address.address2 ?? "")".trimmingCharacters(in: .whitespaces)
        postalAddress.city = address.city
        postalAddress.state = address.province
        postalAddress.postalCode = address.zip
        postalAddress.country = address.country
        //postalAddress.isoCountryCode = address.countryCode
        
        contact.postalAddress = postalAddress
        
        if let phone = address.phone, !phone.isEmpty {
            contact.phoneNumber = CNPhoneNumber(stringValue: phone)
        }
        
        return contact
    }
    
    func startPayment(products: [GetDraftOrder], total: Double, selectedAddress: ShopifyAddress?, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        
        paymentSummaryItems = []
        
        products.forEach { darftOrder in
            darftOrder.lineItems.forEach { product in
                let item = PKPaymentSummaryItem(label: product.title, amount: NSDecimalNumber(string: "\(product.price).00"), type: .final)
                paymentSummaryItems.append(item)
            }
        }
        
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total).00"), type: .final)
        paymentSummaryItems.append(total)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.io.designcode.sweatershopapp"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        if let selectedAddress = selectedAddress {
            paymentRequest.shippingContact = createPKContact(from: selectedAddress)
        }
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success

        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    if let completionHandler = self.completionHandler {
                        completionHandler(true)
                    }
                } else {
                    if let completionHandler = self.completionHandler {
                        completionHandler(false)
                    }
                }
            }
        }
    }
}
