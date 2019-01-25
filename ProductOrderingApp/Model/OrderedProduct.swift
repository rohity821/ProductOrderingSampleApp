//
//  OrderedProduct.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation

struct OrderedProduct: Equatable {
    var product: Product
    var date: Date
    
    static func == (lhs: OrderedProduct, rhs: OrderedProduct) -> Bool {
        return lhs.product.productName == rhs.product.productName
    }
}
