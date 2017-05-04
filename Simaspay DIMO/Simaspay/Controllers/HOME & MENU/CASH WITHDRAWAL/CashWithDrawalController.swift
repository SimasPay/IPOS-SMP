//
//  CashWithDrawalController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/1/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

//MARK: Transfer type
enum WithDrawalType : Int {
    case WithDrawalTypeMe
    case WithDrawalTypeOther
}

class CashWithDrawalController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var lblFirstTitleTf: BaseLabel!
    @IBOutlet var lblSecondTitleTf: BaseLabel!
    @IBOutlet var lblMPin: BaseLabel!
    @IBOutlet weak var lblMinimumAmount: BaseLabel!
    
    @IBOutlet var tfNoAccount: BaseTextField!
    @IBOutlet var tfAmountTransfer: BaseTextField!
    @IBOutlet weak var textFieldmPin: BaseTextField!
    
    var withDrawalType : WithDrawalType!
    
    @IBOutlet var btnNext: BaseButton!
    
    @IBOutlet var constraintViewAcount: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintScrollViewHeight: NSLayoutConstraint!
    static var scrollViewHeight : CGFloat = 0
    
    
    static func initWithOwnNib(type : WithDrawalType) -> CashWithDrawalController {
        let obj:CashWithDrawalController = CashWithDrawalController.init(nibName: String(describing: self), bundle: nil)
        obj.withDrawalType = type
        return obj
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        
        self.lblFirstTitleTf.font = UIFont .boldSystemFont(ofSize: 13)
        self.lblFirstTitleTf.text = getString("TransferLebelMdn")
        
        self.lblSecondTitleTf.font = self.lblFirstTitleTf.font
        self.lblSecondTitleTf.text = getString("TransferLebelAmount")
        
        self.lblMPin.font = self.lblFirstTitleTf.font
        self.lblMPin.text = getString("TransferLebelMPIN")
        
        self.lblMinimumAmount.font = UIFont .boldSystemFont(ofSize: 12)
        self.lblMinimumAmount.text = getString("WithDrawalAmountMinimal")
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        btnNext.addTarget(self, action: #selector(self.actionNext) , for: .touchUpInside)
        
        self.tfNoAccount.font = UIFont.systemFont(ofSize: 14)
        self.tfNoAccount.addInset()
        self.tfNoAccount.delegate = self
        
        self.textFieldmPin.font = UIFont.systemFont(ofSize: 14)
        self.textFieldmPin.addInset()
        self.textFieldmPin.delegate = self
        
        self.tfAmountTransfer.font = UIFont.systemFont(ofSize: 14)
        self.tfAmountTransfer.placeholder = "Rp"
        self.tfAmountTransfer.addInset()
        self.tfAmountTransfer.delegate = self
        
        
        if (self.withDrawalType == WithDrawalType.WithDrawalTypeMe) {
            constraintViewAcount.constant = 0
            self.showTitle(getString("WithDrawalMe"))
        } else {
            self.showTitle(getString("WithDrawalOther"))
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionNext() {
        var intValue : Int?
        if (tfAmountTransfer.isValid()) {
            var anOptionalString : String?
            anOptionalString = tfAmountTransfer.text
            intValue = Int(anOptionalString!)
        } else {
            intValue = 0
        }
        
        var message = "";
        if (self.withDrawalType != WithDrawalType.WithDrawalTypeMe && !tfNoAccount.isValid()) {
            message = "Masukan " + getString("TransferLebelMdn")
        } else if (!tfAmountTransfer.isValid()){
            message = "Masukan " + getString("TransferLebelAmount")
        } else if (tfAmountTransfer.isValid() && intValue! < 100000) {
            message = getString("WithDrawalAmountMinimalMessage")
        } else if (tfAmountTransfer.isValid() && intValue! % 50000 != 0) {
             message = getString("WithDrawalAmountMinimalMessage")
        } else if (!textFieldmPin.isValid()){
            message = "Masukan " + getString("TransferLebelMPIN")
        } else if (textFieldmPin.length() < 6) {
            message = "PIN harus 6 digit "
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        nextProces()
    }
    
    //MARK: function comfirmation
    func nextProces()  {
        let dict = NSMutableDictionary()
        
        if (self.withDrawalType == WithDrawalType.WithDrawalTypeOther) {
             dict[BEHALF_OF_MDN] = getNormalisedMDN(self.tfNoAccount.text! as NSString)
        }
        
        dict[SERVICE] = SERVICE_WALLET
        dict[TXNNAME] = TXN_CASHWITHDRAWAL
        dict[INSTITUTION_ID] = SIMASPAY
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.textFieldmPin.text!)
        dict[AMOUNT] = self.tfAmountTransfer.text
        
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
                if ( messagecode == SIMASPAY_INQUIRY_CASH_WITH_DRAWAL ){
                    //Dictionary data for request OTP
                    let vc = ConfirmationViewController.initWithOwnNib()
                    let dictOtp = NSMutableDictionary()
                    dictOtp[TXNNAME] = TXN_RESEND_MFAOTP
                    dictOtp[SERVICE] = SERVICE_WALLET
                    dictOtp[INSTITUTION_ID] = SIMASPAY
                    dictOtp[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictOtp[SOURCEPIN] = simasPayRSAencryption(self.textFieldmPin.text!)
                    dictOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictOtp[AUTH_KEY] = ""
                    vc.dictForRequestOTP = dictOtp as NSDictionary
                    
                    let data: [String : Any]!
                    let creditamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "creditamt.text") as? String)!)
                    if (self.withDrawalType == WithDrawalType.WithDrawalTypeMe) {
                        data = [
                            "title" : "Pastikan data berikut sudah benar",
                            "content" : [
                                [getString("TypeOfTransaction") : getString("WithDrawalMe")],
                                [getString("TransferLebelAmount") : creditamt],
                            ]
                        ]
                    } else {
                        data = [
                            "title" : "Pastikan data berikut sudah benar",
                            "content" : [
                                [getString("TypeOfTransaction") : getString("WithDrawalOther")],
                                [getString("TransferLebelMdn") : self.tfNoAccount.text!],
                                [getString("TransferLebelAmount") : creditamt],
                            ]
                        ]
                    }
                    
                    vc.data = data! as NSDictionary
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    let dictSendOtp = NSMutableDictionary()
                    dictSendOtp[SERVICE] = SERVICE_WALLET
                    dictSendOtp[TXNNAME] = TXN_CASH_OUT_ATM_WITHDRAWAL
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
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
    
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        TransferBankViewController.scrollViewHeight = constraintScrollViewHeight.constant
        constraintScrollViewHeight.constant = TransferBankViewController.scrollViewHeight - BaseViewController.keyboardSize.height
        self.view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        constraintScrollViewHeight.constant = TransferBankViewController.scrollViewHeight
        self.view.layoutIfNeeded()
    }
    
    
}
