//
//  ActivationViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet var lblInfoActivation: BaseLabel!
    @IBOutlet var viewTextField: UIView!
    
    @IBOutlet var lblQuestionNoOTP: BaseLabel!
    @IBOutlet var lblQuestionLogin: BaseLabel!
    @IBOutlet var tfActivationCode: BaseTextField!
    @IBOutlet var tfHpNumber: BaseTextField!
    
    @IBOutlet var btnNext: BaseButton!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var btnLogin: UIButton!
    
    static func initWithOwnNib() -> ActivationViewController {
        let obj:ActivationViewController = ActivationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tfHpNumber.delegate = self
        tfActivationCode.delegate = self
        
        lblInfoActivation.text = getString("ActivationLabelInfo")
        lblInfoActivation.textAlignment = .center
        lblInfoActivation.numberOfLines = 3
        
        viewTextField.backgroundColor = UIColor.white
        viewTextField.updateViewRoundedWithShadow()
        tfHpNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHpNumber.placeholder = getString("LoginPlaceholderNoHandphone")
        tfActivationCode.updateTextFieldWithImageNamed("icon_Otp")
        tfActivationCode.placeholder = getString("ActivationPlaceholderOTP")
        tfHpNumber.autocorrectionType = .no
        tfActivationCode.autocorrectionType = .no
        
        lblQuestionNoOTP.text = getString("ActivationQuestionNoOTP")
        lblQuestionNoOTP.font = UIFont.systemFont(ofSize: 14)
        lblQuestionNoOTP.textAlignment = .right
        
        lblQuestionLogin.text = getString("ActivationQuestionForLogin")
        lblQuestionLogin.font = UIFont.systemFont(ofSize: 16)
        lblQuestionLogin.textAlignment = .right
        
        btnResendOTP.setTitle(getString("ActivationButtonResend"), for: UIControlState())
        btnResendOTP.setTitleColor(UIColor.init(hexString: color_text_default), for: UIControlState())
        btnResendOTP.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        btnLogin.setTitle(getString("LoginButtonLogin"), for: UIControlState())
        btnLogin.setTitleColor(UIColor.init(hexString: color_text_default), for: UIControlState())
        btnLogin.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("ActivationButtonNext"), for: UIControlState())
        
        lastObjectForKeyboardDetector = self.btnNext

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tfHpNumber.addUnderline()
        btnResendOTP.addUnderline()
        
        let line = CALayer()
        line.frame = CGRect(x: 0, y: self.btnLogin.bounds.size.height - 10 , width: self.btnLogin.frame.size.width, height: 1)
        line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
        btnLogin.layer.addSublayer(line)
    }

    @IBAction func actionNextButton(_ sender: AnyObject) {
        let vc = ActivationPinViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
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
