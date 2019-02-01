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

class Cart : CartInterfaceProtocol {
    var cartProducts: BehaviorRelay<[Product]> = BehaviorRelay(value: [Product]())
//    static let shared = Cart()
//    var cartProducts = BehaviorRelay(value: [Product]())
    private var historyProducts: BehaviorRelay<[OrderedProduct]> = BehaviorRelay(value: [OrderedProduct]())
    
    init() {
        historyProducts.accept(CoreDataManager.shared.fetchHistory())
    }
    
    func addProductToCart(_ product: Product) {
        self.cartProducts.accept(self.cartProducts.value + [product])
    }
    
    func removeAllProductsFromCart() {
        self.cartProducts.accept([])
    }
    
    func addCartProductsToHistory() {
        CoreDataManager.shared.addProductsToHistory(productArr: self.cartProducts.value)
        var products = [OrderedProduct]()
        let date = Date()
        for product in self.cartProducts.value {
            let historyProduct = OrderedProduct(product: product, date: date)
            products.append(historyProduct)
        }
        self.historyProducts.accept(products + self.historyProducts.value)
    }
    
    func removeStaleProductsFromHistory() {
        let products = self.historyProducts.value.filter {
            if let historyDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -3, to: Date()) {
                return $0.date > historyDate
            }
            return false
        }
        self.historyProducts.accept(products)
    }
    
    func getHistoryProducts() -> [OrderedProduct] {
        removeStaleProductsFromHistory()
        return self.historyProducts.value
    }
}
