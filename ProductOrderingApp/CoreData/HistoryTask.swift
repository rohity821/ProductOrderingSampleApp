//
//  HistoryTask.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation
import CoreData

class HistoryTask {
    
    private struct Constant {
        static let historyEntity = "OrderHistory"
    }
    
    func addProductsToHistory(productArr:[Product], context: NSManagedObjectContext) {
        context.performAndWait {[weak self] in
            let date = Date()
            for item in productArr {
                self?.addHistoryObject(item, date:date, context: context)
            }
        }
    }
    
    func fetchHistory(context: NSManagedObjectContext) -> [OrderedProduct] {
        var arr = [OrderedProduct]()
        let fetchReq : NSFetchRequest<OrderHistory> = OrderHistory.fetchRequest()
        context.performAndWait {
            do {
                let fetchResults = try context.fetch(fetchReq)
                for result in fetchResults {
                    let price = Int(result.price)
                    if let name = result.productName, let image = result.image, let date = result.date {
                        let product = Product(productName: name, price: price, image: image)
                        let historyProduct = OrderedProduct(product: product, date: date)
                        arr.append(historyProduct)
                    }
                }
            } catch {
            }
        }
        return arr.reversed()
    }
    
    //MARK: private methods
    
    private func addHistoryObject(_ product: Product, date: Date, context: NSManagedObjectContext) {
        let orderHistory = NSEntityDescription.insertNewObject(forEntityName: Constant.historyEntity, into: context) as? OrderHistory
        orderHistory?.productName = product.productName
        orderHistory?.price = Int64(product.price)
        orderHistory?.image = product.image
        orderHistory?.date = date
    }
}
