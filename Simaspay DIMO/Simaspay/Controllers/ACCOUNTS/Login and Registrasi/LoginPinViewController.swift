//
//  LoginPinViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/8/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginPinViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var btnLostPassword: BaseButton!
    @IBOutlet weak var tfMpin: BaseTextField!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var lblInfoNumber: BaseLabel!
    
    var MDNString:String!
    
    static func initWithOwnNib() -> LoginPinViewController {
        let obj:LoginPinViewController = LoginPinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBackButton(subMenu: false)

        let phone:String = MDNString
        let infoString = String(format: String("Silakan masukkan mPIN untuk nomor HP %@"), phone)
        lblInfoNumber.text = infoString as String
        lblInfoNumber.textAlignment = .center
        lblInfoNumber.numberOfLines = 3
        
        let range = (infoString as NSString).range(of: phone)
        let attributedString = NSMutableAttributedString(string:infoString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)], range: range)
        self.lblInfoNumber.attributedText = attributedString
        
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.delegate = self
        tfMpin.placeholder = "Pin"
        
        btnLostPassword.setTitle(getString("LoginButtonLostmPin"), for: UIControlState())
        btnLostPassword.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tfMpin.text = ""
        tfMpin.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfMpin.text = ""
    }
    
    //MARK: action button done in keyboard
    override func btnDoneAction() {
        self.loginProcess()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTextField.updateViewRoundedWithShadow()
        btnLostPassword.addUnderline()
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
    }
    
    //MARK: Login process
    func loginProcess(){
        
        
        var message = ""
        
        if (!tfMpin.isValid()) {
            message = getString("LoginMessageFillMpin")
        } else if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_LOGIN_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(MDNString as NSString)
        dict[mPIN_STRING] = /*"814f8147ddcbdba05fad8bd5cf125530d9f5dece879d2b908d4b139cbb3f216ac8b7eb312a71b0cc0a3681d26074aa1e9f6c5299f2bf104fa277417bb57b8005" */simasPayRSAencryption(self.tfMpin.text!)/*"34680a237df794396d653e4c7f425aacffbc9445973444a9f935f9680ff81bca59b54b6dc4d683c2d05984a95ff4d689ec0a402707b1b83c865eb1342cc56967"*/
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[SIMASPAY_ACTIVITY] = SIMASPAY_ACTIVITY_VALUE
        dict[SOURCE_APP_TYPE_KEY] = "" /*SOURCE_APP_TYPE_VALUE*/
        dict[SOURCE_APP_VERSION_KEY] = ""/*version*/
        dict[SOURCE_APP_OSVERSION_KEY] = ""/*"\(UIDevice.current.modelName)  \(UIDevice.current.systemVersion)"*/
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
        SimasAPIManager .callAPI(withParameters: param, withSessionCheck: false) { (dict, err) in
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
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                SimasAPIManager.sharedInstance().encryptedMPin = simasPayRSAencryption(self.tfMpin.text!)
                
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                var vc = BaseViewController()
                if (messagecode == SIMASPAY_LOGIN_SUCCESS_CODE){
                    UserDefault.setObject(self.MDNString, forKey: SOURCEMDN)
                    UserDefault.setObject(self.MDNString, forKey: ACCOUNT_NUMBER)
                    UserDefault.setObject(self.tfMpin.text, forKey: mPin)
                    
                    if (dictionary.value(forKeyPath: "profileImageString.text") != nil) {
                        UserDefault.setObject(dictionary.value(forKeyPath: "profileImageString.text") as! String, forKey: "imageProfil")
                    }
                    
                    UserDefault.setObject(responseDict.value(forKeyPath: "name.text") as! String, forKey: USERNAME)
                    
                    if responseDict.value(forKey: "userAPIKey") != nil {
                        UserDefault.setObject(responseDict.value(forKeyPath: "userAPIKey.text") as! String, forKey: GET_USER_API_KEY)
                    }
                   
                    if ((responseDict.value(forKeyPath: "isBank.text")  as! String) == "true" ){
                        
                        if ((responseDict.value(forKeyPath: "isEmoney.text") as! String) == "true" ){
                            
                            let accountArray = [
                                ["accountName":"Bank","numberAccount":(responseDict.value(forKeyPath: "bankAccountNumber.text")  as! String),"accountType":HomeViewController.initWithAccountType(AccountType.accountTypeRegular)],
                                ["accountName":"E-money","numberAccount":self.MDNString,"accountType":HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyKYC)]]
                            
                            vc = BankEMoneyViewController.initWithArray(data: accountArray as NSArray)
                            
                        } else {
                            vc = HomeViewController.initWithAccountTypeAndReqEmoney(AccountType.accountTypeRegular, reqEmoney: false)
                        }
                        
                    } else if ((responseDict.value(forKeyPath: "isEmoney.text") as! String) == "true" ){
                        
                        if  ((responseDict.value(forKeyPath: "isKyc.text") as! String) == "true" ){
                            
                            vc = HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyKYC)
                            
                        } else {
                            
                            vc = HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyNonKYC)
                        }
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                } else if(messagecode == "2182"){
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            let vc = ChangeMpinViewController.initWithOwnNib()
                            vc.mdn = self.MDNString
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }, cancelButtonTitle: "OK")
                } else if(messagecode == "2315"){
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            let vc = ChangeMpinViewController.initWithOwnNib()
                            vc.mdn = self.MDNString
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    SimasAlertView.showAlert(withTitle: "Login", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
            }
        }

    }
    
    
    @IBAction func actionLostPassword(_ sender: Any) {
        self.tfMpin.resignFirstResponder()
        let dict = NSMutableDictionary()
        let mdn: String!
        
        if (UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) != nil) {
            mdn = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString) as String!
        } else {
            mdn = getNormalisedMDN(self.MDNString! as NSString) as String!
        }
        
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_MDN_VALIDATION_FORGOT_PIN
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = mdn
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
        SimasAPIManager .callAPI(withParameters: param) { (dict, err) in
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
            
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                if ( messagecode == "2300" ){
                    SimasAlertView.showAlert(withTitle: "Reset mPIN Anda", message: "Silakan datang ke ATM Bank Sinarmas terdekat, lalu lakukan reset mPIN di menu Lainnya > Registrasi M-Banking.", cancelButtonTitle: getString("AlertCloseButtonText"))
                } else if ( messagecode == "2301" ) {
                    let vc = SecurityQuestionResetController.initWithOwnNib()
                    vc.mdn = mdn
                    vc.question = responseDict.value(forKeyPath: "securityQuestion.text") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == "631") {
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
