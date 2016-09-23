//
//  ActivationViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationViewController: BaseViewController {
    @IBOutlet var lblInfoActivation: BaseLabel!
    @IBOutlet var viewTextField: UIView!

    @IBOutlet var tfHpNumber: BaseTextField!
    
    @IBOutlet var lblQuestionNoOTP: BaseLabel!
    @IBOutlet var lblQuestionLogin: BaseLabel!
    @IBOutlet var tfActivationCode: BaseTextField!
    
    @IBOutlet var btnNext: BaseButton!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        lblInfoActivation.text = getString("ActivationLabelInfo")
        lblInfoActivation.textAlignment = .Center
        lblInfoActivation.numberOfLines = 3
        
        viewTextField.backgroundColor = UIColor.whiteColor()
        viewTextField.updateViewRoundedWithShadow()
        tfHpNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHpNumber.placeholder = getString("LoginPlaceholderNoHandphone")
        tfHpNumber.addUnderline()
        tfActivationCode.updateTextFieldWithImageNamed("icon_Otp")
        tfActivationCode.placeholder = getString("ActivationPlaceholderOTP")
        
        lblQuestionNoOTP.text = getString("ActivationQuestionNoOTP")
        lblQuestionNoOTP.font = UIFont.systemFontOfSize(14)
        lblQuestionNoOTP.textAlignment = .Right
        
        lblQuestionLogin.text = getString("ActivationQuestionForLogin")
        lblQuestionLogin.font = UIFont.systemFontOfSize(16)
        lblQuestionLogin.textAlignment = .Right
        
        btnResendOTP.setTitle(getString("ActivationButtonResend"), forState: .Normal)
        btnResendOTP.setTitleColor(UIColor.init(hexString: color_text_default), forState: .Normal)
        btnResendOTP.titleLabel?.font = UIFont.systemFontOfSize(14)
        btnResendOTP.addUnderline()
        
        btnLogin.setTitle(getString("LoginButtonLogin"), forState: .Normal)
        btnLogin.setTitleColor(UIColor.init(hexString: color_text_default), forState: .Normal)
        btnLogin.titleLabel?.font = UIFont.systemFontOfSize(16)
        btnLogin.addUnderline()
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("ActivationButtonNext"), forState: .Normal)

    }
    @IBAction func actionNextButton(sender: AnyObject) {
        let vc = EULAViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: true)
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
