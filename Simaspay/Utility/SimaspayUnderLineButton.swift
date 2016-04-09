//
//  SimaspayUnderLineButton.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 17/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class SimaspayUnderLineButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func drawRect(rect: CGRect) {
        
        
        let textRect = self.titleLabel!.frame;
        // need to put the line at top of descenders (negative value)
        let descender = self.titleLabel?.font.descender
        
        let contextRef = UIGraphicsGetCurrentContext()
        // set to same colour as text
        //CGContextSetStrokeColorWithColor(contextRef, self.titleLabel!.textColor.CGColor);
        CGContextSetStrokeColorWithColor(contextRef, UIColor.lightGrayColor().CGColor);
        
        CGContextMoveToPoint(contextRef, textRect.origin.x-10, 8+textRect.origin.y + textRect.size.height + descender!);
        
        CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width+10, 8+textRect.origin.y + textRect.size.height + descender!);
        
        CGContextClosePath(contextRef);
        
        CGContextDrawPath(contextRef, .Stroke);
    }
    
}
