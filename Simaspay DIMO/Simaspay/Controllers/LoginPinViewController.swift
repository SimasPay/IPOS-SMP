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
//        let vc = HomeViewController.initWithAccountType(AccountType.accountTypeEMoneyKYC)
//        navigationController?.pushViewController(vc, animated: false)
        return
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
        var maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
    }
    func loginProcess(){
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
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            
            
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
                DLog("\(responseDict)")
              
                
                
                
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
