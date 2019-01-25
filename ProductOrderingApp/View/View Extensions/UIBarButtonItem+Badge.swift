//
//  UIBarButtonItem+Badge.swift
//  ProductOrderingApp
//
//  Created by Rohit Yadav on 25/01/19.
//  Copyright © 2019 Rohit Yadav. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    private struct Constants {
        static let badgeDim:CGFloat = 20.0
        static let badgeBorderWidth:CGFloat = 20.0
        static let badgeFontSize:CGFloat = 12.0
        static let badgeLabelTag = 1003
        static let defaultCount = 0
        static let maxCount = 9
        
        static let viewKey = "view"
    }
    
    func addBadge() {
        guard let view = value(forKey: Constants.viewKey) as? UIView else {
            return
        }
        let badgeLabel = view.viewWithTag(Constants.badgeLabelTag) as? UILabel
        
        if badgeLabel != nil {
            return
        }
        let frame = CGRect(x: view.frame.size.width - Constants.badgeDim, y: 0, width: Constants.badgeDim, height: Constants.badgeDim)
        let label = createBadgeLabel(withFrame: frame)
        
        view.addSubview(label)
    }
    
    func updateBadgecount(count:Int) {
        guard let view = value(forKey: Constants.viewKey) as? UIView else {
            return
        }
        if let label = view.viewWithTag(Constants.badgeLabelTag) as? UILabel {
            if count > Constants.maxCount {
                label.text = "\(Constants.maxCount)+"
            } else {
                label.text = "\(count)"
            }
        }
    }
    
    private func createBadgeLabel(withFrame frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = Constants.badgeBorderWidth
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: Constants.badgeFontSize)
        label.textColor = .white
        label.backgroundColor = .red
        label.text = "\(Constants.defaultCount)"
        label.tag = Constants.badgeLabelTag
        
        return label
    }
}

