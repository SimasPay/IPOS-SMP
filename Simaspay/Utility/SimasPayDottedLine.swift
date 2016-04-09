//
//  SimasPayDottedLine.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 14/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

 class SimasPayDottedLine: UIView
{

    override func drawRect(rect: CGRect) {
    
        super.drawRect(rect)
        let dashPattern:[CGFloat] = [2, 2]
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        // And draw with a blue fill color
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
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


