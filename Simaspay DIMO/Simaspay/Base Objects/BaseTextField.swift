//
//  BaseTextField.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.updateUI()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    func updateUI() {
        let fontTextField = UIFont.systemFontOfSize(16)
        self.font = fontTextField
    }
    
    func updateTextFieldWithImageNamed(strImg: String) {
        self.leftViewMode = UITextFieldViewMode.Always
        let container = UIView()
        container.frame = CGRectMake(0, 0, 36, 28)
        let imageView = UIImageView(frame: CGRect(x: 4, y: 0, width: 28, height: 28))
        imageView.image = UIImage(named: strImg)
        container.addSubview(imageView)
        self.leftView = container
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
