//
//  CashWithDrawalController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/1/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit
import AddressBookUI

//MARK: Transfer type
enum WithDrawalType : Int {
    case WithDrawalTypeMe
    case WithDrawalTypeOther
}

class CashWithDrawalController: BaseViewController, UITextFieldDelegate, EPPickerDelegate, ABPeoplePickerNavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    var arrayFavlist = [String]()
    var arrayValue = [String]()
    var isAviableFavList: Bool = false
    @IBOutlet weak var radioBtnFav: BaseButton!
    @IBOutlet weak var radioBtnManual: BaseButton!
    @IBOutlet var tfFavList: BaseTextField!
    @IBOutlet weak var constraintHeightManual: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightFavlist: NSLayoutConstraint!
    let pickerView = UIPickerView()
    var firstCall: Bool = true
    
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
        self.tfNoAccount.rightViewMode =  UITextFieldViewMode.always
        self.tfNoAccount.updateTextFieldWithRightImageNamed("ic_contact_phone_black")
        
        self.textFieldmPin.font = UIFont.systemFont(ofSize: 14)
        self.textFieldmPin.addInset()
        self.textFieldmPin.delegate = self
        
        self.tfAmountTransfer.font = UIFont.systemFont(ofSize: 14)
        self.tfAmountTransfer.updateTextFieldWithLabelText("Rp.")
        self.tfAmountTransfer.delegate = self
        
        
        if (self.withDrawalType == WithDrawalType.WithDrawalTypeMe) {
            constraintViewAcount.constant = 0
            self.showTitle(getString("WithDrawalMe"))
            self.tfNoAccount.isUserInteractionEnabled = false
            self.tfFavList.isUserInteractionEnabled = false
        } else {
            constraintViewAcount.constant = 151
            self.constraintHeightFavlist.constant = 0
            self.constraintHeightManual.constant = 40
            self.showTitle(getString("WithDrawalOther"))
            self.radioBtnFav.updateToRadioButtonWith(_titleButton: "Dari Daftar Favorit")
            self.radioBtnManual.updateToRadioButtonWith(_titleButton: "Ketik Manual")
            self.radioBtnManual.isSelected = true
            self.radioBtnFav.isSelected = false
            self.tfFavList.addInset()
            self.tfFavList.rightViewMode =  UITextFieldViewMode.always
            self.tfFavList.updateTextFieldWithRightImageNamed("icon_arrow_down")
            self.tfFavList.forPicker()
            self.tfNoAccount.isUserInteractionEnabled = true
            self.tfFavList.isUserInteractionEnabled = false
            pickerView.delegate = self
            self.tfFavList.inputView = pickerView
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.withDrawalType == WithDrawalType.WithDrawalTypeOther) {
            if firstCall {
                self.getFavList()
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
            if (self.withDrawalType != WithDrawalType.WithDrawalTypeMe) {
                let maxLength = 14
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            } else {
                return true
            }
        } else if textField.tag == 2 {
            let maxLength = 17
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
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
        var intValue : IntMax?
        if (tfAmountTransfer.isValid()) {
            var anOptionalString : String?
            anOptionalString = tfAmountTransfer.text
            intValue = IntMax(anOptionalString!)
        } else {
            intValue = 0
        }
        
        var message = "";
        if (self.withDrawalType != WithDrawalType.WithDrawalTypeMe && !tfNoAccount.isValid()) {
            message = "Silakan Masukkan " + getString("TransferLebelMdn") + " Anda"
        } else if(self.withDrawalType != WithDrawalType.WithDrawalTypeMe && tfNoAccount.length() < 10){
            message = "Nomor Handphone yang Anda masukkan harus 10-14 angka"
        } else if (self.radioBtnManual.isSelected && self.isAviableFavList){
            message = "Nomor sudah terdaftar di favorit list"
        } else if (!tfAmountTransfer.isValid()){
            message = "Silakan Masukkan " + getString("TransferLebelAmount") + " yang ingin Anda Cashout"
        } else if (tfAmountTransfer.isValid() && intValue! < 100000) {
            message = "Jumlah transaksi tarik tunai minimal Rp 100.000 dan harus kelipatan Rp. 50.000"
        } else if (tfAmountTransfer.isValid() && intValue! % 50000 != 0) {
             message = "Jumlah transaksi tarik tunai minimal Rp 100.000 dan harus kelipatan Rp. 50.000"
        } else if (!textFieldmPin.isValid()){
            message = "Harap Masukkan " + getString("TransferLebelMPIN") + " Anda"
        } else if (textFieldmPin.length() < 6) {
            message = "PIN harus 6 digit "
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
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
            
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
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
                    
                    vc.lblSuccesTransaction = getString("SuccesWithDrawal")
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.mPin = self.textFieldmPin.text
                    vc.favoriteCategoryID = "13"
                    if (self.withDrawalType == WithDrawalType.WithDrawalTypeOther) {
                        vc.value = self.tfNoAccount.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                    } else {
                        vc.isFavList = false
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
    
    //MARK: actionPickerContact
    @IBAction func actionPickerContact(_ sender: Any) {
        self.firstCall = false
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
        self.firstCall = false
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
        self.firstCall = false
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
    
    
    func getFavList() {
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_FAVORITE_JSON
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
        dict[FAVORITE_CATEGORY_ID] = "13"
        
        
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
