//
//  BankListSearchbar.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 17/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit


class BankListSearchbar: UISearchBar
{
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var currentFrame : CGRect = self.frame
        currentFrame.origin.y = -1.0
        self.frame = currentFrame
        self.clipsToBounds = true;
        self.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 1.0)
    }
    
}