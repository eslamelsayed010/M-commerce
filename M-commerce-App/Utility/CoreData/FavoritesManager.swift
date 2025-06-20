//
//  FavoritesManager.swift
//  M-commerce-App
//
//  Created by mac on 16/06/2025.
//

import CoreData
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    private let persistentContainer: NSPersistentContainer
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    @Published var favoriteProductIDs: Set<String> = []

    private init() {
        persistentContainer = PersistenceController.shared.container
        fetchFavoritesFromFirestore()
    }

    private func cleanProductID(_ productID: String) -> String {
        if productID.contains("gid://shopify/Product/") {
            return productID.replacingOccurrences(of: "gid://shopify/Product/", with: "")
        }
        return productID
    }

    func refreshFavoritesFromFirestore() {
        fetchFavoritesFromFirestore()
    }

    private func fetchFavoritesFromFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.favoriteProductIDs = []
                print("No user logged in, cleared favoriteProductIDs")
            }
            return
        }
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = persistentContainer.viewContext

        db.collection("users").document(userID).collection("favorites").getDocuments { [weak self] snapshot, error in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching favorites: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            privateContext.perform {
                if !documents.isEmpty {
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteProduct.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    do {
                        try privateContext.execute(deleteRequest)
                        print("Cleared existing favorites from private context")
                    } catch {
                        print("Failed to clear Core Data in private context: \(error)")
                    }
                }

                var productIDs: Set<String> = []
                for document in documents {
                    let data = document.data()
                    guard let productID = data["id"] as? String,
                          let title = data["title"] as? String,
                          let price = data["price"] as? Double,
                          let currencyCode = data["currencyCode"] as? String,
                          let imageUrl = data["imageUrl"] as? String else { continue }

                    let favorite = FavoriteProduct(context: privateContext)
                    favorite.id = productID
                    favorite.title = title
                    favorite.price = price
                    favorite.currencyCode = currencyCode

                    if let url = URL(string: imageUrl) {
                        
                        if let imageData = try? Data(contentsOf: url) {
                            favorite.image = imageData
                        } else {
                            favorite.image = Data()
                        }
                    } else {
                        favorite.image = Data()
                    }

                    productIDs.insert(productID)
                }
                do {
                    try privateContext.save()
                    self.persistentContainer.viewContext.perform {
                        do {
                            try self.persistentContainer.viewContext.save()
                            DispatchQueue.main.async {
                                self.favoriteProductIDs = productIDs
                                print("Fetched \(productIDs.count) favorites from Firestore and saved to Core Data")
                            }
                        } catch {
                            print("Failed to save main context: \(error)")
                        }
                    }
                } catch {
                    print("Failed to save private context: \(error)")
                }
            }
        }
    }

    func isFavorite(productID: String) -> Bool {
        favoriteProductIDs.contains(cleanProductID(productID))
    }

    func toggleFavorite(product: Product) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        let context = persistentContainer.viewContext
        let rawProductID = product.id
        let productID = cleanProductID(rawProductID)

        if isFavorite(productID: rawProductID) {
            db.collection("users").document(userID).collection("favorites").document(productID).delete { error in
                if let error = error {
                    print("Failed to remove favorite from Firestore: \(error)")
                    return
                }
                print("Removed favorite from Firestore: \(product.title)")
            }

            
            let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", productID)
            do {
                let favorites = try context.fetch(fetchRequest)
                for favorite in favorites {
                    context.delete(favorite)
                }
                try context.save()
                DispatchQueue.main.async {
                    self.favoriteProductIDs.remove(productID)
                    print("Removed favorite from Core Data: \(product.title)")
                }
            } catch {
                print("Failed to remove favorite from Core Data: \(error)")
            }
        } else {
            
            let favoriteData: [String: Any] = [
                "id": productID,
                "title": product.title,
                "price": product.price ?? 0.0,
                "currencyCode": product.currencyCode ?? "$",
                "imageUrl": product.imageUrls.first ?? ""
                ,"variantId":product.variantId 
            ]

            db.collection("users").document(userID).collection("favorites").document(productID).setData(favoriteData) { error in
                if let error = error {
                    print("Failed to add favorite to Firestore: \(error)")
                    return
                }
                print("Added favorite to Firestore: \(product.title)")
            }

            
            if let firstImageUrl = product.imageUrls.first, let url = URL(string: firstImageUrl) {
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { $0.data }
                    .replaceError(with: Data())
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] imageData in
                        guard let self = self else { return }
                        let favorite = FavoriteProduct(context: context)
                        favorite.id = productID
                        favorite.title = product.title
                        favorite.price = product.price ?? 0.0
                        favorite.currencyCode = product.currencyCode ?? "$"
                    
                        favorite.image = imageData
                        do {
                            try context.save()
                            DispatchQueue.main.async {
                                self.favoriteProductIDs.insert(productID)
                                print("Added favorite to Core Data: \(product.title), ImageSize=\(imageData.count) bytes")
                            }
                        } catch {
                            print("Failed to add favorite to Core Data: \(error)")
                        }
                    }
                    .store(in: &cancellables)
            } else {
                let favorite = FavoriteProduct(context: context)
                favorite.id = productID
                favorite.title = product.title
                favorite.price = product.price ?? 0.0
                favorite.currencyCode = product.currencyCode ?? "$"
                favorite.image = Data()
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        self.favoriteProductIDs.insert(productID)
                        print("Added favorite to Core Data without image: \(product.title)")
                    }
                } catch {
                    print("Failed to add favorite to Core Data: \(error)")
                }
            }
        }
    }

    func clearCoreData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteProduct.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            DispatchQueue.main.async {
                self.favoriteProductIDs.removeAll()
                print("Cleared all favorites from Core Data")
            }
        } catch {
            print("Failed to clear Core Data: \(error)")
        }
    }
}
