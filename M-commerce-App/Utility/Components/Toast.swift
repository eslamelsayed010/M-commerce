//
//  Toast.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct Toast: View {
    let errorMessage: String?
    let successMessage: String?
    
    var body: some View {
        if let errorMessage = errorMessage {
            VStack{
                Spacer()
                Text(errorMessage)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }

        if let successMessage = successMessage {
            VStack{
                Spacer()
                Text(successMessage)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

        }

    }
}

extension View {
    func toast(successMessage: String?, errorMessage: String?, isShowing: Binding<Bool>, duration: TimeInterval = 2.0) -> some View {
        ZStack {
            self
            if isShowing.wrappedValue {
                VStack {
                    Toast(errorMessage: errorMessage, successMessage: successMessage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isShowing.wrappedValue = false
                                }
                            }
                        }
                    Spacer()
                }
                .padding(.top, 50)
                .animation(.easeInOut, value: isShowing.wrappedValue)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}


struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        Toast(errorMessage: nil, successMessage: "successMessage")
    }
}
