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
    
    //MARK: button just with corner radius and set font size
    func updateUI() {
        self.layer.cornerRadius = 4;
        self.clipsToBounds = true;
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    //MARK: button type with red background  and white title
    func updateButtonType1() {
        // background red with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_red)
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
    
    //MARK: button type with dark gray background and white title
    func updateButtonType2() {
        // background gray with text white
        self.backgroundColor = UIColor.init(hexString: color_btn_gray)
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
    
    //MARK: button type with light gray background  and white title
    func updateButtonType3() {
        // background light grey with color black   
        self.backgroundColor = UIColor.init(hexString:color_btn_gray2)
        self.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    //MARK: radio button button type wihtout title
    func updateToRadioButton() {
        
        self.setImage(UIImage.init(named: "radiobutton_off.png"), for: UIControlState.normal)
        self.setImage(UIImage.init(named: "radiobutton_on.png"), for: UIControlState.selected)
        self.setTitleColor(UIColor.red, for: UIControlState.selected)
    }
    
    //MARK: radio button button type with title
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
    

}
