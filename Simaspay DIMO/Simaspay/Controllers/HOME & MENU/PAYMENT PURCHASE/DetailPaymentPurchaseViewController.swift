//
//  DetailPaymentPurchaseViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/20/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit
import AddressBookUI

class DetailPaymentPurchaseViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EPPickerDelegate, ABPeoplePickerNavigationControllerDelegate  {
    
    var isPurchase = false
    @IBOutlet var constraintHightNoTransaction: NSLayoutConstraint!
    @IBOutlet var constraintHeightNomPayment: NSLayoutConstraint!
    @IBOutlet var constraintHeightContactPicker: NSLayoutConstraint!

    @IBOutlet var btnNext: BaseButton!
    @IBOutlet var lblNomTransaction: BaseLabel!
    @IBOutlet var lblMpin: BaseLabel!
    @IBOutlet var lblNoAccount: BaseLabel!
    @IBOutlet var lblTitleNameProduct: BaseLabel!
    @IBOutlet var tfNomTransaction: BaseTextField!
    @IBOutlet var tfNoAccount: BaseTextField!
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var lblNameProduct: BaseTextField!
    @IBOutlet var tfDisplayNom: BaseTextField!
    @IBOutlet var lblNomPayment: BaseLabel!
    @IBOutlet var tfNomPayment: BaseTextField!
    
    
    var dictOfData : NSDictionary!
    var errorMsg : String!
    var errorMsg1 : String!
    var maxlength : Int! = 0
    var minlength : Int! = 0
    var invoiceTypeString: String!
    
    static func initWithOwnNib(isPurchased : Bool) -> DetailPaymentPurchaseViewController {
        
        let obj:DetailPaymentPurchaseViewController = DetailPaymentPurchaseViewController.init(nibName: String(describing: self), bundle: nil)
        obj.isPurchase = isPurchased
        return obj
    }
    
    var pickOption:[String]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintScrollViewHeight: NSLayoutConstraint!
    static var scrollViewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(self.isPurchase ? "Pembelian" : "Pembayaran")
        self.showBackButton()
        
        errorMsg = dictOfData.value(forKey: "errormessage") as? String
        errorMsg1 = dictOfData.value(forKey: "errormessage1") as? String
        if dictOfData.value(forKey: "maxlength") != nil {
            maxlength = dictOfData.value(forKey: "maxlength") as! Int
        } else if dictOfData.value(forKey: "maxlenght") != nil {
            maxlength = dictOfData.value(forKey: "maxlenght") as! Int
        }
       
        minlength = dictOfData.value(forKey: "minlength") as! Int
        
        invoiceTypeString = dictOfData.value(forKey: "invoiceType") as? String
        let invoiceTypeArr = invoiceTypeString?.characters.split{$0 == "|"}.map(String.init)
        lblTitleNameProduct.text = "Nama Produk"
        lblTitleNameProduct.font = UIFont.boldSystemFont(ofSize: 13)
        lblNameProduct.isUserInteractionEnabled = true
        lblNameProduct.isEnabled = false
        lblNameProduct.font = UIFont.systemFont(ofSize: 14)
        lblNameProduct.addInset()
        
        lblNomTransaction.font = lblTitleNameProduct.font
        lblNomTransaction.text = dictOfData.value(forKey: "Nominaltype") as? String
        lblNoAccount.font = lblTitleNameProduct.font
        lblNoAccount.text = invoiceTypeArr?[1]
        lblMpin.font = lblTitleNameProduct.font
        lblMpin.text = "mPIN"
        lblNomPayment.font = lblTitleNameProduct.font
        lblNomPayment.text = "Nominal"
        
        tfDisplayNom.updateTextFieldWithLabelText("Rp.")
        tfNomTransaction.updateTextFieldWithLabelText("Rp.")
        tfNoAccount.addInset()
        tfMpin.addInset()
        tfNomPayment.updateTextFieldWithLabelText("Rp.")
            
        tfDisplayNom.delegate = self
        tfNomTransaction.delegate = self
        tfNoAccount.delegate = self
        tfMpin.delegate = self
        tfNomPayment.delegate = self
        
