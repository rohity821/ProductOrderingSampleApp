//
//  CoreDataManager.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private struct Constant {
        static let storeName = "ProductOrderingApp"
    }
    
    static let shared = CoreDataManager()
    private let historyTask = HistoryTask()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.storeName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var childContext:NSManagedObjectContext = {
        let nContext : NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
        nContext.automaticallyMergesChangesFromParent = true
        return nContext
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("error detected")
            }
        }
    }
    
    func saveChildContext() {
        childContext.performAndWait {
            if  childContext.hasChanges {
                do {
                    try childContext.save()
                } catch {
                }
            }
        }
    }
    
    func addProductsToHistory(productArr:[Product]) {
        historyTask.addProductsToHistory(productArr: productArr, context: CoreDataManager.shared.childContext)
        saveChildContext()
    }
    
    func fetchHistory() -> [OrderedProduct] {
        return historyTask.fetchHistory(context:CoreDataManager.shared.childContext)
    }
}
