//
//  ActivationPinViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationPinViewController: BaseViewController, UITextFieldDelegate{
    
    @IBOutlet var lblInfoUser: BaseLabel!
    
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var tfConfirmMpin: BaseTextField!
    
    @IBOutlet var viewTextField: UIView!
    @IBOutlet var btnSaveMpin: BaseButton!
    
    var activationDict:NSDictionary!
    var otp:String = ""
    
    
    
    static func initWithOwnNib() -> ActivationPinViewController {
        let obj:ActivationPinViewController = ActivationPinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = ("\(activationDict.value(forKeyPath:"name.text") as! String)!")
        let infoString = String(format: String("ActivationLabelInfoInputMpin"), name)
        lblInfoUser.text = infoString as String
        lblInfoUser.textAlignment = .center
        lblInfoUser.numberOfLines = 3
        
        let range = (infoString as NSString).range(of: name)
        let attributedString = NSMutableAttributedString(string:infoString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)], range: range)
        self.lblInfoUser.attributedText = attributedString
        
        
        viewTextField.backgroundColor = UIColor.white
        viewTextField.updateViewRoundedWithShadow()
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.placeholder = getString("ActivationPlaceholderMpin")
        tfConfirmMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfConfirmMpin.placeholder = getString("ActivationPlaceholderConfirmMpin")
        
        tfMpin.delegate = self
        tfConfirmMpin.delegate = self
        
        btnSaveMpin.updateButtonType1()
        btnSaveMpin.setTitle(getString("ActivationButtonSaveMpin"), for: UIControlState())
        DLog("\(activationDict)")
//       self.showOTP()
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tfMpin.addUnderline()
    }
    
    //MARK: keyboard Show set last object above keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        BaseViewController.lastObjectForKeyboardDetector = self.btnSaveMpin
        updateUIWhenKeyboardShow()
        return true
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
    
    //MARK: Action button for save MPIN
    @IBAction func actionSaveMpin(_ sender: AnyObject) {
    
        var message = ""
        if (!tfMpin.isValid()) {
            message =  getString("ActivationMessageFillMpin")
        } else if (!tfConfirmMpin.isValid()) {
            message =  getString("ActivationMessageFillConfirmMpin")
        } else if (tfMpin.length() < 6 || tfConfirmMpin.length() < 6) {
           message =  getString("ActivationMessageSixMpin")
        } else if (tfMpin.text != tfConfirmMpin.text) {
            message =  getString("ActivationMessageFillSameMpin")
        } else if (!SimasAPIManager.isInternetConnectionExist()){
          message = getString("LoginMessageNotConnectServer")
        }
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let mfaModeStatus = activationDict.value(forKeyPath:"mfaMode.text") as! String
        if (mfaModeStatus == "OTP") {
            self.confirmationRequest(otpText: self.otp as NSString)
        } else {
            self.confirmationRequest(otpText: "")
        }
    }
    

    func confirmationRequest(otpText:NSString) {
                
        let activationInquerySctlId = activationDict.value(forKeyPath:"sctlID.text") as! String
        let activationInqueryOTP = activationDict.value(forKeyPath:"ActivationCode") as! String
        let MDNString = activationDict.value(forKey: "MDN") as! String
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_INQUIRY_ACTIVATION
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SIMASPAY_ACTIVITY] = SIMASPAY_ACTIVITY_VALUE
        dict[SOURCEMDN] = getNormalisedMDN(MDNString as NSString)
        dict[ACTIVATION_NEWPIN] = simasPayRSAencryption(tfMpin.text!)
        dict[ACTIVATION_CONFORMPIN] = simasPayRSAencryption(tfConfirmMpin.text!)
        if(otpText.length > 0)
        {
            dict[MFAOTP] = simasPayRSAencryption(otpText as String)
        }
        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
        dict[PARENTTXNID] = activationInquerySctlId
        dict[ACTIVATION_OTP] = activationInqueryOTP
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        SimasAPIManager.callAPI(withParameters: param, withSessionCheck:false) { (dict, err) in
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    SimasAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            let responseDict = dict != nil ? NSMutableDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            let messagecode  = responseDict.value(forKeyPath:"message.code") as! String
            let messageText  = responseDict.value(forKeyPath:"message.text") as! String
            if (messagecode == SIMASPAY_ACTIVATION__CONFIRMATION_SUCCESS_CODE || messagecode == SIMASPAY_ACTIVATION__CONFIRMATION_SUCCESS_CODE1) {
                let vc = ActivationSuccessViewController.initWithMessageInfo(message: getString("ActivationLabelInfoSuccessMessage"),title: getString("ActivationLabelInfoSuccess") )
                self.animatedFadeIn()
                self.navigationController?.pushViewController(vc, animated: false)
            } else if (messagecode == "631") {
                SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                    if index == 0 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                    }
                }, cancelButtonTitle: "OK")
            } else if (messagecode == "2174") {
                SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                    if index == 0 {
                        let vc = ActivationViewController.initWithOwnNib()
                        self.navigationController!.popToViewController(vc, animated: true);
                    }
                }, cancelButtonTitle: "OK")
            
            } else {
                SimasAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
            }
 
            
        }

    }
}
