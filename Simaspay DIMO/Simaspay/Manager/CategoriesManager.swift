//
//  CategoriesManager.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import Foundation

extension UIView {
    func updateViewRoundedWithShadow() {
        let temp = UIView(frame: CGRect(origin: CGPointZero, size: frame.size))
        temp.backgroundColor = backgroundColor
        temp.layer.cornerRadius = 5
        temp.clipsToBounds = true
        insertSubview(temp, atIndex: 0)
        
        self.backgroundColor = UIColor.clearColor()
        layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.23).CGColor
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSizeMake(2, 2);
        layer.shadowRadius = 0.5;
    }
}
