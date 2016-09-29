//
//  LoginViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/21/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
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
        textFieldHpNumber.addUnderline()
        textFieldHpNumber.delegate = self
        textFieldMPin.delegate = self
        
        btnLogin.setTitle(getString("LoginButtonLogin"), forState: .Normal)
        btnLogin.updateButtonType1()
        
        btnActivation.setTitle(getString("LoginButtonActivation"), forState: .Normal)
        btnActivation.updateButtonType2()
        btnActivation.addTarget(self, action:,#selector(EULAViewController.buttonClick) , forControlEvents: .TouchUpInside)
        
        btnContactUs.setTitle(getString("LoginButtonContactUs"), forState: .Normal)
        btnContactUs .addUnderline()
        
    }
    func buttonClick()  {
           let vc = EULAViewController.initWithOwnNib()
          self.animatedFadeIn()
          self.navigationController?.pushViewController(vc, animated: false)
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// MARK: - button action
    @IBAction func btnLoginAction(sender: AnyObject) {
        self.dismissKeyboard()
        
        var message = "";
        if (!textFieldHpNumber.isValid()) {
            message = "Harap masukkan nomor handphone Anda."
        } else if (!textFieldMPin.isValid()) {
            message = "Masukkan mPIN Anda"
        } else if (textFieldMPin.length() < 6) {
            message = "mPIN yang Anda masukkan harus 6 angka."
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = "Tidak dapat terhubung dengan server SimasPay. Harap periksa koneksi internet Anda dan coba kembali setelah beberapa saat."
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlertWithTitle("", message: message, cancelButtonTitle: "OK")
            return
        }
        
        DMBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if (publicKeys == nil || publicKeys.keys.count == 0) {
            var dict = NSMutableDictionary() as [NSObject : AnyObject]
            dict[TXNNAME] = TXN_GETPUBLC_KEY
            dict[SERVICE] = SERVICE_ACCOUNT
            
            DIMOAPIManager .callAPIWithParameters(dict) { (responseDict, error) in
                DMBProgressHUD .hideAllHUDsForView(self.view, animated: true)
                DLog("\(responseDict)")
                
                if (error != nil) {
                    if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                        DIMOAlertView.showAlertWithTitle("", message: error.userInfo["error"] as! String, cancelButtonTitle: "OK")
                    } else {
                        DIMOAlertView.showAlertWithTitle("", message: error.localizedDescription, cancelButtonTitle: "OK")
                    }
                    return
                }
                
                if (responseDict.keys.count == 0) {
                    DIMOAlertView.showAlertWithTitle(nil, message: "Request Failed.", cancelButtonTitle: "OK")
                } else {
                    // success
                    if (responseDict.keys.count > 0) {
                        // set public keys
                        publicKeys = responseDict;
                    }
                    self.doLoginRequest()
                }
            }
        } else {
            self.doLoginRequest()
        }
    }
    
    // MARK: private function
    
    
    func doLoginRequest() {
        DMBProgressHUD .hideAllHUDsForView(self.view, animated: true)
        DMBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_LOGIN_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN(textFieldHpNumber.text!)
        dict[mPIN_STRING] = simasPayRSAencryption(textFieldMPin.text!)
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.currentDevice().modelName)  \(UIDevice.currentDevice().systemVersion)"
        
        DIMOAPIManager .callAPIWithParameters(dict) { (dictionary, error) in
            DMBProgressHUD .hideAllHUDsForView(self.view, animated: true)
            DLog("\(dictionary)")
            
            if (error != nil) {
                DIMOAlertView.showAlertWithTitle(nil, message: error.localizedDescription, cancelButtonTitle: "OK")
                return
            }
            
            if (dictionary.keys.count == 0) {
                DIMOAlertView.showAlertWithTitle(nil, message: "Request Failed.", cancelButtonTitle: "OK")
            } else {
                let responseDict = dictionary as NSDictionary
                let messagecode  = responseDict.valueForKeyPath("message.code") as! String
                let messageText  = responseDict.valueForKeyPath("message.text") as! String
                
                if( messagecode == SIMASPAY_LOGIN_SUCCESS_CODE) {
                    _isLogin = true;
                    _MDNNumber = getNormalisedMDN(self.textFieldHpNumber.text!) as String
                    _mPINCode = self.textFieldMPin.text
                    let userKey = dictionary["userAPIKey"]!["text"]
                    _userApiKey = userKey as! String
                    loginResult = dictionary
                    
                    let isUserType  = responseDict.valueForKeyPath("type.text") as! String
                    
                    
                    if (isUserType == SIMASPAY_LOGIN_AGENT_TYPE) {
                        // AGENT LOGIN FlOW
                        // AGENT FLOW
                        // WARNING: NEED TO IMPLEMENT AGENT FLOW
                        DIMOAlertView.showAlertWithTitle("Not implemented", message: "AGENT", cancelButtonTitle: "OK")
                    } else {
                        let isBank  = responseDict.valueForKeyPath("isBank.text") as! String
                        let vc = HomeViewController.initWithOwnNib() as! HomeViewController
                        
                        if (isBank == SIMASPAY_LOGIN_REGULAR_TYPE) {
                            _SOURCEPOCKETCODE = "2"
                            _DESTPOCKETCODE = "2"
                            vc.accountType = .AccountTypeRegular
                        } else {
                            _SOURCEPOCKETCODE = "6"
                            _DESTPOCKETCODE = "2"
                            vc.accountType = .AccountTypeLakuPandai
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DIMOAlertView.showAlertWithTitle("", message: messageText, cancelButtonTitle: "OK")
                }
                
                self.textFieldMPin.text! = ""
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        var maxLength = 6
        if (textFieldHpNumber == textField) {
            maxLength = 15
        }
        
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
        
        
    }
}
