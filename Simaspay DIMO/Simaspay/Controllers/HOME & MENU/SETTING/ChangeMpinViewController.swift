//
//  ChangeMpinViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/24/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ChangeMpinViewController: BaseViewController, UITextFieldDelegate {

    
    @IBOutlet var lblOldMpin: BaseLabel!
    @IBOutlet var lblNewMpin: BaseLabel!
    @IBOutlet var lblConfirmMpin: BaseLabel!
    @IBOutlet weak var tfOldMpin: BaseTextField!
    @IBOutlet weak var tfNewMpin: BaseTextField!
    @IBOutlet weak var tfConfirmMpin: BaseTextField!
    @IBOutlet var btnSaveMpin: BaseButton!
    
    
    static func initWithOwnNib() -> ChangeMpinViewController {
        let obj:ChangeMpinViewController = ChangeMpinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("ChangeMPINTitle"))
        self.showBackButton()
        
        btnSaveMpin.updateButtonType1()
        btnSaveMpin.setTitle(getString("ChangeMPINButtonSaveMpin"), for: .normal)
        
        lblOldMpin.font = UIFont.boldSystemFont(ofSize: 13)
        lblNewMpin.font = lblOldMpin.font
        lblConfirmMpin.font = lblOldMpin.font
        
        lblOldMpin.text = getString("ChangeMPINLebelOldMpin")
        lblNewMpin.text = getString("ChangeMPINLebelNewMpin")
        lblConfirmMpin.text = getString("ChangeMPINLebelConfirmNewMpin")
        
        tfNewMpin.addInset()
        tfOldMpin.addInset()
        tfConfirmMpin.addInset()
        
        tfNewMpin.delegate = self
        tfOldMpin.delegate = self
        tfConfirmMpin.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3){
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
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_INQUIRY_CHANGEMPIN
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(tfOldMpin.text!)
        dict[MFATRANSACTION] = INQUIRY
        dict[CHANGEPIN_NEWPIN] = simasPayRSAencryption(tfNewMpin.text!)
        dict[CHANGEPIN_CONFIRMPIN] = simasPayRSAencryption(tfConfirmMpin.text!)
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(param)")
        SimasAPIManager .callAPI(withParameters: param) { (dict, err) in
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
            
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                if ( messagecode == "2039" ){
                    //Dictionary data for request OTP
                    let vc = ConfirmationViewController.initWithOwnNib()
                    let dictOtp = NSMutableDictionary()
                    dictOtp[TXNNAME] = TXN_RESEND_MFAOTP
                    dictOtp[SERVICE] = SERVICE_WALLET
                    dictOtp[INSTITUTION_ID] = SIMASPAY
                    dictOtp[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictOtp[SOURCEPIN] = simasPayRSAencryption(self.tfOldMpin.text!)
                    dictOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictOtp[AUTH_KEY] = ""
                    vc.dictForRequestOTP = dictOtp as NSDictionary

                    vc.ismPinChange = true
                    
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    let dictSendOtp = NSMutableDictionary()
                    dictSendOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictSendOtp[TXNNAME] = TXN_INQUIRY_CHANGEMPIN
                    dictSendOtp[SERVICE] = SERVICE_ACCOUNT
                    dictSendOtp[SOURCEPIN] = simasPayRSAencryption(self.tfOldMpin.text!)
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[CHANGEPIN_NEWPIN] = simasPayRSAencryption(self.tfNewMpin.text!)
                    dictSendOtp[MFATRANSACTION] = "Confirm"
                    dictSendOtp[CHANGEPIN_CONFIRMPIN] = simasPayRSAencryption(self.tfConfirmMpin.text!)
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictSendOtp[MFAOTP] = true
                    
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.lblSuccesTransaction = "mPin Berhasil Diubah"
                    self.navigationController?.pushViewController(vc, animated: false)
                } else if (messagecode == "631") {
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
            }
        }
        
    }
    
    //MARK: Action button
    @IBAction func actionBtnSave(_ sender: AnyObject) {
        
        var message = "";
        if (!tfOldMpin.isValid()) {
            message = "Harap masukkan mPIN lama Anda."
        } else if (tfOldMpin.length() < 6) {
            message = "mPIN lama harus 6 digit."
        } else if(!tfNewMpin.isValid()){
            message = "Harap masukkan mPIN baru Anda."
        } else if (tfNewMpin.length() < 6) {
            message = "mPIN baru harus 6 digit."
        } else if (tfNewMpin.text == tfOldMpin.text){
            message = "mPIN lama dan PIN baru tidak boleh sama."
        } else if (!tfConfirmMpin.isValid()){
            message = "Harap masukkan konfirmasi mPIN baru Anda."
        } else if (tfOldMpin.length() < 6) {
            message = "Konfirmasi mPIN harus 6 digit."
        } else if (tfNewMpin.text != tfConfirmMpin.text){
            message = "mPIN dan konfirmasi mPIN baru yang Anda masukkan harus sama."
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }

        
        self.nextProses()
    }


}
