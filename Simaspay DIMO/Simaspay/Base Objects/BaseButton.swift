//
//  BaseButton.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/21/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.updateUI()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    func updateUI() {
        self.layer.cornerRadius = 4;
        self.clipsToBounds = true;
        self.titleLabel?.font = UIFont.systemFontOfSize(20)
    }
    
    func updateButtonType1() {
        // background red with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_red)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func updateButtonType2() {
        // background gray with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_gray)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func updateButtonType3() {
        // background light grey with color black   
        self.backgroundColor = UIColor.init(hexString:color_btn_gray2)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
