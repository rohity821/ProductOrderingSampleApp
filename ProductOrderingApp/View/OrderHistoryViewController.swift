//
//  OrderHistoryViewController.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 26/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "productCell")
        // Do any additional setup after loading the view.
        let observable = Observable.just(Cart.shared.getHistoryProducts())
        setupCellConfiguration(observable)
    }
    
    //MARK : private methods
    private func setupCellConfiguration(_ observable: Observable<[OrderedProduct]>) {
        
        observable.bind(to: self.tableView.rx.items) { (tableView, row, product) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: IndexPath(row: row, section: 0)) as! ProductCell
            cell.configureCell(product: product.product)
            return cell
            }
            .disposed(by: self.disposeBag)
    }

}
