//
//  ProductAPI.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation

struct ProductAPI {
    private struct Constants {
        static let baseUrl = "http://demo6777423.mockable.io"
    }
    
    static let shared = ProductAPI()
    
    private var session:URLSession!
    
    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func getProductList(_ completion: @escaping ((Data?) -> Void)) {
        let urlString = Constants.baseUrl + "/productList.json";
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}
