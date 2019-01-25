//
//  Cart.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Cart {
    
    static let shared = Cart()
    
    var cartProducts: BehaviorRelay<[Product]> = BehaviorRelay(value: [Product]())
    private var historyProducts: BehaviorRelay<[OrderedProduct]> = BehaviorRelay(value: [OrderedProduct]())
    
    private init() {
        historyProducts.accept(CoreDataManager.shared.fetchHistory())
    }
    
    func addProductToCart(_ product: Product) {
        Cart.shared.cartProducts.accept(Cart.shared.cartProducts.value + [product])
    }
    
    func removeAllProductsFromCart() {
        Cart.shared.cartProducts.accept([])
    }
    
    func addCartProductsToHistory() {
        CoreDataManager.shared.addProductsToHistory(productArr: Cart.shared.cartProducts.value)
        var products = [OrderedProduct]()
        let date = Date()
        for product in Cart.shared.cartProducts.value {
            let historyProduct = OrderedProduct(product: product, date: date)
            products.append(historyProduct)
        }
        Cart.shared.historyProducts.accept(products + Cart.shared.historyProducts.value)
    }
    
    func removeStaleProductsFromHistory() {
        let products = Cart.shared.historyProducts.value.filter {
            if let historyDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -3, to: Date()) {
                return $0.date > historyDate
            }
            return false
        }
        Cart.shared.historyProducts.accept(products)
    }
    
    func getHistoryProducts() -> [OrderedProduct] {
        removeStaleProductsFromHistory()
        return Cart.shared.historyProducts.value
    }
}
