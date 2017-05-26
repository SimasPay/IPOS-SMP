//
//  LoginRegisterViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/7/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginRegisterViewController: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btnActivationAccount: BaseButton!
    @IBOutlet weak var tfHPNumber: BaseTextField!
    @IBOutlet weak var lblEntryHPNumber: UILabel!
    @IBOutlet weak var viewTextField: UIView!
    
    
    static func initWithOwnNib() -> LoginRegisterViewController {
        let obj:LoginRegisterViewController = LoginRegisterViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton(subMenu: false)
        
        lblEntryHPNumber.font = UIFont.systemFont(ofSize: 18)
        lblEntryHPNumber.textColor = UIColor.init(hexString: color_text_default)
        lblEntryHPNumber.textAlignment = .center
        lblEntryHPNumber.numberOfLines = 2
        lblEntryHPNumber.text  = "Silakan masukkan Nomor Handphone Anda"
        tfHPNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHPNumber.placeholder = "No. Handphone"
        btnActivationAccount.setTitle("Aktivasi Akun", for: .normal)
        btnActivationAccount.setTitleColor(UIColor.init(hexString: color_text_default), for: .normal)
        btnActivationAccount.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        tfHPNumber.delegate =  self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tfHPNumber.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTextField.updateViewRoundedWithShadow()
        btnActivationAccount.addUnderline()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: action button done in keyboard
    override func btnDoneAction() {
        self.doMDNValidation()
        
        
    }
    
    //MARK: keyboard Show set last object above keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        BaseViewController.lastObjectForKeyboardDetector = self.btnActivationAccount
        updateUIWhenKeyboardShow()
        return true
    }
    
    //MARK: MDN Validation Process
    func doMDNValidation() {
        
        var message = ""
        if (!tfHPNumber.isValid()) {
            message = getString("LoginMessageFillHpNumber")
        } else if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dict = NSMutableDictionary()
        dict[TXNNAME] = SUBSCRIBER_STATUS
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(tfHPNumber.text! as NSString)
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[SIMASPAY_ACTIVITY] = SIMASPAY_ACTIVITY_VALUE
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.current.modelName)  \(UIDevice.current.systemVersion)"
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]

    
       //SimasAPIManager without Session check
        SimasAPIManager .callAPI(withParameters: param, withSessionCheck: false) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            
            
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
                DLog("\(responseDict)")
                let messageText  = responseDict.value(forKeyPath: "subscriberDetails.status.text") as! String
                
                //if MDN have created
                if messageText == SIMASPAY_SUCCESS_CODE {
                    let vc = LoginPinViewController.initWithOwnNib()
                    vc.MDNString = self.tfHPNumber.text!
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    //if new MDN for registration
                    let vc = RegisterEMoneyViewController.initWithOwnNib()
                    vc.MDNString = self.tfHPNumber.text
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
                
            }
        }
    }
    
}
