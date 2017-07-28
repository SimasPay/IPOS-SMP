    //
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/4/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController, UIAlertViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewNavigation: UIView!
    
    @IBOutlet var btnTrue: BaseButton!
    @IBOutlet var btnFalse: BaseButton!
    @IBOutlet var viewContentConfirmation: UIView!
    @IBOutlet var constraintViewContent: NSLayoutConstraint!
    @IBOutlet var viewMainContent: UIView!
    @IBOutlet var bottomBtnCancel: NSLayoutConstraint!
    
    var btnResandOTP: BaseButton!
    var tfOTP: BaseTextField!
    
    //Timer for OTP resend button
    var timerCount = 60
    var clock:Timer!
    var lblTimer: BaseLabel!
    
    var MDNString:String! = ""
    var otpString:String! = ""
    
    //Dictionary for show data registration
    var data: NSDictionary!
    
    //Dictionary Req OTP
    var dictForRequestOTP: NSDictionary!
    
    //Dictionary send ORP
    var dictForAcceptedOTP: NSDictionary!
    
    //Value to set background navigation
    var useNavigation: Bool = true
    
    var isRegister:Bool = false
    var isAditional: Bool = false
    var ismPinChange: Bool = false
    
    //Dictionary for show data registration
    var dataAditional: Array<String>!
    var lblSuccesTransaction: String = ""
    
    var value: String! = ""
    var mPin: String!  = ""
    var favoriteCategoryID: String!  = ""
    var favoriteCode: String! = ""
    var isFavList: Bool! = true
    
    var alertController = UIAlertController()
    
    static func initWithOwnNib() -> ConfirmationViewController {
        let obj:ConfirmationViewController = ConfirmationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!useNavigation) {
            self.viewNavigation.backgroundColor = UIColor.clear
            self.showBackButton(subMenu: false)
        } else {
            self.showBackButton()
        }
        self.showTitle(getString("ConfirmationTitle"))
        
        self.view.backgroundColor = UIColor.init(hexString: color_background)

        DLog("\(data)")
        self.viewMainContent.layer.cornerRadius = 5.0;
        self.viewMainContent.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewMainContent.layer.borderWidth = 0.5
        self.viewMainContent.clipsToBounds = true;
        
        self.btnTrue.updateButtonType1()
        self.btnFalse.updateButtonType3()
        
        if isRegister {
            self.btnTrue.setTitle("Daftar Akun E-money", for: .normal)
            self.btnFalse.setTitle("Batal", for: .normal)
        } else {
            self.btnTrue.setTitle(getString("ConfirmationButtonTrue"), for: .normal)
            self.btnFalse.setTitle(getString("ConfirmationButtonFalse"), for: .normal)
        }
        btnTrue.addTarget(self, action: #selector(ConfirmationViewController.buttonStatus) , for: .touchUpInside)
        btnFalse.addTarget(self, action: #selector(ConfirmationViewController.cancel), for: .touchUpInside)
        
        
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
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Programmatically UI
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let padding:CGFloat = 16
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width - 2 * 25
        let heightContent:CGFloat = 17
        let heightTitleContent:CGFloat = 17
        let margin:CGFloat = 10
        var y:CGFloat = 16
        
        if isRegister {
            let lblTitle = BaseLabel.init(frame: CGRect(x: padding, y: padding, width: width - 2 * padding, height: 90))
            // lblTitle.textAlignment =
            lblTitle.numberOfLines = 7
            lblTitle.font = UIFont.systemFont(ofSize: 14)
            lblTitle.text = "Anda akan membuka akun e-money dengan data diri Anda sebagai nasabah Bank Sinarmas. Lanjutkan proses?"
            viewContentConfirmation.addSubview(lblTitle)
            y += 90 + 10
        } else if isAditional {
            let lblTitle = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightTitleContent))
            lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
            lblTitle.text = "Pastikan data berikut sudah benar"
            viewContentConfirmation.addSubview(lblTitle)
            y += heightTitleContent + 20
            
            var i: Int = 1
            for newData in dataAditional {
                if i == dataAditional.count {
                    let line = CALayer()
                    line.frame = CGRect(x: padding, y: y, width: width - 2 * padding, height: 1)
                    line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
                    viewContentConfirmation.layer.addSublayer(line)
                    y += margin
                }
                let arrVal = newData.characters.split{$0 == ":"}.map(String.init)
                let key = arrVal[0]
                let value = arrVal[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
                lblKey.font = UIFont.boldSystemFont(ofSize: 13)
                lblKey.text = key.capitalized
                viewContentConfirmation.addSubview(lblKey)
                y += heightContent
                
                let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
                lblValue.font = UIFont.systemFont(ofSize: 13)
                lblValue.text = value.capitalized
                viewContentConfirmation.addSubview(lblValue)
                y += heightContent + margin
                i += 1
            }
        } else if ismPinChange {
            let lblTitle = BaseLabel.init(frame: CGRect(x: padding, y: padding, width: width - 2 * padding, height: 60))
            // lblTitle.textAlignment =
            lblTitle.numberOfLines = 7
            lblTitle.font = UIFont.systemFont(ofSize: 14)
            lblTitle.text = "Anda akan mengubah mPin Anda. Lanjutkan proses?"
            viewContentConfirmation.addSubview(lblTitle)
            let screenSize = UIScreen.main.bounds
            self.bottomBtnCancel.constant = screenSize.height - 400
            y += 60 + 10
        } else {
            let lblTitle = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightTitleContent))
            lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
            lblTitle.text = data.value(forKey: "title") as? String
            viewContentConfirmation.addSubview(lblTitle)
            y += heightTitleContent + 10
            
            
            let arrayContent = data.value(forKey: "content")
            for content in arrayContent as! Array<[String : String]> {
                for list in content {
                    let key = list.key
                    let Value = list.value
                    
                    if key == "-" {
                        let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: 90))
                        lblValue.font = UIFont.systemFont(ofSize: 13)
                        lblValue.numberOfLines = 0
                        lblValue.lineBreakMode = .byWordWrapping
                        lblValue.text = Value
                        viewContentConfirmation.addSubview(lblValue)
                        y += 90 + margin
                    } else {
                        
                        let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
                        lblKey.font = UIFont.boldSystemFont(ofSize: 13)
                        lblKey.text = key
                        viewContentConfirmation.addSubview(lblKey)
                        y += heightContent
                        
                        let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
                        lblValue.font = UIFont.systemFont(ofSize: 13)
                        lblValue.text = Value
                        viewContentConfirmation.addSubview(lblValue)
                        y += heightContent + margin
                    }
                    
                }
            }
            
            if let contentFooterDica = data.value(forKey: "footer") {
                let contentFooterDic = contentFooterDica as! NSDictionary
                if contentFooterDic.allKeys.count != 0 {
                    let line = CALayer()
                    line.frame = CGRect(x: padding, y: y, width: width - 2 * padding, height: 1)
                    line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
                    viewContentConfirmation.layer.addSublayer(line)
                    
                    y += margin
                    for list in contentFooterDic {
                        let key = list.key as! String
                        let Value = list.value as! String
                        
                        let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
                        lblKey.font = UIFont.boldSystemFont(ofSize: 13)
                        lblKey.text = key
                        viewContentConfirmation.addSubview(lblKey)
                        y += heightContent
                        
                        let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
                        lblValue.font = UIFont.systemFont(ofSize: 13)
                        lblValue.text = Value
                        viewContentConfirmation.addSubview(lblValue)
                        y += heightContent + margin
                    }
                }
            }
        }
        
        let height = y + margin
        self.constraintViewContent.constant = height
    }
    
    //MARK: Action cancel
    func cancel()  {
        navigationController?.popViewController(animated: true)
    }
    
    
    //function true button
    func buttonStatus()  {
        self.requestOTP()
    }
    
    func resendTheOTP() {
        self.requestOTP()
        timerCount = 60
        lblTimer.text = "01:00"
        lblTimer.isHidden = false
        btnResandOTP.isHidden = true
       
    }
    
    //MARK: Action button for OTP alert
    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()
        
    }
    
    func didOTPOK() {
        DLog("OK");
        clock.invalidate()
        self.sendOTP(OTP: self.otpString)
        
    }
    
    //MARK: Count down timer
    func countDown(){
        if (timerCount > 0) {
            timerCount -= 1
            lblTimer.text = "00:\(timerCount)"
        } else {
//            let textFields = self.alertController.textFields
//            for dt in textFields!{
//               dt.resignFirstResponder()
//            }
            self.alertController.dismiss(animated: true, completion: {
                SimasAlertView.showAlert(withTitle: getString("titleEndOtp"), message: getString("messageEndOtp"), cancelButtonTitle: getString("AlertCloseButtonText"))
            })
            clock.invalidate()
        }
    }
    
    //MARK Action button to resand OTP
    func resendOTP()  {
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ConfirmationViewController.resendOTP), userInfo: nil, repeats: true)
        
    }

    
    //MARK: Show OTP Alert
    func showOTP()  {
        timerCount = 60
        alertController = UIAlertController(title: getString("ConfirmationOTPMessageTitle") + "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let temp = UIView(frame: CGRect(x: 0, y: 40, width: 270, height: 100))
        let MDNString = ("\(getNormalisedMDN(dictForAcceptedOTP.value(forKey: SOURCEMDN) as! NSString))")
        let messageString = String(format: getString("ConfirmationOTPMessage"), MDNString)
        let messageAlert = UILabel(frame: CGRect(x: 10, y: 10, width: temp.frame.size.width - 20, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = messageString as String
        
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        btnResandOTP = BaseButton(frame: CGRect(x: 0, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height, width: temp.frame.size.width, height: 35))
        btnResandOTP.setTitle(getString("ConfirmationOTPResendButton"), for: .normal)
        btnResandOTP.setTitleColor(UIColor.init(hexString: color_btn_alert), for: .normal)
        btnResandOTP.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btnResandOTP.titleLabel?.textAlignment = .center
        btnResandOTP.addTarget(self, action: #selector(self.resendTheOTP), for: .touchUpInside)
        btnResandOTP.isHidden = true
        
        lblTimer = BaseLabel(frame: CGRect(x: 0, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 10, width: temp.frame.size.width, height: 15))
        lblTimer.textAlignment = .center
        lblTimer.font = UIFont.systemFont(ofSize: 12)
        lblTimer.text = "01:00"
        
        
        temp.addSubview(btnResandOTP)
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
        // showOTPWith(title: getString("ConfirmationOTPMessageTitle"), view: temp)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 10 {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            self.otpString = newString as String!
            return newString.length <= maxLength
        } else {
            return true
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
    
    //MARK: Request OTP
    func requestOTP() {
        DLog("\(dictForRequestOTP)")
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        SimasAPIManager .callAPI(withParameters: (dictForRequestOTP ) as! [AnyHashable : Any]!) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    SimasAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                if (messagecode == "2171" || messagecode == "655"){
                    self.showOTP()
                    // 2171 sukses
                } else {
                    // 2173 gagal
                    SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
            }
        }
    }
    
    //MARK: Send OTP
    func sendOTP(OTP: String) {
        var message = ""
        if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        DLog("\(OTP)")
        let dict = NSMutableDictionary()
        let temp = NSMutableDictionary(dictionary: dict);
        temp.addEntries(from: dictForAcceptedOTP as! [AnyHashable : Any])
        
        if ((temp.value(forKey: MFAOTP)) != nil) {
            temp[MFAOTP] = simasPayRSAencryption(OTP)
        } else {
            temp[ACTIVATION_OTP] = simasPayRSAencryption(OTP)
        }
        dictForAcceptedOTP = temp as NSDictionary
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        
        var sessionCheck = false
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: HomeViewController.self)) {
                sessionCheck = true
                
            }
        }
        
        DLog("\(dictForAcceptedOTP)")
        SimasAPIManager .callAPI(withParameters: dictForAcceptedOTP as! [AnyHashable : Any]!, withSessionCheck:sessionCheck) { (dict, err) in
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
                if (messagecode == SIMAPAY_SUCCESS_CHANGEPIN_CODE){
                    let vc = SuccesChangemPinController.initWithOwnNib()
                    let data = [
                        "title" : "mPin Berhasil Diubah",
                        "content" : [],
                        "footer" : [:]
                        ] as [String : Any]
            
                    vc.data = data as NSDictionary!
                    vc.lblSuccesTransaction = self.lblSuccesTransaction
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == SIMASPAY_REGISTRATION__EMONEY_SUCCESS_CODE){
                    let vc = ActivationSuccessViewController.initWithMessageInfo(message: getString("RegistrationLabelInfoSuccessMessage"), title: getString("RegistrationLabelInfoSuccess"))
                    self.navigationController?.pushViewController(vc, animated: false)
                } else if (messagecode == SIMASPAY_CONFIRM_TRANSFER_TO__EMONEY_SUCCESS_CODE || messagecode == SIMASPAY_BANK_TRANSFER_TO__EMONEY_SUCCESS_CODE ||
                    messagecode == SIMASPAY_EMONEY_TO_BSIM ||
                    messagecode == SIMASPAY_EMONEY_TO_UNSUBCRIBER ||
                    messagecode == SIMASPAY_TRANSFER_UANGKU_CONFIRM_SUCCESSCODE ||
                    messagecode == SIMASPAY_CASH_WITH_DRAWAL_SUCCESSCODE ) {
                    let vc = SuccesConfirmationController.initWithOwnNib()
                    vc.value = self.value
                    vc.favoriteCategoryID = self.favoriteCategoryID
                    vc.favoriteCode = self.favoriteCode
                    vc.mPin = self.mPin
                    vc.isFavList = self.isFavList
                    vc.data = self.data
                    vc.lblSuccesTransaction = self.lblSuccesTransaction
                    vc.idTran =  responseDict.value(forKeyPath: "sctlID.text") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == SIMASPAY_EMONEY_POKET_SUCCES) {
                    let vc = SuccesRegisterController.initWithOwnNib()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == SIMASPAY_PURCHASE_SUCCESCODE){
                    let vc = SuccesConfirmationController.initWithOwnNib()
                    if responseDict.value(forKeyPath: "AdditionalInfo.text") == nil {
                        vc.isAditional = false
                        vc.data = self.data
                    } else {
                        let strAditional = responseDict.value(forKeyPath: "AdditionalInfo.text") as! String
                        let arrAditional = strAditional.characters.split{$0 == "|"}.map(String.init)
                        var newArrAditional = [String]()
                        var strJoin: String = ""
                        var isKeyValue: Bool = true
                        var i = 1
                        for data in arrAditional {
                            let strConvert = data.replacingOccurrences(of: "  ", with: "~")
                            let strRemoveStart = strConvert.replacingOccurrences(of: " ~", with: "")
                            let strRemoveEnd = strRemoveStart.replacingOccurrences(of: "~ ", with: "")
                            let strNew = strRemoveEnd.replacingOccurrences(of: "~", with: "")
                            
                            if strNew != "" {
                                let arrInfo = strNew.characters.split{$0 == ":"}.map(String.init)
                                
                                if isKeyValue {
                                    if arrInfo.count > 1 {
                                        newArrAditional.append(strNew)
                                    } else {
                                        isKeyValue = false
                                        strJoin += strNew + " "
                                    }
                                } else {
                                    strJoin += strNew + " "
                                }
                                
                                if i == arrAditional.count && strJoin != ""{
                                    let clearStr = strJoin.replacingOccurrences(of: ":", with: "=")
                                    let newStr = " : " + clearStr
                                    newArrAditional.append(newStr)
                                }
                            }
                            
                            i+=1
                        }
                        let footer = self.data.value(forKey: "footer") as! NSDictionary
                        let val = footer.value(forKey: getString("TotalDebit")) as! String
                        newArrAditional.append(getString("TotalDebit") + " : " + val)
                        vc.isAditional = true
                        vc.dataAditional = newArrAditional
                    }
                    vc.value = self.value
                    vc.favoriteCategoryID = self.favoriteCategoryID
                    vc.favoriteCode = self.favoriteCode
                    vc.mPin = self.mPin
                    vc.isFavList = self.isFavList
                    vc.lblSuccesTransaction = self.lblSuccesTransaction
                    vc.idTran = responseDict.value(forKeyPath: "sctlID.text") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == SIMASPAY_PAYMENT_SUCCESSCODE) {
                    let vc = SuccesConfirmationController.initWithOwnNib()
                    if self.isAditional {
                        if responseDict.value(forKeyPath: "AdditionalInfo.text") != nil {
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
                        } else {
                            vc.isAditional = self.isAditional
                            vc.dataAditional = self.dataAditional
                        }
                    } else {
                        if responseDict.value(forKeyPath: "AdditionalInfo.text") != nil {
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
                        } else {
                            vc.isAditional = self.isAditional
                            vc.data = self.data
                        }
                    }
                    vc.value = self.value
                    vc.favoriteCategoryID = self.favoriteCategoryID
                    vc.favoriteCode = self.favoriteCode
                    vc.mPin = self.mPin
                    vc.isFavList = self.isFavList
                    vc.lblSuccesTransaction = self.lblSuccesTransaction
                    vc.idTran = responseDict.value(forKeyPath: "sctlID.text") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if (messagecode == "631") {
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    SimasAlertView.showNormalTitle("Error", message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        for vc in viewControllers {
                            if (vc.isKind(of: RegisterEMoneyViewController.self)) {
                                self.navigationController!.popToViewController(vc, animated: true);
                                return
                            } else if(vc.isKind(of: HomeViewController.self)) {
                                self.navigationController!.popToViewController(vc, animated: true);
                                return
                            }
                        }
                    }, cancelButtonTitle: "OK")
                   
                }
                
                
            }
        }
        
    }
    
    
    
}
