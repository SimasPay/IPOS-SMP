//
//  BaseTextField.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    let inset: CGFloat = 10
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.updateUI()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    func updateUI() {
        let fontTextField = UIFont.systemFont(ofSize: 16)
        self.font = fontTextField
    }
    
    func updateTextFieldWithImageNamed(_ strImg: String) {
        self.leftViewMode = UITextFieldViewMode.always
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 36, height: 28)
        let imageView = UIImageView(frame: CGRect(x: 4, y: 0, width: 28, height: 28))
        imageView.image = UIImage(named: strImg)
        container.addSubview(imageView)
        self.leftView = container
    }
    
    func addInset() {
        self.leftViewMode = UITextFieldViewMode.always
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 10, height: self.bounds.size.height)
        self.leftView = container
    }
  
    
}
