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
    
    private var tableView: UITableView?
    private let disposeBag = DisposeBag()
    
    var cartObject : (Cart & CartInterfaceProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect.zero, style: .plain);
        if let table = tableView {
            table.rowHeight = 58
            self.view.addSubview(table)
            table.tableFooterView = UIView()
            table.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "productCell")
        }
        // Do any additional setup after loading the view.
        if let cart = cartObject {
            let observable = Observable.just(cart.getHistoryProducts())
            setupCellConfiguration(observable)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView?.frame = self.view.bounds;
    }
    
    //MARK : private methods
    private func setupCellConfiguration(_ observable: Observable<[OrderedProduct]>) {
        if let table = tableView {
            observable.bind(to: table.rx.items) { (tableView, row, product) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: IndexPath(row: row, section: 0)) as! ProductCell
                cell.configureCell(product: product.product)
                return cell
                }
                .disposed(by: self.disposeBag)
        }
        
    }

}
