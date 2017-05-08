//
//  TansferToUangkuController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 4/27/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//


import UIKit

class TansferToUangkuController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelMdn: BaseLabel!
    @IBOutlet weak var inputMdn: BaseTextField!
    @IBOutlet weak var LabelAmount: BaseLabel!
    @IBOutlet weak var inputAmount: BaseTextField!
    @IBOutlet weak var labelmPin: BaseLabel!
    @IBOutlet weak var inputmPin: BaseTextField!
    @IBOutlet weak var btnNext: BaseButton!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    static func initWithOwnNib() -> TansferToUangkuController {
        let obj:TansferToUangkuController = TansferToUangkuController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("TransferUangkuTitle"))
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        
        self.labelMdn.font = UIFont .boldSystemFont(ofSize: 13)
        self.labelMdn.text = getString("TransferLebelMdn")
        
        self.LabelAmount.font = self.labelMdn.font
        self.LabelAmount.text = getString("TransferLebelAmount")
        
        self.labelmPin.font = self.labelMdn.font
        self.labelmPin.text = getString("TransferLebelMPIN")
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        
        self.inputMdn.font = UIFont.systemFont(ofSize: 14)
        self.inputMdn.addInset()
        
        self.inputAmount.font = UIFont.systemFont(ofSize: 14)
        self.inputAmount.updateTextFieldWithLabelText("Rp.")
        
        self.inputmPin.font = UIFont.systemFont(ofSize: 14)
        self.inputmPin.addInset()
        self.inputmPin.delegate = self
        
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        self.constraintBottomScroll.constant = BaseViewController.keyboardSize.height
        self.view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        self.constraintBottomScroll.constant = 0
        self.view.layoutIfNeeded()
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 3 {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return true
        }
    }
    
    
    func nextProses() {
        
        let dict = NSMutableDictionary()
        if (DIMOAPIManager.sharedInstance().sourcePocketCode as String == "1") {
            dict[SERVICE] = SERVICE_WALLET
        } else {
            dict[SERVICE] = SERVICE_BANK
        }
        dict[TXNNAME] = TXN_INQUIRY_UANGKU
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.inputmPin.text!)
        dict[DESTACCOUNTNUMBER] = getNormalisedMDN(self.inputMdn.text! as NSString)
        dict[AMOUNT] = self.inputAmount.text
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[SOURCEPOCKETCODE] = DIMOAPIManager.sharedInstance().sourcePocketCode as String
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(param)")
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                if ( messagecode == SIMASPAY_INQUIRY_TRANSFER_SUCCESS_CODE ){
                    //Dictionary data for request OTP
                    let vc = ConfirmationViewController.initWithOwnNib()
                    let dictOtp = NSMutableDictionary()
                    dictOtp[TXNNAME] = TXN_RESEND_MFAOTP
                    dictOtp[SERVICE] = SERVICE_WALLET
                    dictOtp[INSTITUTION_ID] = SIMASPAY
                    dictOtp[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictOtp[SOURCEPIN] = simasPayRSAencryption(self.inputmPin.text!)
                    dictOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictOtp[AUTH_KEY] = ""
                    vc.dictForRequestOTP = dictOtp as NSDictionary
                    
                    let data: [String : Any]!
                    let creditamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "creditamt.text") as? String)!)
                    data = [
                        "title" : "Pastikan data berikut sudah benar",
                        "content" : [
                            [getString("ConfirmationOwnMdn") : responseDict.value(forKeyPath: "destinationName.text")],
                            [getString("TransferLebelMdn") : responseDict.value(forKeyPath: "destinationAccountNumber.text")],
                            [getString("TransferLebelAmount") : creditamt],
                        ]
                    ]
                    
                    vc.data = data! as NSDictionary
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                
                    let dictSendOtp = NSMutableDictionary()
                    if (DIMOAPIManager.sharedInstance().sourcePocketCode as String == "1") {
                        dictSendOtp[SERVICE] = SERVICE_WALLET
                    } else {
                        dictSendOtp[SERVICE] = SERVICE_BANK
                    }
                    dictSendOtp[TXNNAME] = TXN_TRANSFER_UANGKU
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[AUTH_KEY] = ""
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictSendOtp[SOURCEPOCKETCODE] = DIMOAPIManager.sharedInstance().sourcePocketCode as String
                    dictSendOtp[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    dictSendOtp[CONFIRMED] = "true"
                    dictSendOtp[MFAOTP] = true
                    
                    vc.dictForAcceptedOTP = dictSendOtp
                    self.navigationController?.pushViewController(vc, animated: false)
                } else if (messagecode == "631") {
                    DIMOAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    DIMOAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: action next
    @IBAction func actionProses(_ sender: Any) {
        var message = "";
        if (!inputMdn.isValid()) {
            message = "Harap Masukkan " + getString("TransferLebelMdn")  + " Anda"
        } else if (!inputAmount.isValid()){
            message = getString("TransferEmptyNominal")
        } else if (!inputmPin.isValid()){
            message = "Harap Masukkan " + getString("TransferLebelMPIN")  + " Anda"
        } else if (inputmPin.length() < 6) {
            message = "PIN harus 6 digit "
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        self.nextProses()
        
    }
    
    
}

