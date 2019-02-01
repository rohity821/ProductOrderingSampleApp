//
//  CartInteraceProtocol.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 01/02/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CartInterfaceProtocol {
    
    func addProductToCart(_ product: Product)
    
    func removeAllProductsFromCart()
    
    func addCartProductsToHistory()
    
    func removeStaleProductsFromHistory()
    
    func getHistoryProducts() -> [OrderedProduct]
}
