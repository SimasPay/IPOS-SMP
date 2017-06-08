//
//  ActivationViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationViewController: BaseViewController, UIAlertViewDelegate, UITextFieldDelegate {
    @IBOutlet var lblInfoActivation: BaseLabel!
    @IBOutlet var viewTextField: UIView!
 
    @IBOutlet var lblQuestionLogin: BaseLabel!
    @IBOutlet var tfActivationCode: BaseTextField!
    @IBOutlet var tfHpNumber: BaseTextField!
    
    @IBOutlet var btnNext: BaseButton!
    @IBOutlet var btnLogin: UIButton!
    
    var tfOTP: BaseTextField!
    
    //Timer for OTP resend button
    var timerCount = 120
    var clock:Timer!
    var lblTimer: BaseLabel!
    var alertController = UIAlertController()
    var otpString:String! = ""
    var vc = ActivationPinViewController.initWithOwnNib()
    
    static func initWithOwnNib() -> ActivationViewController {
        let obj:ActivationViewController = ActivationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfHpNumber.delegate = self
        tfActivationCode.delegate = self
        
        lblInfoActivation.text = getString("ActivationLabelInfo")
        lblInfoActivation.textAlignment = .center
        lblInfoActivation.numberOfLines = 3
        
        viewTextField.backgroundColor = UIColor.white
        viewTextField.updateViewRoundedWithShadow()
        tfHpNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHpNumber.placeholder = getString("LoginPlaceholderNoHandphone")
        tfActivationCode.updateTextFieldWithImageNamed("icon_Otp")
        tfActivationCode.placeholder = getString("ActivationPlaceholderOTP")
        tfHpNumber.autocorrectionType = .no
        tfActivationCode.autocorrectionType = .no
        
        lblQuestionLogin.text = getString("ActivationQuestionForLogin")
        lblQuestionLogin.font = UIFont.systemFont(ofSize: 16)
        lblQuestionLogin.textAlignment = .right
        
        btnLogin.setTitle(getString("LoginButtonLogin"), for: UIControlState())
        btnLogin.setTitleColor(UIColor.init(hexString: color_text_default), for: UIControlState())
        btnLogin.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("ActivationButtonNext"), for: UIControlState())
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tfHpNumber.addUnderline()
        let line = CALayer()
        line.frame = CGRect(x: 0, y: self.btnLogin.bounds.size.height - 10 , width: self.btnLogin.frame.size.width, height: 1)
        line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
        btnLogin.layer.addSublayer(line)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didOTPCancel), name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didOTPOK), name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: action resend OTP Button
    @IBAction func actionResendOTP(_ sender: AnyObject) {
        // self.resendOTP()
    }
    
    //MARK: action action Next button
    @IBAction func actionNextButton(_ sender: AnyObject) {
        self.activation()
    }
    
   
    
    //MARK Action button login
    @IBAction func actionBackLogin(_ sender: AnyObject) {
        let vc = LoginRegisterViewController.initWithOwnNib()
        self.navigationController!.pushViewController(vc, animated: true);
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var maxLength = 4
        if (tfHpNumber == textField) {
            maxLength = 15
        } else if (textField.tag == 10){
            maxLength = 4
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if (textField.tag == 10) {
            self.otpString = newString as String!
        }
        return newString.length <= maxLength
    }
    
    //MARK: keyboard Show set last object above keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfHpNumber{
            // BaseViewController.lastObjectForKeyboardDetector = self.btnResendOTP.superview
        } else {
            BaseViewController.lastObjectForKeyboardDetector = self.btnNext
        }
        updateUIWhenKeyboardShow()
        return true
    }
    
    //MARK: Actiovation
    func activation() {
        var message = "";
        if (!tfHpNumber.isValid()) {
            message = getString("ActivationMessageFillHpNumber")
        } else if (tfHpNumber.length() < 10 || tfHpNumber.length() > 15) {
            message = "Nomor handphone yang Anda masukkan harus 10-14 angka."
        } else if (!tfActivationCode.isValid()) {
            message = getString("ActivationMessageFillActivation")
        } else if (tfActivationCode.length() < 4) {
            message = getString("ActivationMessageSixActivation")
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_INQUIRY_ACTIVATION
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN(self.tfHpNumber.text! as NSString)
        dict[ACTIVATION_OTP] =  simasPayRSAencryption(tfActivationCode.text!)
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        dict[MFATRANSACTION] = INQUIRY
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        SimasAPIManager.callAPI(withParameters: param, withSessionCheck:false) { (dict, err) in
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
            
            let responseDict = dict != nil ? NSMutableDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            let messagecode  = responseDict.value(forKeyPath:"message.code") as! String
            let messageText  = responseDict.value(forKeyPath:"message.text") as! String
            if messagecode == SIMASPAY_ACTIVATION__INQUERY_SUCCESS_CODE {
                responseDict ["MDN"] = getNormalisedMDN(self.tfHpNumber.text! as NSString ) as String!
                responseDict ["ActivationCode"] = simasPayRSAencryption(self.tfActivationCode.text!)
                self.vc.activationDict = responseDict
                self.showOTP()
            } else {
                SimasAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
            }
        }
    }
    
    //MARK: resend OTP
    func resendOTP() {
        
        if (!tfHpNumber.isValid()) {
            SimasAlertView.showAlert(withTitle: "", message: getString("LoginMessageFillHpNumber"), cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_RESENDOTP
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN(self.tfHpNumber.text! as NSString)
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        SimasAPIManager.callAPI(withParameters: param) { (dict, err) in
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
            
            let messageText  = responseDict.value(forKeyPath: "message.text") as! String
            if((responseDict.object(forKey: "OneTimePin")) != nil)
            {
                SimasAlertView.showAlert(withTitle: getString("ActivationAlertTitleResendOTP"), message: getString("ActivationAlertResendOTP"), cancelButtonTitle: getString("AlertCloseButtonText"))
            }else{
                SimasAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
            }
            
        }
        
    }
    
    func createNewPin() {
        vc.otp = self.otpString
        self.animatedFadeIn()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    //MARK: Action button for OTP alert
    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()
        
    }
    
    func didOTPOK() {
        DLog("OK");
        clock.invalidate()
        self.createNewPin()
    }
    
    //MARK: Count down timer
    func countDown(){
        if (timerCount > 0) {
            timerCount -= 1
            if (timerCount == 60) {
                lblTimer.text = "01:00"
            } else if (timerCount < 60) {
                lblTimer.text = "00:\(timerCount)"
            } else if (timerCount > 60) {
                var temp = timerCount
                temp = temp - 60
                lblTimer.text = "01:\(temp)"
            }
        } else {
            self.alertController.dismiss(animated: true, completion: {
                SimasAlertView.showAlert(withTitle: getString("titleEndOtp"), message: getString("messageEndOtp"), cancelButtonTitle: getString("AlertCloseButtonText"))
            })
            clock.invalidate()
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
    
    
    //MARK: Show OTP Alert
    func showOTP()  {
        timerCount = 120
        alertController = UIAlertController(title: getString("ConfirmationOTPMessageTitle") + "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let temp = UIView(frame: CGRect(x: 0, y: 40, width: 270, height: 100))
        let messageString = String(format: "Kode OTP dan link telah dikirimkan ke nomor %@. Masukkan kode tersebut atau akses link yang tersedia.", self.tfHpNumber.text!)
        let messageAlert = UILabel(frame: CGRect(x: 10, y: 10, width: temp.frame.size.width - 20, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = messageString as String
        
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        lblTimer = BaseLabel(frame: CGRect(x: 0, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 10, width: temp.frame.size.width, height: 15))
        lblTimer.textAlignment = .center
        lblTimer.font = UIFont.systemFont(ofSize: 12)
        lblTimer.text = "02:00"
        
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
    }
    
    
    
}
