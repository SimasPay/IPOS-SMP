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
    
//    typealias CompletionBlock = () -> Void
    func getPublicKey(complete : @escaping () -> Void) {
        if (publicKeys == nil || publicKeys.allKeys.count == 0) {
            let dict = NSMutableDictionary()
            dict[TXNNAME] = TXN_GETPUBLC_KEY
            dict[SERVICE] = SERVICE_ACCOUNT
            
            let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
            DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
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
                if (responseDict.allKeys.count == 0) {
                    DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    // success
                    if (responseDict.allKeys.count > 0) {
                        // set public keys
                        publicKeys = responseDict;
                    }
                    complete()
                }
            }
        } else {
            complete()
        }
    }
    
    // MARK: - button action
    @IBAction func btnActivationAction(_ sender: AnyObject) {
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        getPublicKey {
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let vc = EULAViewController.initWithOwnNib()
            self.animatedFadeIn()
            self.navigationController?.pushViewController(vc, animated: false)
        }
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
        DIMOAPIManager .callAPIPOST(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
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
            if (responseDict.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
            } else {
                let vc = ContactUSViewController.initWithOwnNib()
                self.navigationController?.pushViewController(vc, animated: false)
                vc.contactUsInfo = responseDict
                
                
            }
        }
    }
    
    @IBAction func btnLoginAction(_ sender: AnyObject) {
        self.dismissKeyboard()
        
        var message = "";
        if (!textFieldHpNumber.isValid()) {
            message = getString("LoginMessageFillHpNumber")
        } else if (!textFieldMPin.isValid()) {
            message = getString("LoginMessageFillMpin")
        } else if (textFieldMPin.length() < 6) {
            message = getString("LoginMessageSixMpin")
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }
        
        getPublicKey {
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            DMBProgressHUD.showAdded(to: self.view, animated: true)
            self.doLoginRequest()
        }
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
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            DLog("\(dictionary)")
            
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                
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
                        DIMOAlertView.showAlert(withTitle: "Not implemented", message: "AGENT", cancelButtonTitle: String("AlertCloseButtonText"))
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
                    DIMOAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: String("AlertCloseButtonText"))
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
