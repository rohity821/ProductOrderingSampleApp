//
//  ShoppingCartViewController.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 26/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toaster

class ShoppingCartViewController: UIViewController {
        
    @IBOutlet private var buyNowButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "productCell")
        let observable = Observable.just(Cart.shared.cartProducts.value)
        setupCellConfiguration(observable)
        setupCheckoutButton()
    }
    
    @IBAction func buyNowButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (complete) in
            Cart.shared.addCartProductsToHistory()
            Cart.shared.removeAllProductsFromCart()
            Toast(text: "Your purchase is successful", duration: Delay.short).show()
        })
    }
    
    //MARK: private methods
    
    private func setupCellConfiguration(_ observable: Observable<[Product]>) {
        observable.bind(to: self.tableView.rx.items) { (tableView, row, product) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: IndexPath(row: row, section: 0)) as! ProductCell
            cell.configureCell(product: product)
            return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupCheckoutButton() {
        self.buyNowButton.isUserInteractionEnabled = Cart.shared.cartProducts.value.count > 0
        self.buyNowButton.alpha = self.buyNowButton.isUserInteractionEnabled ? 1.0 : 0.4
    }
}
