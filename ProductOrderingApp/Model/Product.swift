//
//  Product.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation

struct ProductList:Codable {
    var products:[Product]
}

struct Product: Codable, Equatable {
    var name:String
    var cost:Int
    var image : String
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name
    }
}
