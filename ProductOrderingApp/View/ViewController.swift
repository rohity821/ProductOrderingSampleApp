//
//  ViewController.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var orderHistoryButton: UIBarButtonItem!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var productList: UITableView!
    
    private var viewModel = ProductViewModel()
    private var productArray = [Product]()
    
    private let disposeBag = DisposeBag()
    
    private var cart : Cart & CartInterfaceProtocol = Cart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        productList.tableFooterView = UIView();
        productList.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "productCell")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.updateProductList { [weak self] (productArr) in
            let observable = Observable.just(productArr)
            self?.setupCellConfiguration(observable)
            self?.hideHUD()
        }
        
        setupCellTabHandling()
        setupCartObserver()
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cartButton.addBadge()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cartControllerSegue") {
            if let destinationController = segue.destination as? ShoppingCartViewController {
                destinationController.cartObject = self.cart
            }
        }
        else if  (segue.identifier == "orderHistorySegue") {
            if let destinationController = segue.destination as? OrderHistoryViewController {
                destinationController.cartObject = self.cart
            }
        }
    }
    
    //MARK: private methods
    
    private func setupCartObserver() {
        self.cart.cartProducts.asObservable().subscribe { (products) in
            self.updateCart()
            }.disposed(by: disposeBag)
    }
    
    private func updateCart() {
        cartButton.updateBadgecount(count: self.cart.cartProducts.value.count)
    }
    
    private func setupCellConfiguration(_ observable: Observable<[Product]>) {
        DispatchQueue.main.async {
            observable.bind(to: self.productList.rx.items) { (tableView, row, product) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: IndexPath(row: row, section: 0)) as! ProductCell
                cell.configureCell(product: product)
                    return cell
                }
                .disposed(by: self.disposeBag)
        }
    }
    
    private func setupCellTabHandling() {
        productList.rx.modelSelected(Product.self).subscribe(onNext: { (product) in
            guard let indexPath = self.productList.indexPathForSelectedRow, let window = UIApplication.shared.keyWindow, let cartView = self.cartButton.value(forKey: "view") as? UIView else {
                return
            }
            self.productList.deselectRow(at: indexPath, animated: true)
            let cell = self.productList.cellForRow(at: indexPath) as! ProductCell
            
            if let textLabel = cell.productName {
                let point = textLabel.convert(textLabel.bounds.origin, to: window)
                let label = UILabel(frame: CGRect(x: point.x, y: point.y, width: textLabel.bounds.width, height: textLabel.bounds.height))
                label.text = textLabel.text
                
                let cartPoint = cartView.convert(cartView.frame.origin, to: nil)
                let center = CGPoint(x: cartPoint.x + cartView.frame.size.width/2, y: cartPoint.y + cartView.frame.size.height/2)
                label.applyAddToCartAnimation(parentView: window, to: center, {
                    self.cart.addProductToCart(product)
                })
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

