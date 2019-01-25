//
//  ProductViewModel.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation

struct ProductViewModel {
    
    func updateProductList(_ completion: @escaping ([Product]) -> Void) {
        ProductAPI.shared.getProductList { (data) in
            guard let data = data else {
                completion([Product]())
                return
            }
            do {
                let productList = try JSONDecoder().decode(ProductList.self, from: data)
                completion(productList.products)
            } catch {
                completion([Product]())
            }
        }
    }
}
