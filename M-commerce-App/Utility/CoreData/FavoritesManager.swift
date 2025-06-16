//
//  FavoritesManager.swift
//  M-commerce-App
//
//  Created by mac on 16/06/2025.
//

import CoreData
import SwiftUI
import Combine

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    private let persistentContainer: NSPersistentContainer
    private var cancellables = Set<AnyCancellable>()

    @Published var favoriteProductIDs: Set<String> = []

    private init() {
        persistentContainer = PersistenceController.shared.container
        fetchFavorites()
    }

    private func fetchFavorites() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        do {
            let favorites = try context.fetch(fetchRequest)
            favoriteProductIDs = Set(favorites.map { $0.id ?? "" })
            for favorite in favorites {
                print("Fetched favorite: ID=\(favorite.id ?? ""), Title=\(favorite.title ?? ""), Price=\(favorite.price), ImageSize=\(favorite.image?.count ?? 0) bytes")
            }
        } catch {
            print("Failed to fetch favorites: \(error)")
        }
    }

    func isFavorite(productID: String) -> Bool {
        favoriteProductIDs.contains(productID)
    }

    func toggleFavorite(product: Product) {
        let context = persistentContainer.viewContext
        let productID = product.id

        if isFavorite(productID: productID) {
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
                    print("Removed favorite: \(product.title)")
                }
            } catch {
                print("Failed to remove favorite: \(error)")
            }
        } else {
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
                                print("Added favorite: \(product.title), ImageSize=\(imageData.count) bytes")
                            }
                        } catch {
                            print("Failed to add favorite: \(error)")
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
                        print("Added favorite without image: \(product.title)")
                    }
                } catch {
                    print("Failed to add favorite: \(error)")
                }
            }
        }
    }
}
