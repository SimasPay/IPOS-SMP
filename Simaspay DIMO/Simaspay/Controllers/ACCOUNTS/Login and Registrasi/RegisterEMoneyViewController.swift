//
//  RegisterEMoneyViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/9/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class RegisterEMoneyViewController: BaseViewController, UITextFieldDelegate {

    
    @IBOutlet weak var tfConfirmMpin: BaseTextField!
    @IBOutlet weak var tfMpin: BaseTextField!
    @IBOutlet weak var tfHPNumber: BaseTextField!
    @IBOutlet weak var tfEmail: BaseTextField!
    @IBOutlet weak var tfUsername: BaseTextField!
    @IBOutlet weak var btnNext: BaseButton!
    @IBOutlet weak var viewTextField: UIView!
    var MDNString:String!
    var data: NSDictionary!
    var paramsRegistration: NSDictionary!
    static func initWithOwnNib() -> RegisterEMoneyViewController {
        let obj:RegisterEMoneyViewController = RegisterEMoneyViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showBackButton()
        self.showTitle("Pendaftaran Akun E-money")
        btnNext.updateButtonType1()
        btnNext.setTitle("Lanjut", for: .normal)
        
        tfUsername.updateTextFieldWithImageNamed("icon_username")
        tfUsername.placeholder = "Nama Lengkap"
        tfUsername.delegate = self
        
        tfEmail.updateTextFieldWithImageNamed("icon_email")
        tfEmail.placeholder = "E-mail (bila ada)"
        tfEmail.delegate = self
        
        tfHPNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHPNumber.text = MDNString
        tfHPNumber.delegate = self
        
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.placeholder = "mPIN"
        tfMpin.delegate = self
        
        tfConfirmMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfConfirmMpin.placeholder = "Konfirmasi mPIN"
        tfConfirmMpin.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTextField.updateViewRoundedWithShadow()
        tfUsername.addUnderline()
        tfEmail.addUnderline()
        tfHPNumber.addUnderline()
        tfMpin.addUnderline()
        
    }
    
    //MARK: Action button
    @IBAction func actionNextButton(_ sender: AnyObject) {
        var message = "";
        if (!tfUsername.isValid()) {
            message = "Masukkan username Anda"
        } else if !(tfEmail.text! as NSString).isEmail() {
            message = "Email Anda tidak valid"
        } else if (tfMpin.length() < 6) {
            message = "Pin harus 6 digit"
        } else if !((tfConfirmMpin.text?.isEqual(tfMpin.text))!) {
            message = "Pin harus sama"
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }

        self.registrationProcess()
    }
    
    //MARK: keyboard Show set last object above keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfUsername{
            BaseViewController.lastObjectForKeyboardDetector = self.tfUsername
        } else if textField == self.tfEmail{
            BaseViewController.lastObjectForKeyboardDetector = self.tfEmail
        } else if textField == self.tfHPNumber{
            BaseViewController.lastObjectForKeyboardDetector = self.tfConfirmMpin
        } else if textField == self.tfMpin{
            BaseViewController.lastObjectForKeyboardDetector = self.viewTextField
        } else if textField == self.tfConfirmMpin{
            BaseViewController.lastObjectForKeyboardDetector = self.viewTextField
        }
        updateUIWhenKeyboardShow()
        return true
    }

    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var maxLength = 6
        if (tfHPNumber == textField) {
            maxLength = 15
        }
        if (tfEmail == textField) {
            maxLength = 50
        }
        if (tfUsername == textField) {
            maxLength = 50
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
    }

    //MARK: Registration process get security question
    func registrationProcess() {
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_SECURITYQUESTION
        dict[VERSION] = -1
        dict[CHANNEL_ID] = "7"
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            
            
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                let questionData = responseDict["questionData"] as! NSArray
                DLog("\(responseDict)")
                self.data = [
                    "title" : "Pastikan data berikut sudah benar",
                    "content" : [
                        [getString("ConfirmationLabelFullName") : self.tfUsername.text!],
                        [getString("ConfirmationLabelEmail") : self.tfEmail.text!],
                        [getString("ConfirmationLabelNoHandphone") : self.tfHPNumber.text!],
                      
                    ]
                ]
                self.paramsRegistration = [
                    SUB_FIRST_NAME:self.tfUsername.text!,
                    EMAIL:self.tfEmail.text!,
                    SOURCEMDN:getNormalisedMDN(self.tfHPNumber.text! as NSString),
                    ACTIVATION_NEWPIN:simasPayRSAencryption(self.tfMpin.text!),
                    ACTIVATION_CONFORMPIN:simasPayRSAencryption(self.tfConfirmMpin.text!),
                ]
                
                let vc = SecurityQuestionViewController.initWithOwnNib()
                vc.questionData = questionData
                vc.data = self.data
                vc.MDNString = self.tfHPNumber.text!
                vc.dictForAcceptedOTP = self.paramsRegistration as NSDictionary
                self.navigationController?.pushViewController(vc, animated: false)
               
            
                
                
            }
        }
    }

    
}
