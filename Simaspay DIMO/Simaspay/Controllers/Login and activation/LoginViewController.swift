//
//  LoginViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/21/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet var viewLoginTextField: UIView!
    @IBOutlet var textFieldHpNumber: UITextField!
    @IBOutlet var textFieldMPin: UITextField!
    @IBOutlet var btnLogin: BaseButton!
    @IBOutlet var btnActivation: BaseButton!
    @IBOutlet var btnContactUs: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginTextField.backgroundColor = UIColor.whiteColor()
        viewLoginTextField.updateViewRoundedWithShadow()
        
        //icon text field
        textFieldHpNumber.leftViewMode = UITextFieldViewMode.Always
        let imageViewHp = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageViewHp.image = UIImage(named: "icon_Mobile")
        textFieldHpNumber.leftView = imageViewHp
        
        textFieldMPin.leftViewMode = UITextFieldViewMode.Always
        let imageViewMpin = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageViewMpin.image = UIImage(named: "icon_Mpin")
        textFieldMPin.leftView = imageViewMpin
        
        //texfield font
        let fontTextField = UIFont(name: "HelveticaNeue-Light", size: 16)
        textFieldHpNumber.font = fontTextField
        textFieldMPin.font = fontTextField
        
        //Placeholder
        textFieldHpNumber.attributedPlaceholder = NSAttributedString(string:getString("LoginPlaceholderNoHandphone"),
                                                               attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        textFieldMPin.attributedPlaceholder = NSAttributedString(string:getString("LoginPlaceholderMpin"),
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        btnLogin.setTitle(getString("LoginButtonLogin"), forState: .Normal)
        btnLogin.updateButtonType1()
        btnActivation.setTitle(getString("LoginButtonActivation"), forState: .Normal)
        btnActivation.updateButtonType2()
        btnContactUs.setTitle(getString("LoginButtonContactUs"), forState: .Normal)
    
        //buttonUnderline
        let line = CALayer()
        line.frame = CGRectMake(0, btnContactUs.frame.size.height - 1 , btnContactUs.frame.size.width, 1)
        line.backgroundColor = UIColor.init(hexString: color_btn_gray).CGColor
        btnContactUs.layer.addSublayer(line)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
