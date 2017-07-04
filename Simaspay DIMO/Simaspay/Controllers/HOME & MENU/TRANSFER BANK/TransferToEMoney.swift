//
//  TransferToEMoney.swift
//  Simaspay
//
//  Created by Dimo on 4/12/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit
import AddressBookUI

class TransferToEMoney: BaseViewController, UITextFieldDelegate, EPPickerDelegate, ABPeoplePickerNavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelMdn: BaseLabel!
    @IBOutlet weak var inputMdn: BaseTextField!
    @IBOutlet weak var LabelAmount: BaseLabel!
    @IBOutlet weak var inputAmount: BaseTextField!
    @IBOutlet weak var labelmPin: BaseLabel!
    @IBOutlet weak var inputmPin: BaseTextField!
    @IBOutlet weak var btnNext: BaseButton!
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
    
    static func initWithOwnNib() -> TransferToEMoney {
        let obj:TransferToEMoney = TransferToEMoney.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("TransferEMoneyTitle"))
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
        self.inputMdn.delegate = self
        self.inputMdn.rightViewMode =  UITextFieldViewMode.always
        self.inputMdn.updateTextFieldWithRightImageNamed("ic_contact_phone_black")
        
        self.inputAmount.font = UIFont.systemFont(ofSize: 14)
        self.inputAmount.updateTextFieldWithLabelText("Rp.")
        
        self.inputmPin.font = UIFont.systemFont(ofSize: 14)
        self.inputmPin.addInset()
        self.inputmPin.delegate = self
        
        self.constraintHeightFavlist.constant = 0
        self.constraintHeightManual.constant = 40
        self.radioBtnFav.updateToRadioButtonWith(_titleButton: "Dari Daftar Favorit")
        self.radioBtnManual.updateToRadioButtonWith(_titleButton: "Ketik Manual")
        self.radioBtnManual.isSelected = true
        self.radioBtnFav.isSelected = false
        self.tfFavList.addInset()
        self.tfFavList.rightViewMode =  UITextFieldViewMode.always
        self.tfFavList.updateTextFieldWithRightImageNamed("icon_arrow_down")
        self.tfFavList.forPicker()
        self.inputMdn.isUserInteractionEnabled = true
        self.tfFavList.isUserInteractionEnabled = false
        pickerView.delegate = self
        self.tfFavList.inputView = pickerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstCall {
            self.getFavList()
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
            let maxLength = 14
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
    
    
    func nextProses() {
        
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
        dict[SOURCEPIN] = simasPayRSAencryption(self.inputmPin.text!)
        dict[DESTMDN] = getNormalisedMDN(self.inputMdn.text! as NSString)
        dict[DESTBANKACCOUNT] = ""
        dict[AMOUNT] = self.inputAmount.text
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[BANK_ID] = ""
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        dict[DESTPOCKETCODE] = ACCOUNTTYPEEMMONEY
    
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
                if ( messagecode == SIMASPAY_INQUIRY_TRANSFER_SUCCESS_CODE ||
                    messagecode == SIMASPAY_EMONEY_TO_EMONEY_UN_SUBSCRIBER ){
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
                    dictOtp[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
                    dictOtp[AUTH_KEY] = ""
                    vc.dictForRequestOTP = dictOtp as NSDictionary
                    
                    let data: [String : Any]!
                    let creditamt = String(format: "Rp %@", (responseDict.value(forKeyPath: "creditamt.text") as? String)!)
                    if messagecode == SIMASPAY_INQUIRY_TRANSFER_SUCCESS_CODE {
                        data = [
                            "title" : "Pastikan data berikut sudah benar",
                            "content" : [
                                [getString("ConfirmationOwnMdn") : responseDict.value(forKeyPath: "ReceiverAccountName.text")],
                                [getString("TransferLebelMdn") : responseDict.value(forKeyPath: "destinationMDN.text")],
                                [getString("TransferLebelAmount") : creditamt],
                            ]
                        ]
                    } else {
                        data = [
                            "title" : "Pastikan data berikut sudah benar",
                            "content" : [
                                [getString("ConfirmationOwnMdn") : getString("NotRegisterMDN")],
                                [getString("TransferLebelMdn") : (responseDict.value(forKeyPath: "destinationMDN.text") as? String)! + "*"],
                                [getString("TransferLebelAmount") : creditamt],
                                ["-" : getString("NotSubscriberMDN")],
                            ]
                        ]
                    }
                    
                    vc.data = data! as NSDictionary
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    
                    let dictSendOtp = NSMutableDictionary()
                    if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
                        vc.value = self.inputMdn.text
                        vc.favoriteCategoryID = "7"
                        vc.mPin = self.inputmPin.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                        dictSendOtp[SERVICE] = SERVICE_WALLET
                    } else {
                        vc.value = self.inputMdn.text
                        vc.favoriteCategoryID = "5"
                        vc.mPin = self.inputmPin.text
                        if (self.radioBtnFav.isSelected){
                            vc.isFavList = false
                        }
                        dictSendOtp[SERVICE] = SERVICE_BANK
                    }
                    dictSendOtp[TXNNAME] = TRANSFER
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[AUTH_KEY] = ""
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[DESTMDN] = getNormalisedMDN(self.inputMdn.text! as NSString)
                    dictSendOtp[DESTBANKACCOUNT] = ""
                    dictSendOtp[CHANNEL_ID] = CHANNEL_ID_VALUE
                    dictSendOtp[BANK_ID] = ""
                    dictSendOtp[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
                    dictSendOtp[DESTPOCKETCODE] = ACCOUNTTYPEEMMONEY
                    dictSendOtp[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    dictSendOtp[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    dictSendOtp[CONFIRMED] = "true"
                    dictSendOtp[MFAOTP] = true
                    
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.lblSuccesTransaction = getString("SuccesTransfer")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: action next
    @IBAction func actionProses(_ sender: Any) {
        
        var message = "";
        if (!inputMdn.isValid()) {
            message = "Silakan Masukkan " + getString("TransferLebelMdn") + " Anda"
        }else if(inputMdn.length() < 10){
            message = "Nomor Handphone yang Anda masukkan harus 10-14 angka"
        } else if (self.radioBtnManual.isSelected && self.isAviableFavList){
            message = "Nomor sudah terdaftar di favorit list"
        } else if (!inputAmount.isValid()){
            message = getString("TransferEmptyNominal")
        } else if (!inputmPin.isValid()){
            message = "Harap Masukkan " + getString("TransferLebelMPIN") + " Anda"
        } else if (inputmPin.length() < 6) {
            message = "PIN harus 6 digit "
        } else if (!SimasAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        self.nextProses()
        
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
        
        if phoneNumbers.count > 0 {
            phoneNUmber = phoneNumbers[0].phoneNumber
        }
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "(", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: ")", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "-", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "+", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: " ", with: "")
        phoneNUmber = phoneNUmber.replacingOccurrences(of: "  ", with: "")
        self.inputMdn.text = phoneNUmber
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
        self.inputMdn.text = phoneNUmber
        peoplePicker.dismiss(animated: true, completion: nil)

    }
    
    func getFavList() {
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_FAVORITE_JSON
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
        if (SimasAPIManager.sharedInstance().sourcePocketCode as String == "1") {
           dict[FAVORITE_CATEGORY_ID] = "7"
        } else {
            dict[FAVORITE_CATEGORY_ID] = "5"
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
            self.inputMdn.text = self.arrayValue[row]
        }
    }
    
    @IBAction func actionRadio(_ sender: Any) {
        self.tfFavList.text=""
        self.inputMdn.text=""
        if self.radioBtnFav.isSelected {
            self.radioBtnManual.isSelected = true
            self.radioBtnFav.isSelected = false
            self.constraintHeightFavlist.constant = 0
            self.constraintHeightManual.constant = 40
            self.inputMdn.isUserInteractionEnabled = true
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
            self.inputMdn.isUserInteractionEnabled = false
            self.tfFavList.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func actionPicker(_ sender: Any) {
        self.dismissKeyboard()
        self.tfFavList.becomeFirstResponder()
        if self.arrayFavlist.count > 0 {
            self.tfFavList.text = self.arrayFavlist[0]
            self.inputMdn.text = self.arrayValue[0]
        }
    }

}
