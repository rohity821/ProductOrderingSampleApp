//
//  ProductCell.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product) {
        productName.text = product.productName
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: product.price as NSNumber) {
            productPriceLabel.text = "\(formattedTipAmount)"
        }
        productImageView.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "placeholder"))

    }
}
