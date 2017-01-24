//
//  BaseLabel.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/21/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.updateForDefaultLabel()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateForDefaultLabel()
    }
    
    //MARK: setting default all label
    func updateForDefaultLabel() {
        // system font with size 16
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor.init(hexString: color_text_default)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
