//
//  DashedBorderView.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class DashedBorderButton: UILabel {
    
    var _border:CAShapeLayer!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        _border = CAShapeLayer();
        
        _border.strokeColor = UIColor.whiteColor().CGColor;
        _border.fillColor = nil;
        _border.lineDashPattern = [4, 4];
        self.layer.addSublayer(_border);
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).CGPath;
        _border.frame = self.bounds;
    }
}