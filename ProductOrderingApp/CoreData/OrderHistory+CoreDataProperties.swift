//
//  OrderHistory+CoreDataProperties.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderHistory> {
        return NSFetchRequest<OrderHistory>(entityName: "OrderHistory")
    }

    @NSManaged public var productName: String?
    @NSManaged public var price: Int64
    @NSManaged public var image: String?
    @NSManaged public var date: Date?

}
