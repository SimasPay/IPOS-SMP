//
//  TransferBankViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/3/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

//MARK: Transfer type
enum TransferType : Int {
    case TransferTypeSinarmas
    case TransferTypeOtherBank
    case TransferTypeUangku
    case TransferTypeLakuPandai
    case TransferTypeOther
}

class TransferBankViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var lblBankName: BaseLabel!
    @IBOutlet var lblFirstTitleTf: BaseLabel!
    @IBOutlet var lblSecondTitleTf: BaseLabel!
    @IBOutlet var lblMPin: BaseLabel!
    
    @IBOutlet var tfBankName: BaseTextField!
    @IBOutlet var tfNoAccount: BaseTextField!
    @IBOutlet var tfAmountTransfer: BaseTextField!
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var viewBackground: UIView!
    
    var transferType : TransferType!
    var bankName : NSDictionary!
    
    @IBOutlet var btnNext: BaseButton!
    
    @IBOutlet var constraintViewBankName: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    var arrayFavlist = [String]()
    var arrayValue = [String]()
    var isAviableFavList: Bool = false
    
    @IBOutlet weak var radioBtnFav: BaseButton!
    @IBOutlet weak var radioBtnManual: BaseButton!
    @IBOutlet var tfFavList: BaseTextField!
    @IBOutlet weak var constraintHeightManual: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightBtnFavList: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightFavlist: NSLayoutConstraint!
    let pickerView = UIPickerView()
    
    static func initWithOwnNib(type : TransferType) -> TransferBankViewController {
        let obj:TransferBankViewController = TransferBankViewController.init(nibName: String(describing: self), bundle: nil)
        obj.transferType = type
        return obj
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        
        self.lblBankName.font = UIFont .boldSystemFont(ofSize: 13)
        self.lblBankName.text = getString("TransferLebelBankName")
        
        
        self.lblFirstTitleTf.font = self.lblBankName.font
        self.lblFirstTitleTf.text = getString("TransferLebelAccountNumber")
        
        self.lblSecondTitleTf.font = self.lblBankName.font
        self.lblSecondTitleTf.text = getString("TransferLebelAmount")
        
        self.lblMPin.font = self.lblBankName.font
        self.lblMPin.text = getString("TransferLebelMPIN")
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        btnNext.addTarget(self, action: #selector(TransferBankViewController.actionNext) , for: .touchUpInside)
        
        self.tfBankName.font = UIFont.systemFont(ofSize: 14)
        self.tfBankName.isUserInteractionEnabled = true
        self.tfBankName.isEnabled = false
        self.tfBankName.addInset()
        
        self.tfNoAccount.font = UIFont.systemFont(ofSize: 14)
        self.tfNoAccount.addInset()
        self.tfNoAccount.delegate = self
        
        self.tfAmountTransfer.font = UIFont.systemFont(ofSize: 14)
        self.tfAmountTransfer.updateTextFieldWithLabelText("Rp.")
        
        self.tfMpin.font = UIFont.systemFont(ofSize: 14)
        self.tfMpin.addInset()
        self.tfMpin.delegate = self
        
        if (self.transferType != TransferType.TransferTypeOtherBank) {
            constraintViewBankName.constant = 0
            self.tfBankName.isUserInteractionEnabled = false
            self.showTitle(getString("TransferBSIMTitle"))
        } else {
            self.tfBankName.isUserInteractionEnabled = true
            self.tfBankName.text = bankName.value(forKey: "name") as? String
            self.showTitle(getString("TransferOtherBankTitle"))
        }
        
        radioBtnFav.updateToRadioButtonWith(_titleButton: "Dari Daftar Favorit")
        radioBtnManual.updateToRadioButtonWith(_titleButton: "Ketik Manual")
        
        self.radioBtnManual.isSelected = true
        self.radioBtnFav.isSelected = false
        self.constraintHeightBtnFavList.constant = 0
        self.constraintHeightFavlist.constant = 0
        self.constraintHeightManual.constant = 40
        self.tfFavList.addInset()
        self.tfFavList.rightViewMode =  UITextFieldViewMode.always
        self.tfFavList.updateTextFieldWithRightImageNamed("icon_arrow_down")
        self.tfFavList.forPicker()
        self.tfNoAccount.isUserInteractionEnabled = true
        self.tfFavList.isUserInteractionEnabled = false
        pickerView.delegate = self
        self.tfFavList.inputView = pickerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if arrayFavlist.count == 0 {
            if (self.transferType != TransferType.TransferTypeOtherBank) {
                self.getFavListBSIM()
            } else {
                self.getFavListOther()
            }
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
        } else if textField.tag == 1 {
            if self.transferType == TransferType.TransferTypeSinarmas {
                let maxLength = 16
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            } else {
                let maxLength = 25
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
           
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 && self.arrayValue.count > 0 {
            if self.arrayValue.contains(textField.text!) {
                isAviableFavList = true
                SimasAlertView.showAlert(withTitle: "", message: "Nomor sudah terdaftar di favorit list", cancelButtonTitle: getString("AlertCloseButtonText"))
            }
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionNext() {
        var message = "";
        if (!tfNoAccount.isValid()) {
            message = "Silakan Masukkan " + getString("TransferLebelAccountNumber") + " Anda"
        } else if (self.transferType == TransferType.TransferTypeSinarmas && tfNoAccount.length() < 10) {
            message = "Nomor rekening Bank Tujuan yang Anda masukkan harus 10-16 angka."
        } else if (tfNoAccount.length() < 8) {
            message = "Nomor rekening Bank Tujuan yang Anda masukkan harus 8-25 angka."
        } else if (self.radioBtnManual.isSelected && self.isAviableFavList){
            message = "Nomor sudah terdaftar di favorit list"
        } else if (!tfAmountTransfer.isValid()){
            message = getString("TransferEmptyNominal")
        } else if (!tfMpin.isValid()){
            message = "Harap Masukkan " + getString("TransferLebelMPIN") + " Anda"
        } else if (tfMpin.length() < 6) {
            message = "PIN harus 6 digit "
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        if (self.transferType == TransferType.TransferTypeSinarmas) {
            self.confirmationToBSIM()
        } else {
            self.confirmationToOther()
        }
    }
    
    //MARK: function comfirmation
    func confirmationToBSIM()  {
        
        let dict = NSMutableDictionary()
        if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
            dict[SERVICE] = SERVICE_WALLET
        } else {
            dict[SERVICE] = SERVICE_BANK
        }
        dict[TXNNAME] = TXN_TRANSFER_INQUIRY
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
        dict[DESTMDN] = ""
        dict[DESTBANKACCOUNT] = self.tfNoAccount.text
        dict[AMOUNT] = self.tfAmountTransfer.text
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[BANK_ID] = ""
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        dict[DESTPOCKETCODE] = ACCOUNTTYPEREGULER
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
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
                if ( messagecode == SIMASPAY_INQUIRY_TRANSFER_SUCCESS_CODE ){
                    //Dictionary data for request OTP
                    let vc = ConfirmationViewController.initWithOwnNib()
                    let dictOtp = NSMutableDictionary()
                    dictOtp[TXNNAME] = TXN_RESEND_MFAOTP
                    dictOtp[SERVICE] = SERVICE_WALLET
                    dictOtp[INSTITUTION_ID] = SIMASPAY
                    dictOtp[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictOtp[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
                    dictOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictOtp[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
                    dictOtp[AUTH_KEY] = ""
                    vc.dictForRequestOTP = dictOtp as NSDictionary
                    
                    let dictSendOtp = NSMutableDictionary()
                    let data: [String : Any]!
                    
                    let strName = responseDict.value(forKeyPath: "destinationName.text") as! String
                    
                        let credit = String(format: "Rp %@", (responseDict.value(forKeyPath: "creditamt.text") as? String)!)
                        data = [
                            "title" : "Pastikan data berikut sudah benar",
                            "content" : [
                                [getString("ConfirmationOwnMdn") :  strName.capitalized ],
                                [getString("TransferLebelBankName") :  responseDict.value(forKeyPath: "destinationBank.text") as! String],
                                [getString("TransferLebelAccountNumber") : responseDict.value(forKeyPath: "destinationAccountNumber.text") as! String],
                                [getString("TransferLebelAmount") : credit],
                            ]
                        ]
                        vc.data = data as NSDictionary!
                        dictSendOtp[BANK_ID] = ""
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
                        dictSendOtp[SERVICE] = SERVICE_WALLET
                    } else {
                        dictSendOtp[SERVICE] = SERVICE_BANK
                    }
                    dictSendOtp[TXNNAME] = TRANSFER
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[AUTH_KEY] = ""
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[DESTMDN] = ""
                    dictSendOtp[DESTBANKACCOUNT] = self.tfNoAccount.text
                    dictSendOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictSendOtp[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
                    dictSendOtp[DESTPOCKETCODE] = ACCOUNTTYPEREGULER
                    dictSendOtp[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    dictSendOtp[CONFIRMED] = "true"
                    dictSendOtp[MFAOTP] = true
                    
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.lblSuccesTransaction = getString("SuccesTransfer")
                    if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
                        vc.value = self.tfNoAccount.text
                        vc.favoriteCategoryID = "11"
                        vc.mPin = self.tfMpin.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                    } else {
                        vc.value = self.tfNoAccount.text
                        vc.favoriteCategoryID = "1"
                        vc.mPin = self.tfMpin.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                    }
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
    
    //MARK: function comfirmation otherBank
    func confirmationToOther()  {
        
        let dict = NSMutableDictionary()
        if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
            dict[SERVICE] = SERVICE_WALLET
        } else {
            dict[SERVICE] = SERVICE_BANK
        }
        dict[TXNNAME] = TXN_INQUIRY_OTHERBANK
        dict[MFATRANSACTION] = INQUIRY
        dict[INSTITUTION_ID] = SIMASPAY
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
        dict[DESTACCOUNTNUMBER] = self.tfNoAccount.text
        dict[AMOUNT] = self.tfAmountTransfer.text
        dict[DEST_BANK_CODE] = self.bankName.value(forKey: "code") as? String
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        dict[DESTPOCKETCODE] = ACCOUNTTYPEREGULER
        dict[BANK_ID] = ""
        dict[ACCOUNT_TYPE] = ""
        
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
                if ( messagecode == SIMASPAY_INQUIRY_TRANSFER_SUCCESS_CODE ){
                    //Dictionary data for request OTP
                    let vc = ConfirmationViewController.initWithOwnNib()
                    let dictOtp = NSMutableDictionary()
                    dictOtp[TXNNAME] = TXN_RESEND_MFAOTP
                    dictOtp[SERVICE] = SERVICE_WALLET
                    dictOtp[INSTITUTION_ID] = SIMASPAY
                    dictOtp[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictOtp[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
                    dictOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictOtp[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
                    dictOtp[AUTH_KEY] = ""
                    vc.dictForRequestOTP = dictOtp as NSDictionary
                    
                    let dictSendOtp = NSMutableDictionary()
                    let data: [String : Any]!
                    
                    let chargerString = (responseDict.value(forKeyPath: "charges.text") as? String)!
                    let creditamt = (responseDict.value(forKeyPath: "creditamt.text") as? String)!
                    let chargerInt = Int(chargerString.replacingOccurrences(of: ".", with: "", options: .literal, range: nil))
                    let creditInt = Int(creditamt.replacingOccurrences(of: ".", with: "", options: .literal, range: nil))
                    let debit = chargerInt! + creditInt!
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .currency
                    formatter.locale = Locale(identifier: "id_ID")
                    let result = formatter.string(from: debit as NSNumber);
                    data = [
                        "title" : "Pastikan data berikut sudah benar",
                        "content" : [
                            [getString("ConfirmationOwnMdn") : responseDict.value(forKeyPath: "destinationName.text")],
                            [getString("TransferLebelBankName") : responseDict.value(forKeyPath: "destinationBank.text")],
                            [getString("TransferLebelAccountNumber") : responseDict.value(forKeyPath: "destinationAccountNumber.text")],
                            [getString("TransferLebelAmount") : String(format: "Rp %@", creditamt)],
                            [getString("TransferFee") :  String(format: "Rp %@", chargerString)],
                        ],
                        "footer" :[
                            getString("TotalDebit") : result?.replacingOccurrences(of: "Rp", with: "Rp ", options: .literal, range: nil)]
                    ]
                    vc.data = data as NSDictionary!
                    
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
                        dictSendOtp[SERVICE] = SERVICE_WALLET
                    } else {
                        dictSendOtp[SERVICE] = SERVICE_BANK
                    }
                    dictSendOtp[TXNNAME] = TXN_OTHERBANK
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[DESTACCOUNTNUMBER] = self.tfNoAccount.text
                    dictSendOtp[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
                    dictSendOtp[DESTPOCKETCODE] = ACCOUNTTYPEREGULER
                    dictSendOtp[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    dictSendOtp[CONFIRMED] = "true"
                    dictSendOtp[DEST_BANK_CODE] = self.bankName.value(forKey: "code") as? String
                    dictSendOtp[BANK_ID] = ""
                    dictSendOtp[ACCOUNT_TYPE] = ""
                    dictSendOtp[MFATRANSACTION] = "Confirm"
                    dictSendOtp["mspID"] = "1"
                    dictSendOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictSendOtp[MFAOTP] = true
                    if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
                        vc.value = self.tfNoAccount.text
                        vc.favoriteCategoryID = "10"
                        vc.mPin = self.tfMpin.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                    } else {
                        vc.value = self.tfNoAccount.text
                        vc.favoriteCategoryID = "4"
                        vc.mPin = self.tfMpin.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                    }

                    vc.dictForAcceptedOTP = dictSendOtp
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

    func getFavListBSIM() {
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_FAVORITE_JSON
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
        
        if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
            dict[FAVORITE_CATEGORY_ID] = "11"
        } else {
            dict[FAVORITE_CATEGORY_ID] = "1"
        }
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
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
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            //            DLog("\(responseDict)")
            if (responseDict.allKeys.count == 0) {
//                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                // success
                
                if (responseDict.value(forKeyPath: "message.code") != nil){
                    let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                    let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                    if (messagecode == "631") {
                        SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                            if index == 0 {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                            }
                        }, cancelButtonTitle: "OK")
                    } else {
                        SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                    }
                    
                } else {
                    // DLog("\(responseDict)")
                    for dataDict in responseDict.allValues {
                        let data = dataDict as! NSDictionary
                        let val = data.value(forKey: "favoriteValue") as! String
                        let favoriteLabel = data.value(forKey: "favoriteLabel") as! String
                        self.arrayValue.append(val)
                        self.arrayFavlist.append(favoriteLabel + " - " + val)
                    }
                    // DLog("\(self.arrayFavlist)")
                }
            }
        }
    }

    func getFavListOther() {
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_FAVORITE_JSON
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
        
        if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
            dict[FAVORITE_CATEGORY_ID] = "10"
        } else {
            dict[FAVORITE_CATEGORY_ID] = "4"
        }
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
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
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            //            DLog("\(responseDict)")
            if (responseDict.allKeys.count == 0) {
//                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                // success
                
                if (responseDict.value(forKeyPath: "message.code") != nil){
                    let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                    let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                    if (messagecode == "631") {
                        SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                            if index == 0 {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                            }
                        }, cancelButtonTitle: "OK")
                    } else {
                        SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                    }
                    
                } else {
                    // DLog("\(responseDict)")
                    for dataDict in responseDict.allValues {
                        let data = dataDict as! NSDictionary
                        let val = data.value(forKey: "favoriteValue") as! String
                        let favoriteLabel = data.value(forKey: "favoriteLabel") as! String
                        self.arrayValue.append(val)
                        self.arrayFavlist.append(favoriteLabel + " - " + val)
                    }
                    // DLog("\(self.arrayFavlist)")
                }
            }
        }
    }
    
    //MARK: PickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = self.arrayFavlist[row]
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.arrayFavlist.count
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.arrayFavlist[row]
    }
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if self.arrayFavlist.count > 0 {
            self.tfFavList.text = self.arrayFavlist[row]
            self.tfNoAccount.text = self.arrayValue[row]
        }
    }
    
    @IBAction func actionRadio(_ sender: Any) {
        self.tfFavList.text=""
        self.tfNoAccount.text=""
        if self.radioBtnFav.isSelected {
            self.radioBtnManual.isSelected = true
            self.radioBtnFav.isSelected = false
            self.constraintHeightBtnFavList.constant = 0
            self.constraintHeightFavlist.constant = 0
            self.constraintHeightManual.constant = 40
            self.tfNoAccount.isUserInteractionEnabled = true
            self.tfFavList.isUserInteractionEnabled = false
        } else {
            if (self.arrayFavlist.count == 0) {
                SimasAlertView.showAlert(withTitle: "", message: "Daftar Favorit tidak tersedia", cancelButtonTitle: getString("AlertCloseButtonText"))
                return
            }
            self.radioBtnManual.isSelected = false
            self.radioBtnFav.isSelected = true
            self.constraintHeightBtnFavList.constant = 40
            self.constraintHeightFavlist.constant = 40
            self.constraintHeightManual.constant = 0
            self.tfNoAccount.isUserInteractionEnabled = false
            self.tfFavList.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func actionPicker(_ sender: Any) {
        self.dismissKeyboard()
        self.tfFavList.becomeFirstResponder()
        if self.arrayFavlist.count > 0 {
            self.tfFavList.text = self.arrayFavlist[0]
            self.tfNoAccount.text = self.arrayValue[0]
        }
    }
    
}
