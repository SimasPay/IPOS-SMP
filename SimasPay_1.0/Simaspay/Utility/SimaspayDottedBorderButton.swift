//
//  SimaspayDottedBorderView.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 18/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class SimaspayDottedBorderButton: UIButton
{
    var context:CGContextRef!
    var r:CGFloat = 151
    var g:CGFloat = 151
    var b:CGFloat = 151
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        let dashPattern:[CGFloat] = [5, 5]
        context = UIGraphicsGetCurrentContext()!
        CGContextSetRGBStrokeColor(context, r/255, g/255, b/255, 1.0);
        // And draw with a blue fill color
        CGContextSetRGBFillColor(context, r/255, g/255, b/255, 1.0);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 2.0);
        CGContextSetLineDash(context, 0.0, dashPattern, 1);
        CGContextAddRect(context, self.bounds);
        // Close the path
        CGContextClosePath(context);
        CGContextStrokePath(context);
        // Fill & stroke the path
        CGContextDrawPath(context, .FillStroke);
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}