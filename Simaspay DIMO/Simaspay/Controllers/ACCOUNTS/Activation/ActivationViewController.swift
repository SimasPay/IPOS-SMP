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

    @IBAction func actionResendOTP(_ sender: AnyObject) {
        self.resendOTP()
    }
    @IBAction func actionNextButton(_ sender: AnyObject) {
//        let vc = ActivationPinViewController.initWithOwnNib()
//        self.animatedFadeIn()
//        self.navigationController?.pushViewController(vc, animated: false)
        self.activation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionBackLogin(_ sender: AnyObject) {
      let vc = LoginRegisterViewController.initWithOwnNib()
      self.navigationController!.pushViewController(vc, animated: true);
              
       

    }
    func activation() {
        var message = "";
        if (!tfHpNumber.isValid()) {
            message = getString("ActivationMessageFillHpNumber")
        } else if (!tfActivationCode.isValid()) {
            message = getString("ActivationMessageFillActivation")
        } else if (tfActivationCode.length() < 6) {
            message = getString("ActivationMessageSixActivation")
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_INQUIRY_ACTIVATION
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN(self.tfHpNumber.text! as NSString)
        dict[ACTIVATION_OTP] =  simasPayRSAencryption(tfActivationCode.text!)
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        dict[MFATRANSACTION] = INQUIRY
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager.callAPI(withParameters: param) { (dict, err) in
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            
            let responseDict = dict != nil ? NSMutableDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            let messagecode  = responseDict.value(forKeyPath:"message.code") as! String
            let messageText  = responseDict.value(forKeyPath:"message.text") as! String
            if messagecode == SIMASPAY_ACTIVATION__INQUERY_SUCCESS_CODE {
                let vc = ActivationPinViewController.initWithOwnNib()
                responseDict ["MDN"] = getNormalisedMDN(self.tfHpNumber.text! as NSString ) as String!
                responseDict ["ActivationCode"] = simasPayRSAencryption(self.tfActivationCode.text!)
                vc.activationDict = responseDict
                self.animatedFadeIn()
                self.navigationController?.pushViewController(vc, animated: false)
            } else {
                DIMOAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: String("AlertCloseButtonText"))
            }
        }
    }
    
    func resendOTP() {
        
        if (!tfHpNumber.isValid()) {
            DIMOAlertView.showAlert(withTitle: "", message: getString("LoginMessageFillHpNumber"), cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_RESENDOTP
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN(self.tfHpNumber.text! as NSString)
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager.callAPIPOST(withParameters: param) { (dict, err) in
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            
            let messageText  = responseDict.value(forKeyPath: "message.text") as! String
            if((responseDict.object(forKey: "OneTimePin")) != nil)
            {
                DIMOAlertView.showAlert(withTitle: getString("ActivationAlertTitleResendOTP"), message: getString("ActivationAlertResendOTP"), cancelButtonTitle: String("AlertCloseButtonText"))
            }else{
                DIMOAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: String("AlertCloseButtonText"))
            }

        }
       
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var maxLength = 6
        if (tfHpNumber == textField) {
            maxLength = 15
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfHpNumber{
            BaseViewController.lastObjectForKeyboardDetector = self.btnResendOTP.superview
        } else {
            BaseViewController.lastObjectForKeyboardDetector = self.btnNext
        }
        updateUIWhenKeyboardShow()
        return true
    }


}
