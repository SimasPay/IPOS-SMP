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
    @IBOutlet var textFieldHpNumber: BaseTextField!
    @IBOutlet var textFieldMPin: BaseTextField!
    @IBOutlet var btnLogin: BaseButton!
    @IBOutlet var btnActivation: BaseButton!
    @IBOutlet var btnContactUs: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginTextField.backgroundColor = UIColor.whiteColor()
        viewLoginTextField.updateViewRoundedWithShadow()
        
        //icon text field
        textFieldHpNumber .updateTextFieldWithImageNamed("icon_Mobile")
        textFieldHpNumber.placeholder = getString("LoginPlaceholderNoHandphone")
        textFieldMPin.updateTextFieldWithImageNamed("icon_Mpin")
        textFieldMPin.placeholder = getString("LoginPlaceholderMpin")
        
        btnLogin.setTitle(getString("LoginButtonLogin"), forState: .Normal)
        btnLogin.updateButtonType1()
        
        btnActivation.setTitle(getString("LoginButtonActivation"), forState: .Normal)
        btnActivation.updateButtonType2()
        
        btnContactUs.setTitle(getString("LoginButtonContactUs"), forState: .Normal)
        btnContactUs .addUnderline()
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
