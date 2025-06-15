//
//  AboutUsView.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    Text("About Us")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Meet our amazing team")
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
                    AppDescriptionCard()
                    
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.orange)
//                            Text("Supervisor")
//                                .font(.title2)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.primary)
//                        }
//
//                        TeamMemberCard(
//                            name: "Beshoy Adel",
//                            role: "Project Supervisor",
//                            icon: "person.crop.circle.badge.checkmark"
//                        )
//                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "laptopcomputer")
                                .foregroundColor(.orange)
                            Text("Development Team")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        TeamMemberCard(
                            name: "Eslam Elsayed",
                            role: "iOS Developer",
                            icon: "person.crop.circle.fill"
                        )
                        
                        TeamMemberCard(
                            name: "Ahmed Abdeen",
                            role: "iOS Developer",
                            icon: "person.crop.circle.fill"
                        )
                        
                        TeamMemberCard(
                            name: "Amany Adel",
                            role: "iOS Developer",
                            icon: "person.crop.circle.fill"
                        )
                    }
                    
                    // App Stats Section
                    AppStatsCard()
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

struct AppDescriptionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bag.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.orange)
                
                Text("Our Shopify App")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text("We've created a powerful and intuitive mobile commerce application that brings the best of Shopify to your fingertips. Our app provides a seamless shopping experience with modern design, smooth performance, and user-friendly features.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(nil)
            
//            HStack(spacing: 16) {
//                FeatureBadge(text: "Fast & Secure")
//                FeatureBadge(text: "Modern UI")
//                FeatureBadge(text: "Easy to Use")
//            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct TeamMemberCard: View {
    let name: String
    let role: String
    let icon: String
    
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
                Text(name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(role)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.orange)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct AppStatsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.orange)
                
                Text("App Features")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatItem(icon: "cart.fill", title: "Shopping Cart", description: "Seamless checkout")
                StatItem(icon: "heart.fill", title: "Wishlist", description: "Save favorites")
                StatItem(icon: "magnifyingglass", title: "Search", description: "Find products easily")
                StatItem(icon: "person.fill", title: "User Profile", description: "Manage account")
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct StatItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.orange)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

struct FeatureBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.orange)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(20)
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutUsView()
        }
    }
}
