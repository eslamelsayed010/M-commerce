//
//  Persistence.swift
//  M-commerce-App
//
//  Created by mac on 25/05/2025.
//

import CoreData
import SwiftUI
struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // إضافة بيانات وهمية لـ FavoriteProduct
        let sampleFavorite = FavoriteProduct(context: viewContext)
        sampleFavorite.id = "12345"
        sampleFavorite.title = "Sample Product"
        sampleFavorite.price = 99.99
        sampleFavorite.currencyCode = "$"
        sampleFavorite.image = UIImage(systemName: "photo")?.jpegData(compressionQuality: 0.5)
        
        do {
            try viewContext.save()
            print("Saved preview data successfully")
        } catch {
            let nsError = error as NSError
            print("Failed to save preview data: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "M_commerce_App")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Failed to load persistent stores: \(error), \(error.userInfo)")
            } else {
                print("Loaded persistent store: \(storeDescription)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
