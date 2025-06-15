//
//  ContactUsView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//
import SwiftUI

struct ContactUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    Text("Contact Us")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("We'd love to hear from you")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                VStack(spacing: 20) {
                    ContactCard(
                        icon: "phone.fill",
                        title: "Phone",
                        subtitle: "Call us directly",
                        mainText: "(+20)1099947455",
                        secondaryText: "Mon - Fri, 9AM - 6PM EST"
                    )
                    
                    ContactCard(
                        icon: "envelope.fill",
                        title: "Email",
                        subtitle: "Send us a message",
                        mainText: "eslimelseyd@gmail.com",
                        secondaryText: "We'll respond within 24 hours"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ContactCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let mainText: String
    let secondaryText: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                }
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(mainText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                
                Text(secondaryText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactUsView()
        }
    }
}
