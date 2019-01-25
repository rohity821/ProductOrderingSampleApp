//
//  ViewController.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var orderHistoryButton: UIBarButtonItem!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var productList: UITableView!
    
    private var viewModel = ProductViewModel()
    private var productArray = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        productList.tableFooterView = UIView();
        
        viewModel.updateProductList { [weak self] (productArr) in
            print("api fetch successful")
            self?.productArray = productArr
            self?.reloadTableView()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.productList.reloadData()
        }
    }
    
    // MARK: UITable View Data source and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as? ProductCell, indexPath.row < productArray.count {
            let product = productArray[indexPath.row]
            cell.configureCell(product: product);
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "productCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58.0;
    }


}

