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
    
    static func initWithOwnNib() -> ActivationPinViewController {
        let obj:ActivationPinViewController = ActivationPinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = "Bayu !"
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
    @IBAction func actionSaveMpin(_ sender: AnyObject) {
        let vc = ActivationSuccessViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
        self.submitMpin()
    }
    func submitMpin () {
        
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
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }
        
        let mfaModeStatus = activationDict.value(forKeyPath:"mfaMode.text") as! String
        if (mfaModeStatus == "OTP") {
            self.showOTPAlert()
        } else {
            self.confirmationRequest(otpText: "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        BaseViewController.lastObjectForKeyboardDetector = self.btnSaveMpin
        updateUIWhenKeyboardShow()
        return true
    }
    
    func confirmationRequest(otpText:String) {
        
        let activationSourceMDN = activationDict.value(forKeyPath:"mfaMode.text") as! String
        let activationInquerySctlId = activationDict.value(forKeyPath:"mfaMode.text") as! String
        let activationInqueryOTP = activationDict.value(forKeyPath:"mfaMode.text") as! String
//        let activationInqueryOTP = activationDict.value(forKeyPath:"mfaMode.text") as! String
        var dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_INQUIRY_ACTIVATION
        dict[SERVICE] = SERVICE_ACCOUNT
//        dict[SOURCEMDN] = SimaspayUtility.getNormalisedMDN(activationSourceMDN)
//        dict[ACTIVATION_NEWPIN] = SimaspayUtility.simasPayRSAencryption(mPINTextField.text!)
//        dict[ACTIVATION_CONFORMPIN] = SimaspayUtility.simasPayRSAencryption(confirmasimPINTextField.text!)
//        if(otpText.length > 0)
//        {
//            dict[MFAOTP] = SimaspayUtility.simasPayRSAencryption(otpText)
//        }
//        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
//        dict[PARENTTXNID] = activationInquerySctlId
//        dict[ACTIVATION_OTP] = activationInqueryOTP

    }
    
    // MARK: OTP
    func didOTPCancel() {
        DLog("cancel");
    }
    
    func didOTPOK() {
        DLog("OK");
    }
    
    func showOTP()  {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 100))
        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 30, height: 30))
        button.setTitle("title", for: .normal)
        button.addTarget(self, action: #selector(ActivationPinViewController.trybutton) , for: .touchUpInside)
        
        let textfield = UITextField(frame: CGRect(x: 20, y: 50, width: temp.bounds.size.width - (2 * 40) , height: 30))
        textfield.placeholder = "Input"
        
        temp.addSubview(textfield)
        temp.addSubview(button)
        showOTPWith(view: temp)
    }
    
    func trybutton()  {
        DLog("try it")
    }
}
