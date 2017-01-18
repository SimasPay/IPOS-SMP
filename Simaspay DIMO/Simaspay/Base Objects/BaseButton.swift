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
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    func updateButtonType1() {
        // background red with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_red)
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
    
    func updateButtonType2() {
        // background gray with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_gray)
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
    
    func updateButtonType3() {
        // background light grey with color black   
        self.backgroundColor = UIColor.init(hexString:color_btn_gray2)
        self.setTitleColor(UIColor.black, for: UIControlState())
    }

    func updateToRadioButton() {
        
        self.setImage(UIImage.init(named: "radiobutton_off.png"), for: UIControlState.normal)
        self.setImage(UIImage.init(named: "radiobutton_on.png"), for: UIControlState.selected)
        self.setTitleColor(UIColor.red, for: UIControlState.selected)
    }
    func updateToRadioButtonWith(_titleButton:String) {
        self.contentHorizontalAlignment = .left;
        self.setImage(UIImage.init(named: "radiobutton_off.png"), for: UIControlState.normal)
        self.setImage(UIImage.init(named: "radiobutton_on.png"), for: UIControlState.selected)
        self.setTitle(_titleButton, for: .normal)
        self.setTitleColor(UIColor.init(hexString: color_text_default), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let insetAmount:CGFloat = 5
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount * 2, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
