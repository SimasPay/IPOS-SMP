//
//  ActivationPinViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationPinViewController: BaseViewController, UITextFieldDelegate, UIAlertViewDelegate{
    
    @IBOutlet var lblInfoUser: BaseLabel!
    
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var tfConfirmMpin: BaseTextField!
    
    @IBOutlet var viewTextField: UIView!
    @IBOutlet var btnSaveMpin: BaseButton!
    
    var activationDict:NSDictionary!
    
    var timerCount = 60
    var clock:Timer!
    var lblTimer: BaseLabel!
    var btnResandOTP: BaseButton!
    var tfOTP: BaseTextField!
    
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPCancel), name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPOK), name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)

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
        } else if (!DIMOAPIManager.isInternetConnectionExist()){
          message = getString("LoginMessageNotConnectServer")
        }
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let mfaModeStatus = activationDict.value(forKeyPath:"mfaMode.text") as! String
        if (mfaModeStatus == "OTP") {
            self.showOTP()
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
        DIMOAPIManager.callAPI(withParameters: param, withSessionCheck:false) { (dict, err) in
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
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
            } else {
                DIMOAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
            }
 
            
        }

    }
    
    // MARK: OTP
    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()

    }
    
    func didOTPOK() {
        DLog("OK");
        clock.invalidate()
        confirmationRequest(otpText: (tfOTP.text as! NSString))
    }
    
    func showOTP()  {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 400))
        let messageAlert = UILabel(frame: CGRect(x: 10, y: 0, width: temp.frame.size.width, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = "Kode OTP dan link telah dikirimkan ke nomor 08881234567. Masukkan kode tersebut atau akses link yang tersedia."
        
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ActivationPinViewController.countDown), userInfo: nil, repeats: true)
        
        btnResandOTP = BaseButton(frame: CGRect(x: 10, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 3, width: temp.frame.size.width, height: 15))
        btnResandOTP.setTitle("Kirim Ulang", for: .normal)
        btnResandOTP.setTitleColor(UIColor.init(hexString: color_btn_alert), for: .normal)
        btnResandOTP.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btnResandOTP.titleLabel?.textAlignment = .center
        btnResandOTP.addTarget(self, action: #selector(ActivationPinViewController.resendOTP), for: .touchUpInside)
        btnResandOTP.isHidden = true
        
        lblTimer = BaseLabel(frame: CGRect(x: 10, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 3, width: temp.frame.size.width, height: 15))
        lblTimer.textAlignment = .center
        lblTimer.font = UIFont.systemFont(ofSize: 12)
        lblTimer.text = "01:00"
        
        
        tfOTP = BaseTextField(frame: CGRect(x: 10, y: lblTimer.frame.origin.y + lblTimer.frame.size.height + 3, width: temp.frame.size.width, height: 30))
        tfOTP.borderStyle = .line
        tfOTP.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        tfOTP.layer.borderWidth = 1;
        tfOTP.placeholder = "6 digit kode OTP"
        tfOTP.isSecureTextEntry = true
        tfOTP.addInset()
        
        temp.addSubview(btnResandOTP)
        temp.addSubview(lblTimer)
        temp.addSubview(messageAlert)
        temp.addSubview(tfOTP)
        
        showOTPWith(title: "Masukkan Kode OTP", view: temp)
    }
    func countDown(){
        if (timerCount > 0) {
            timerCount -= 1
            lblTimer.text = "00:\(timerCount)"
        } else {
            lblTimer.isHidden = true
            btnResandOTP.isHidden = false
        }
    }

    func resendOTP()  {
       if (!DIMOAPIManager.isInternetConnectionExist()){
        DIMOAlertView.showAlert(withTitle: "", message: getString("LoginMessageNotConnectServer"), cancelButtonTitle: getString("AlertCloseButtonText"))
        }
        
        let MDNString = activationDict.value(forKey: "MDN") as! String
        let activationSctlID = activationDict.value(forKey: "sctlID.text")
//        responseDict.valueForKeyPath("response.sctlID.text") as! String
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_WALLET
        dict[TXNNAME] = TXN_RESEND_MFAOTP
        dict[SOURCEMDN] = getNormalisedMDN(MDNString as NSString)
        dict[SOURCEPIN] = simasPayRSAencryption( tfMpin.text! as String)
        dict[SCTL_ID] = activationSctlID
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager.callAPI(withParameters: param) { (dict, err) in
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            let responseDict = dict != nil ? NSMutableDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            let messageCode = responseDict.value(forKey: "") as! String
            let messageText = responseDict.value(forKey: "") as! String
            if (messageCode == "608") {
                
            } else {
                DIMOAlertView.showAlert(withTitle: "", message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
            }

        }
    }
}
