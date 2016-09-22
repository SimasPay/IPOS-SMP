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
        layer.cornerRadius = 5;
        layer.masksToBounds = true;
    }
    
    func updateButtonType1() {
        // background red with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_red)
        self.layer.cornerRadius = 4;
        self.clipsToBounds = true;
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func updateButtonType2() {
        // background red with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_gray)
        self.layer.cornerRadius = 4;
        self.clipsToBounds = true;
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
