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
    
    static func initWithOwnNib() -> LoginViewController {
        let obj:LoginViewController = LoginViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginTextField.backgroundColor = UIColor.white
        viewLoginTextField.updateViewRoundedWithShadow()
        
        //icon text field
        textFieldHpNumber .updateTextFieldWithImageNamed("icon_Mobile")
        textFieldHpNumber.placeholder = getString("LoginPlaceholderNoHandphone")
        textFieldMPin.updateTextFieldWithImageNamed("icon_Mpin")
        textFieldMPin.placeholder = getString("LoginPlaceholderMpin")
        textFieldHpNumber.addUnderline()
        textFieldHpNumber.delegate = self
        textFieldMPin.delegate = self
        
        btnLogin.setTitle(getString("LoginButtonLogin"), for: UIControlState())
        btnLogin.updateButtonType1()
        
        btnActivation.setTitle(getString("LoginButtonActivation"), for: UIControlState())
        btnActivation.updateButtonType2()
        
        btnContactUs.setTitle(getString("LoginButtonContactUs"), for: UIControlState())
        btnContactUs.addUnderline()
        
        let timer = SimasAPIManager.staticTimer()
        timer?.invalidate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldHpNumber.addUnderline()
        btnContactUs.addUnderline()
    }
    

    
    // MARK: - button action
    @IBAction func btnActivationAction(_ sender: AnyObject) {
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let vc = ActivationViewController.initWithOwnNib()
            self.animatedFadeIn()
            self.navigationController?.pushViewController(vc, animated: false)
      
    }
    
    @IBAction func btnContactUsAction(_ sender: AnyObject) {
        self.dismissKeyboard()
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_CONTACTUS
        dict[VERSION] = "0"
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        SimasAPIManager .callAPIPOST(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    SimasAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            if (responseDict.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let vc = ContactUSViewController.initWithOwnNib()
                self.navigationController?.pushViewController(vc, animated: false)
                vc.contactUsInfo = responseDict
                
                
            }
        }
    }
    
    @IBAction func btnLoginAction(_ sender: AnyObject) {
//        let vc = HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyKYC)
//        navigationController?.pushViewController(vc, animated: false)
//        return
        
        
        self.dismissKeyboard()
        
        var message = "";
        if (!textFieldHpNumber.isValid()) {
            message = getString("LoginMessageFillHpNumber")
        } else if (!textFieldMPin.isValid()) {
            message = getString("LoginMessageFillMpin")
        } else if (textFieldMPin.length() < 6) {
            message = getString("LoginMessageSixMpin")
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
            self.doLoginRequest()
        
    }
    
    // MARK: private function
    
    
    func doLoginRequest() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_LOGIN_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN(textFieldHpNumber.text! as NSString)
        dict[mPIN_STRING] = simasPayRSAencryption(textFieldMPin.text!)
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.current.modelName)  \(UIDevice.current.systemVersion)"
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        SimasAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            DLog("\(dictionary)")
            
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    SimasAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                DLog("\(responseDict)")
                if( messagecode == SIMASPAY_LOGIN_SUCCESS_CODE) {
                    _isLogin = true;
                    _MDNNumber = getNormalisedMDN(self.textFieldHpNumber.text! as NSString) as String
                    _mPINCode = self.textFieldMPin.text
                    let userKey = dictionary.value(forKeyPath: "userAPIKey.text")
                    _userApiKey = userKey as! String
                    loginResult = dictionary
                    
                    let isUserType  = responseDict.value(forKeyPath: "type.text") as! String
                    
                    
                    if (isUserType == SIMASPAY_LOGIN_AGENT_TYPE) {
                        // AGENT LOGIN FlOW
                        // AGENT FLOW
                        // WARNING: NEED TO IMPLEMENT AGENT FLOW
                        SimasAlertView.showAlert(withTitle: "Not implemented", message: "AGENT", cancelButtonTitle: getString("AlertCloseButtonText"))
                    } else {
                        let isBank  = responseDict.value(forKeyPath: "isBank.text") as! String
                        let vc = HomeViewController.initWithOwnNib()
                        
                        if (isBank == SIMASPAY_LOGIN_REGULAR_TYPE) {
                            _SOURCEPOCKETCODE = "2"
                            _DESTPOCKETCODE = "2"
                            vc.accountType = .accountTypeRegular
                        } else {
                            _SOURCEPOCKETCODE = "6"
                            _DESTPOCKETCODE = "2"
                            vc.accountType = .accountTypeLakuPandai
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
                self.textFieldMPin.text! = ""
            }
        }
    }
    
    // MARK: textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var maxLength = 6
        if (textFieldHpNumber == textField) {
            maxLength = 15
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        BaseViewController.lastObjectForKeyboardDetector = self.btnLogin
        updateUIWhenKeyboardShow()
        return true
    }
}
