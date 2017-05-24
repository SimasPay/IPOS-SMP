//
//  NewPinController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/23/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import Foundation

import Foundation

import UIKit

class NewPinController: BaseViewController, UIAlertViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tfConfirmMpin: BaseTextField!
    @IBOutlet weak var tfMpin: BaseTextField!
    @IBOutlet weak var btnRegister: BaseButton!
    @IBOutlet weak var btnScrollView: NSLayoutConstraint!
    @IBOutlet weak var lblInfo: BaseLabel!
    
    @IBOutlet weak var viewMPin: UIView!
    @IBOutlet weak var viewConfirmMpin: UIView!
    
    var sctlID: String!
    var mdn: String = ""
    
    //Timer for OTP resend button
    var timerCount = 60
    var clock:Timer!
    var lblTimer: BaseLabel!
    
    var strMdn:String! = ""
    var otpString:String! = ""
    
    var tfOTP: BaseTextField!
    
    var alertController = UIAlertController()
    
    static func initWithOwnNib() -> NewPinController {
        let obj:NewPinController = NewPinController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegister.updateButtonType1()
        btnRegister.setTitle("Simpan", for: .normal)
        
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.placeholder = "mPIN"
        tfMpin.delegate = self
        tfMpin.tag = 1
        
        tfConfirmMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfConfirmMpin.placeholder = "Konfirmasi mPIN"
        tfConfirmMpin.delegate = self
        tfConfirmMpin.tag = 2
        
        var name: String = ""
        if UserDefault.objectFromUserDefaults(forKey: USERNAME) != nil {
            name = (UserDefault.objectFromUserDefaults(forKey: USERNAME) as! String?)!
        }
        
        let infoString = String(format: String("Hai %@ Silakan tentukan 6 digit mPIN baru untuk akun Simaspay Anda"), name)
        lblInfo.text = infoString as String
        lblInfo.textAlignment = .center
        lblInfo.numberOfLines = 3
        
        let range = (infoString as NSString).range(of: name)
        let attributedString = NSMutableAttributedString(string:infoString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)], range: range)
        self.lblInfo.attributedText = attributedString
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewMPin.updateViewRoundedWithShadow()
        viewConfirmMpin.updateViewRoundedWithShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPCancel), name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPOK), name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
        
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        self.btnScrollView.constant = BaseViewController.keyboardSize.height
        self.view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        self.btnScrollView.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        var message = "";
        
        if (!tfMpin.isValid()) {
            message = "mPin wajib diisi"
        } else if (tfMpin.isValid() && tfMpin.length() != 6) {
            message = "mPin harus 6 digit"
        } else if (!tfConfirmMpin.isValid()) {
            message = "Konfirmasi mPin wajib diisi"
        } else if !((tfConfirmMpin.text?.isEqual(tfMpin.text))!) {
            message = "Konfirmasi mPin dan mPin harus sama"
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        self.requestOTP()
        self.showOTP()
    }
    
    
    //MARK: Action button for OTP alert
    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
    }
    
    func didOTPOK() {
        DLog("OK");
        clock.invalidate()
        self.sendOTP(OTP: self.otpString)
    }
    
    //MARK: Count down timer
    func countDown(){
        if (timerCount > 0) {
            timerCount -= 1
            lblTimer.text = "00:\(timerCount)"
        } else {
            self.alertController.dismiss(animated: true, completion: {
                SimasAlertView.showAlert(withTitle: getString("titleEndOtp"), message: getString("messageEndOtp"), cancelButtonTitle: getString("AlertCloseButtonText"))
            })
            clock.invalidate()
        }
    }
    
    
    //MARK: Show OTP Alert
    func showOTP()  {
        timerCount = 60
        alertController = UIAlertController(title: getString("ConfirmationOTPMessageTitle") + "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let temp = UIView(frame: CGRect(x: 0, y: 40, width: 270, height: 100))
        let MDNString = ("\(getNormalisedMDN(strMdn! as NSString))")
        let messageString = String(format: getString("ConfirmationOTPMessage"), MDNString)
        let messageAlert = UILabel(frame: CGRect(x: 10, y: 10, width: temp.frame.size.width - 20, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = messageString as String
        
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ActivationPinViewController.countDown), userInfo: nil, repeats: true)
        
        
        lblTimer = BaseLabel(frame: CGRect(x: 0, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 10, width: temp.frame.size.width, height: 15))
        lblTimer.textAlignment = .center
        lblTimer.font = UIFont.systemFont(ofSize: 12)
        lblTimer.text = "01:00"
        
        temp.addSubview(lblTimer)
        temp.addSubview(messageAlert)
        
        alertController.view.addSubview(temp)
        let cancelAction = UIAlertAction(title:"Cancel",
                                         style: .default) { (action) -> Void in
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        }
        
        let okAction = UIAlertAction(title:"Ok", style: .cancel) { (action) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
        }
        
        
        alertController.addTextField { (textField) -> Void in
            textField.layer.borderColor = UIColor.init(hexString: color_border).cgColor
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
            textField.placeholder = getString("ConfirmationOTPTextFieldPlaceholder")
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(sender:)),
                                for: .editingChanged)
            textField.delegate = self
            textField.tag = 10
            
        }
        
        okAction.isEnabled = false
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(self.alertController, animated: true, completion:{})
            self.alertController.view.endEditing(true)
        }
        // showOTPWith(title: getString("ConfirmationOTPMessageTitle"), view: temp)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 10 {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            self.otpString = newString as String!
            return newString.length <= maxLength
        } else if textField.tag == 1 || textField.tag == 2 {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        
        } else {
            return true
        }
    }
    
    func alertTextFieldDidChange(sender : UITextField) {
        guard let alertController = self.presentedViewController as? UIAlertController,
            let otp = sender.text,
            let submitAction = alertController.actions.last else {
                return
        }
        submitAction.isEnabled = otp.characters.count == 4
    }
    
    //MARK: Request OTP
    func requestOTP() {
        let dictOtp = NSMutableDictionary()
        dictOtp[TXNNAME] = TXN_RESEND_MFAOTP_NO_PIN
        dictOtp[SERVICE] = SERVICE_WALLET
        dictOtp[INSTITUTION_ID] = SIMASPAY
        dictOtp[SOURCEMDN] = mdn
        dictOtp[SCTL_ID] = sctlID
        dictOtp[AUTH_KEY] = ""
        
        DLog("\(dictOtp)")
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        SimasAPIManager .callAPI(withParameters: dictOtp as! [AnyHashable : Any]) { (dict, err) in
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
                
                
            }
        }
    }
    
    //MARK: Send OTP
    func sendOTP(OTP: String) {
        var message = ""
        if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        DLog("\(OTP)")
        
        var sessionCheck = false
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: HomeViewController.self)) {
                sessionCheck = true
                
            }
        }
        let dictForAcceptedOTP = NSMutableDictionary()
        dictForAcceptedOTP[TXNNAME] = TXN_FORGOT_PIN
        dictForAcceptedOTP[SERVICE] = SERVICE_ACCOUNT
        dictForAcceptedOTP[INSTITUTION_ID] = SIMASPAY
        dictForAcceptedOTP[SOURCEMDN] = mdn
        dictForAcceptedOTP[SCTL_ID] = sctlID
        dictForAcceptedOTP[AUTH_KEY] = ""
        dictForAcceptedOTP[ACTIVATION_OTP] = simasPayRSAencryption(OTP)
        dictForAcceptedOTP[CHANGEPIN_NEWPIN] = simasPayRSAencryption(self.tfMpin.text!)
        dictForAcceptedOTP[CHANGEPIN_CONFIRMPIN] = simasPayRSAencryption(self.tfConfirmMpin.text!)

        
        DLog("\(dictForAcceptedOTP)")
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        SimasAPIManager .callAPI(withParameters: dictForAcceptedOTP as! [AnyHashable : Any], withSessionCheck:sessionCheck) { (dict, err) in
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
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                if (messagecode == "47"){
                    let vc = SuccesChangemPinController.initWithOwnNib()
                    let data = [
                        "title" : "mPin Berhasil Diubah",
                        "content" : [],
                        "footer" : [:]
                        ] as [String : Any]
                    
                    vc.data = data as NSDictionary!
                    vc.lblSuccesTransaction = "mPin Berhasil Diubah"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == "631") {
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    SimasAlertView.showNormalTitle("Error", message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        for vc in viewControllers {
                            if (vc.isKind(of: RegisterEMoneyViewController.self)) {
                                self.navigationController!.popToViewController(vc, animated: true);
                                return
                            } else if(vc.isKind(of: HomeViewController.self)) {
                                self.navigationController!.popToViewController(vc, animated: true);
                                return
                            }
                        }
                    }, cancelButtonTitle: "OK")
                }
                
                
            }
        }
        
    }
    
    
    
}
