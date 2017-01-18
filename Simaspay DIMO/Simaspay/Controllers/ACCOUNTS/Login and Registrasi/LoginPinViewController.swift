//
//  LoginPinViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/8/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginPinViewController: BaseViewController, UITextFieldDelegate {

    
 
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
        self.showBackButton()

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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tfMpin.becomeFirstResponder()
    }
    
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

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
    }
    func loginProcess(){
        
        var message = ""
        
        if (!tfMpin.isValid()) {
            message = getString("LoginMessageFillMpin")
        } else if (!DIMOAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_LOGIN_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = "f"
        dict[SOURCEMDN] = getNormalisedMDN(MDNString as NSString)
        dict[mPIN_STRING] = simasPayRSAencryption(self.tfMpin.text!)
        dict[CHANNEL_ID] = "7"
        dict[SIMASPAY_ACTIVITY] = "true"
        
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.current.modelName)  \(UIDevice.current.systemVersion)"
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
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
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                var vc = BaseViewController()
                
              if (messagecode == SIMASPAY_LOGIN_SUCCESS_CODE){
                UserDefault.setObject(self.MDNString, forKey: SOURCEMDN)
                UserDefault.setObject(self.MDNString, forKey: ACCOUNT_NUMBER)
                UserDefault.setObject(self.tfMpin.text!, forKey: MPIN)
                UserDefault.setObject(responseDict.value(forKeyPath: "name.text") as! String, forKey: USERNAME)
                if ((responseDict.value(forKeyPath: "isBank.text")  as! String) == "true" ){
                    
                    if ((responseDict.value(forKeyPath: "isEmoney.text") as! String) == "true" ){
                        
                      let accountArray = [
                        ["accountName":"Bank","numberAccount":(responseDict.value(forKeyPath: "bankAccountNumber.text")  as! String),"accountType":HomeViewController.initWithAccountType(AccountType.accountTypeRegular)],
                        ["accountName":"E-money","numberAccount":self.MDNString,"accountType":HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyKYC)]]
                        
                        vc = BankEMoneyViewController.initWithArray(data: accountArray as NSArray)
                        
                    } else {
                        
                        vc = HomeViewController.initWithAccountType(AccountType.accountTypeRegular)
                        
                    }
                    
                } else if ((responseDict.value(forKeyPath: "isEmoney.text") as! String) == "true" ){
                    
                   if  ((responseDict.value(forKeyPath: "isKyc.text") as! String) == "true" ){
                    
                    vc = HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyKYC)
        
                   } else {
                    
                    vc = HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyNonKYC)
                   }
                }
                
                self.navigationController?.pushViewController(vc, animated: false)
                
              } else {
                DIMOAlertView.showAlert(withTitle: "Login", message: messageText, cancelButtonTitle: String("AlertCloseButtonText"))
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