        tfNomTransaction.rightViewMode =  UITextFieldViewMode.always
        tfNomTransaction.updateTextFieldWithRightImageNamed("icon_arrow_down")
        
        // alternative: not case sensitive
        if (invoiceTypeString.lowercased().range(of:"phone") != nil ||
            invoiceTypeString.lowercased().range(of:"phone") != nil ||
            invoiceTypeString.lowercased().range(of:"telepon") != nil) {
            constraintHeightContactPicker.constant = 0
            self.tfNoAccount.rightViewMode =  UITextFieldViewMode.always
            self.tfNoAccount.updateTextFieldWithRightImageNamed("ic_contact_phone_black")
        }
        
        
        btnNext.updateButtonType1()
        btnNext.setTitle("Lanjut", for: .normal)
        
        DLog("\(dictOfData)")
        lblNameProduct.text = dictOfData.value(forKey: "productName") as? String
        
        //Hidden picker Option and amount
        if !self.isPurchase {
            constraintHightNoTransaction.constant = 0
            self.tfNomTransaction.isUserInteractionEnabled = false
            let paymentMode = dictOfData.value(forKey: "paymentMode") as? String
            if (paymentMode == "ZeroAmount") {
                constraintHeightNomPayment.constant = 0
                self.tfNomPayment.isUserInteractionEnabled = false
                self.tfNomPayment.isEnabled = false
            }
        } else {
            self.tfNomTransaction.isUserInteractionEnabled = true
            self.constraintHeightNomPayment.constant = 0
            self.tfNomPayment.isEnabled = false
            self.tfNomPayment.isUserInteractionEnabled = false
            let denomString = (self.dictOfData.value(forKey: "Denom") as! String)
            self.pickOption = denomString.components(separatedBy: "|")
            self.tfNomTransaction.text = self.pickOption[0]
            self.tfDisplayNom.text = self.pickOption[0]
        }
        //Picker view delegate
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.tfNomTransaction.inputView = pickerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Picker view
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickOption.count
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickOption[row]
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.tfNomTransaction.text = pickOption[row]
        self.tfDisplayNom.text = pickOption[row]
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 2 {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField.tag == 1 {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= self.maxlength
        } else {
            return true
        }
    }
    
    
    func nextProsesPurchase() {
        
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_PURCHASE_AIRTIME
        dict[TXNNAME] = TXN_INQUIRY_PURCHASE_AIRTIME
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
        dict[BILLERCODE] = dictOfData.value(forKey: "productCode") as? String
        dict[BILLNO] = self.tfNoAccount.text!
        dict[AMOUNT] = self.tfNomTransaction.text!
        dict[PAYMENT_MODE] = dictOfData.value(forKey: "paymentMode") as? String
        dict[DENOM_CODE] = "2"
        dict[NOMINAL_AMOUNT] = self.tfNomTransaction.text!
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        
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
                if ( messagecode == SIMASPAY_PURCHASE_INQUIRY ){
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
                    
                    let data: [String : Any]!
                    let creditamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "creditamt.text") as? String)!)
                    let debitamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "debitamt.text") as? String)!)
                    let chargerString = (responseDict.value(forKeyPath: "charges.text") as? String)!
               
                    data = [
                        "title" : "Pastikan data berikut sudah benar",
                        "content" : [
                            ["Nama Produk" : self.dictOfData.value(forKey: "productName") as! String],
                            [self.lblNomTransaction.text! : creditamt],
                            [self.lblNoAccount.text! : self.tfNoAccount.text!],
                            [getString("Charges") : String(format: "Rp %@", chargerString)],
                        ],
                        "footer" :[
                            getString("TotalDebit") : debitamt]
                    ]
                 
                    vc.data = data! as NSDictionary
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    let dictSendOtp = NSMutableDictionary()
                    dictSendOtp[SERVICE] = SERVICE_PURCHASE_AIRTIME
                    dictSendOtp[TXNNAME] = TXN_CONFIRM_PURCHASE_AIRTIME
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[AUTH_KEY] = ""
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[BILLERCODE] = self.dictOfData.value(forKey: "productCode") as? String
                    dictSendOtp[BILLNO] = self.tfNoAccount.text!
                    dictSendOtp[AMOUNT] = self.tfNomTransaction.text!
                    dictSendOtp[PAYMENT_MODE] = self.dictOfData.value(forKey: "paymentMode") as? String
                    dictSendOtp[BANK_ID] = ""
                    dictSendOtp[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    dictSendOtp[CONFIRMED] = "true"
                    dictSendOtp[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
                    dictSendOtp[MFAOTP] = true
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.lblSuccesTransaction = getString("SuccesPurchase")
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
    
    func nextProsesPayment() {
        let paymentMode = dictOfData.value(forKey: "paymentMode") as? String
       
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_PAYMENT
        dict[TXNNAME] = TXN_INQUIRY_PAYMENT
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
        dict[BILLERCODE] = dictOfData.value(forKey: "productCode") as? String
        dict[BILLNO] = self.tfNoAccount.text!
        dict[PAYMENT_MODE] = dictOfData.value(forKey: "paymentMode") as? String
        if (paymentMode == "ZeroAmount") {
            dict[AMOUNT] = ""
        } else {
            dict[AMOUNT] = self.tfNomPayment.text!
        }
        dict[DENOM_CODE] = ""
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        
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
                if ( messagecode == SIMASPAY_PAYMENT_INQUIRY ){
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
                    
                    if responseDict.value(forKeyPath: "AdditionalInfo.text") == nil {
                        let data: [String : Any]!
                        let creditamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "creditamt.text") as? String)!)
                        let debitamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "debitamt.text") as? String)!)
                        let chargerString = (responseDict.value(forKeyPath: "charges.text") as? String)!
                        
                        data = [
                            "title" : "Pastikan data berikut sudah benar",
                            "content" : [
                                ["Nama Produk" : self.dictOfData.value(forKey: "productName") as! String],
                                [self.lblNomPayment.text! : creditamt],
                                [self.lblNoAccount.text! : self.tfNoAccount.text!],
                                [getString("Charges") : String(format: "Rp %@", chargerString)],
                            ],
                            "footer" :[
                                getString("TotalDebit") : debitamt]
                        ]
                        
                        vc.data = data! as NSDictionary

                    } else {
                        let strAditional = responseDict.value(forKeyPath: "AdditionalInfo.text") as! String
                        let arrAditional = strAditional.characters.split{$0 == "|"}.map(String.init)
                        var newArrAditional = [String]()
                        for data in arrAditional {
                            let strConvert = data.replacingOccurrences(of: "  ", with: "~")
                            let strRemoveStart = strConvert.replacingOccurrences(of: " ~", with: "")
                            let strRemoveEnd = strRemoveStart.replacingOccurrences(of: "~ ", with: "")
                            let strNew = strRemoveEnd.replacingOccurrences(of: "~", with: "")
                            if strNew != "" {
                                newArrAditional.append(strNew)
                            }
                        }
                        
                        vc.isAditional = true
                        vc.dataAditional = newArrAditional
                    }
        
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    let dictSendOtp = NSMutableDictionary()
                    dictSendOtp[SERVICE] = SERVICE_PAYMENT
                    dictSendOtp[TXNNAME] = TXN_CONFIRM_PAYMENT
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[AUTH_KEY] = ""
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[BILLERCODE] = self.dictOfData.value(forKey: "productCode") as? String
                    dictSendOtp[BILLNO] = self.tfNoAccount.text!
                    dictSendOtp[PAYMENT_MODE] = self.dictOfData.value(forKey: "paymentMode") as? String
                    dictSendOtp[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    dictSendOtp[CONFIRMED] = "true"
                    dictSendOtp[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
                    dictSendOtp[MFAOTP] = true
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.lblSuccesTransaction = getString("SuccesPayment")
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
    
    func nextPurchase() {
        var message = "";
        if (self.isPurchase && !self.tfNomTransaction.isValid()){
            message = "Pilih nominal"
        } else if (!tfNoAccount.isValid()){
            message = errorMsg
        } else if (tfNoAccount.length() < minlength){
            message = errorMsg1
        } else if (!tfMpin.isValid()){
            message = "Harap Masukkan " + getString("TransferLebelMPIN") + " Anda"
        } else if (tfMpin.length() < 6) {
            message = "PIN harus 6 digit"
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        self.nextProsesPurchase()
    }
    
    func nextPayment() {
        let paymentMode = dictOfData.value(forKey: "paymentMode") as? String
        var message = "";
        if (paymentMode == "ZeroAmount") {
            if (!tfNoAccount.isValid()){
                message = errorMsg
            } else if (tfNoAccount.length() < minlength){
                message = errorMsg1
            } else if (!tfMpin.isValid()){
                message = "Harap Masukkan " + getString("TransferLebelMPIN") + " Anda"
            } else if (tfMpin.length() < 6) {
                message = "PIN harus 6 digit"
            } else if (!SimasAPIManager.isInternetConnectionExist()) {
                message = getString("LoginMessageNotConnectServer")
            }
        } else {
            if (!tfNoAccount.isValid()){
                message = errorMsg
            } else if (tfNoAccount.length() < minlength){
                message = errorMsg1
            } else  if (!self.tfNomPayment.isValid()){
                message = "Masukkan nominal"
            } else if (!tfMpin.isValid()){
                message = "Harap Masukkan " + getString("TransferLebelMPIN") + " Anda"
            } else if (tfMpin.length() < 6) {
                message = "PIN harus 6 digit"
            } else if (!SimasAPIManager.isInternetConnectionExist()) {
                message = getString("LoginMessageNotConnectServer")
            }
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        self.nextProsesPayment()
    }

    @IBAction func actionShowPicker(_ sender: Any) {
        self.tfNomTransaction.becomeFirstResponder()
    }
    
    //MARK: Action Confirm button
    @IBAction func actionConfirmation(_ sender: AnyObject) {
        
        if !self.isPurchase {
            self.nextPayment()
        } else {
            self.nextPurchase()
        }
        
    }
    
    //MARK: actionPickerContact
    @IBAction func actionPickerContact(_ sender: Any) {
        
        if #available(iOS 9.0, *) {
            let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.phoneNumber)
            let navigationController = UINavigationController(rootViewController: contactPickerScene)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            let contactPicker = ABPeoplePickerNavigationController()
            contactPicker.peoplePickerDelegate = self
            contactPicker.displayedProperties = [NSNumber(value: kABPersonEmailProperty)]
            contactPicker.displayedProperties = [NSNumber(value: kABPersonPhoneProperty)]
            present(contactPicker, animated: true, completion: nil)
        }
    }
    
    //MARK: EPContactsPicker delegates
    @available(iOS 9.0, *)
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError){
        print("Failed with error \(error.description)")
    }
    
    @available(iOS 9.0, *)
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact) {
        let phoneNumbers = contact.phoneNumbers
        var phoneNUmber = ""
        
        if phoneNumbers.count > 0 {
            phoneNUmber = phoneNumbers[0].phoneNumber
        }
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "(", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: ")", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "-", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "+", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: " ", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "  ", with: "")
        self.tfNoAccount.text = phoneNUmber
    }
    
    @available(iOS 9.0, *)
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError) {
        print("User canceled the selection");
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        
        let phones: ABMultiValue = ABRecordCopyValue(person, kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValue
        var phoneNUmber = ""
        for index in 0 ..< ABMultiValueGetCount(phones){
            let currentPhoneValue = ABMultiValueCopyValueAtIndex(phones, index).takeUnretainedValue() as! CFString as String
            if index == 0 {
                phoneNUmber = currentPhoneValue
            }
        }
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "(", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: ")", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "-", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "+", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: " ", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "  ", with: "")
        self.tfNoAccount.text = phoneNUmber
        peoplePicker.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Keyboard
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        if (DetailPaymentPurchaseViewController.scrollViewHeight == 0) {
            DetailPaymentPurchaseViewController.scrollViewHeight = constraintScrollViewHeight.constant
            constraintScrollViewHeight.constant = DetailPaymentPurchaseViewController.scrollViewHeight - BaseViewController.keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        constraintScrollViewHeight.constant = DetailPaymentPurchaseViewController.scrollViewHeight
        DetailPaymentPurchaseViewController.scrollViewHeight = 0
        self.view.layoutIfNeeded()
    }
}



