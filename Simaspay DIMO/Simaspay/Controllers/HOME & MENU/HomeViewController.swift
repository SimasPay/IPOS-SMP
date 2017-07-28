//
//  HomeViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

//MARK: Account type
enum AccountType: Int {
    case accountTypeRegular = 0 //Bank
    case accountTypeLakuPandai  //Laku Pandai
    case accountTypeEMoneyKYC  //E-Money KYC
    case accountTypeEMoneyNonKYC //E-Money non KYC
}

class HomeViewController: BaseViewController, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, DIMOPayDelegate {
    
    @IBOutlet weak var lblViewMove: BaseLabel!
    @IBOutlet weak var lblBalance: BaseLabel!
    @IBOutlet var lblTypeHome: BaseLabel!
    @IBOutlet var lblUsername: BaseLabel!
    @IBOutlet var lblNoAccount: BaseLabel!
    @IBOutlet weak var btnSwitchAccount: UIButton!
    @IBOutlet weak var lblSwitchAccount: UILabel!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet var lblInitial: BaseLabel!
    
    var accountType : AccountType!
    var arrayMenu: NSArray!
    var qrInqueryDict = NSMutableDictionary()
    var noReqEmoney: Bool = true
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet weak var viewMove: UIView!
    @IBOutlet var collectionView: UICollectionView!
    var gradientLayer : CAGradientLayer!
    
    static var positionx:CGFloat = 0
    
    var viewMpin: UIView!
    var viewOtp: UIView!
    var lblMPin: BaseLabel!
    var tfMpin: BaseTextField!
    var tfOtp: BaseTextField!
    var btnNext: BaseButton!
    var btnOk: UIButton!
    var dictForRequestOTP = NSMutableDictionary()
    var dictConfirmation = NSMutableDictionary()
    var back: BaseButton!
    
    //Timer for OTP resend button
    var timerCount = 60
    var clock:Timer!
    var lblTimer: BaseLabel!
    var lblTitleOtp: BaseLabel!
    var MDNString:String! = ""
    var otpString:String! = ""
    var mPinString:String! = ""
    
    var alertController = UIAlertController()
    var imagePicker = UIImagePickerController()
   
    static func initWithOwnNib() -> HomeViewController {
        let obj:HomeViewController = HomeViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    static func initWithAccountType(_ type: AccountType) -> HomeViewController {
        let vc = HomeViewController.initWithOwnNib()
        vc.accountType = type
        return vc
    }
    
    static func initWithAccountTypeAndReqEmoney(_ type: AccountType, reqEmoney: Bool) -> HomeViewController {
        let vc = HomeViewController.initWithOwnNib()
        vc.accountType = type
        vc.noReqEmoney = reqEmoney
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblInitial.font = UIFont.boldSystemFont(ofSize: 33)
        lblInitial.textColor = UIColor.init(hexString: "ff7e1a")
        
        lblTypeHome.font = UIFont.systemFont(ofSize: 11)
        lblTypeHome.textColor = UIColor.init(hexString: color_greyish_brown)
        lblTypeHome.text = self.accountType == AccountType.accountTypeRegular ? "Bank Sinarmas": self.accountType == AccountType.accountTypeEMoneyKYC ? "E-money Plus": self.accountType == AccountType.accountTypeEMoneyNonKYC ? "E-money Regular": "Laku Pandai"
        
        
        lblUsername.font = UIFont.boldSystemFont(ofSize: 18)
        lblUsername.textColor = lblTypeHome.textColor
        lblUsername.textAlignment = .center
        lblUsername.text = UserDefault.objectFromUserDefaults(forKey: USERNAME) as! String?
        
        lblNoAccount.textColor = lblTypeHome.textColor
        lblNoAccount.font = lblTypeHome.font
        lblNoAccount.textAlignment = .center
        lblNoAccount.text = UserDefault.objectFromUserDefaults(forKey: ACCOUNT_NUMBER) as! String?
        lblBalance.textAlignment = .center
        
        imgUser.layer.cornerRadius = (imgUser.bounds.size.width / 2) as CGFloat
        imgUser.backgroundColor = UIColor.init(hexString: "AAAAAA")
        imgUser.clipsToBounds = true
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        let leftColor = UIColor.init(hexString: "FF262B").cgColor
        let rightColor = UIColor.init(hexString: "F7AE04").cgColor
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.viewMove.frame
        
        gradientLayer.colors = [leftColor,rightColor ]
        gradientLayer.startPoint = CGPoint(x: 0.0,y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.gradientLayer = gradientLayer
        self.viewMove.layer.insertSublayer(gradientLayer, at: 0)
        
        //Array of menu
        arrayMenu = [
            [
                "title" : "Daftar Transaksi",
                "icon" : "icon_Transaction",
                "action" : "",
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Transfer",
                "icon" : "icon_Transfer",
                "action" : ListTransferViewController.initWithOwnNib(),
                "disable" : self.accountType == AccountType.accountTypeEMoneyNonKYC
                    ? true : false,
                "isHidden": false
            ],
            [
                "title" : "Pembelian",
                "icon" : "icon_Payment",
                "action" : PaymentPurchaseViewController.initWithOwnNib(isPurchased: true),
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Pembayaran",
                "icon" : "icon_Purchase",
                "action" : PaymentPurchaseViewController.initWithOwnNib(isPurchased: false),
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Pay by QR",
                "icon" : "icon_Paybyqr",
                "action" : "",
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Promo Pay by QR",
                "icon" : "icon_Promo",
                "action" : "",
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Tarik Tunai",
                "icon" : "icon_drawal",
                "action" : ListCashWithDrawalController.initWithOwnNib(),
                "disable" : self.accountType == AccountType.accountTypeEMoneyNonKYC ? true : false,
                "isHidden": self.accountType ==  AccountType.accountTypeRegular ? true : false
            ],
            [
                "title" : "Ganti mPIN",
                "icon" : "icon_Changempin",
                "action" : ChangeMpinViewController.initWithOwnNib(),
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Daftar E-money",
                "icon" : "ic_daftaremoney",
                "action" : "",
                "disable" : noReqEmoney,
                "isHidden": noReqEmoney
            ]
        ]
        arrayMenu = arrayMenu.filtered(using: NSPredicate(format: "isHidden != TRUE")) as NSArray!
        self.btnSwitchAccount.isHidden = true
        self.lblSwitchAccount.isHidden = true
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: BankEMoneyViewController.self)) {
                self.btnSwitchAccount.isHidden = false
                self.lblSwitchAccount.isHidden = false
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let timer = SimasAPIManager.staticTimer()
        timer?.invalidate()
        
        lblViewMove.font = UIFont.systemFont(ofSize: 14)
        lblViewMove.textColor = UIColor.white
        lblViewMove.textAlignment = .center
        lblViewMove.text = getString("HomeTitleSliderBalace")
       
        let pocketCode = self.accountType == AccountType.accountTypeRegular ? "2": self.accountType == AccountType.accountTypeEMoneyKYC ? "1": self.accountType == AccountType.accountTypeEMoneyNonKYC ? "1": "6"
        SimasAPIManager.sharedInstance().sourcePocketCode = pocketCode
        
        if (UserDefault.objectFromUserDefaults(forKey: "imageProfil") != nil){
            let strBase64 = UserDefault.objectFromUserDefaults(forKey: "imageProfil") as! String
            let dataDecoded:NSData = NSData(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            self.imgUser.image = decodedimage
        } else {
            let name = UserDefault.objectFromUserDefaults(forKey: USERNAME) as! String
            let arrname = name.components(separatedBy: " ")
            var initial: String = ""
            if (arrname.count == 1) {
                let startIndex = name.startIndex
                initial = String(name[startIndex])
            } else if (arrname.count >= 2) {
                let strFirst = arrname[0]
                let startIndexFirst = strFirst.startIndex
                initial = String(strFirst[startIndexFirst])
                let strEnd = arrname[arrname.count - 1]
                let startIndexstrEnd = strEnd.startIndex
                initial += String(strEnd[startIndexstrEnd])
            }
            self.lblInitial.text = initial.uppercased()
        }
    }
    
    override func viewWillLayoutSubviews() {
        imgUser.layer.cornerRadius = (imgUser.bounds.size.width / 2) as CGFloat
        imgUser.backgroundColor = UIColor.init(hexString: "AAAAAA")
        imgUser.clipsToBounds = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = self.viewMove.frame
        frame.origin = CGPoint.zero
        self.gradientLayer.frame = frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Button logout account
    @IBAction func actionLogout(_ sender: Any) {
//        let prefs = UserDefaults.standard
//        prefs.removeObject(forKey: SOURCEMDN)
//        prefs.removeObject(forKey: ACCOUNT_NUMBER)
//        prefs.removeObject(forKey: USERNAME)
//        prefs.removeObject(forKey: GET_USER_API_KEY)
//        prefs.removeObject(forKey: mPin)
//        prefs.removeObject(forKey: "imageProfil")
//        prefs.removeObject(forKey: EULAPBQR)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            print(vc)
            if (vc.isKind(of: LoginPinViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            }
//            if (vc.isKind(of: LoginPinViewController.self)) {
//                self.navigationController!.popToViewController(vc, animated: true);
//                return
//            } else if (vc.isKind(of: LandingScreenViewController.self)) {
//                 self.navigationController!.popToViewController(vc, animated: true);
//                return
//            }
        }
        let vc = LandingScreenViewController(nibName: "LandingScreenViewController", bundle: nil)
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    // MARK: Button switch account
    @IBAction func actionSwitchAccount(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: BankEMoneyViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            }
        }
        
    }
    
    //MARK: Account balance animation
    @IBAction func drag(_ sender: AnyObject, event: UIEvent) {
        if let button = sender as? UIButton {
            // get the touch inside the button
            let touch = event.touches(for: btnMove)?.first
            // println the touch location
            let x = (touch?.location(in: button).x)! as CGFloat
            if (HomeViewController.positionx == 0) {
                
            } else {
                if x > HomeViewController.positionx {
                    // do right
                    let diff = x - HomeViewController.positionx
                    var frame = viewMove.frame
                    frame.origin.x += diff * 1.5
                    frame.origin.x = min(frame.origin.x, UIScreen.main.applicationFrame.size.width - 36)
                    viewMove.frame = frame
                    
                } else if (x < HomeViewController.positionx) {
                    var frame = viewMove.frame
                    let diff = HomeViewController.positionx - x
                    frame.origin.x -= diff * 1.5
                    frame.origin.x = max(frame.origin.x, 0)
                    viewMove.frame = frame
                }
            }
            HomeViewController.positionx = x
        }
    }
    
    @IBAction func touchDone(_ sender: AnyObject) {
        HomeViewController.positionx = 0
        if (viewMove.frame.origin.x >= UIScreen.main.applicationFrame.size.width / 2) {
            DLog("Stay")
            UIView.animate(withDuration: 0.3, animations: {
                var frame = self.viewMove.frame
                frame.origin.x = UIScreen.main.applicationFrame.size.width - 36
                self.viewMove.frame = frame
            }, completion: { (complete) in
                self.checkBalance()
            })
            
        } else {
            UIView.animate(withDuration: 0.3) {
                var frame = self.viewMove.frame
                frame.origin.x = 0
                self.viewMove.frame = frame
            }
        }
    }
    
    
    func close() {
        UIView.animate(withDuration: 0.3) {
            var frame = self.viewMove.frame
            frame.origin.x = 0
            self.viewMove.frame = frame
        }
        self.lblBalance.text = ""
    }
    
    //MARK: Fuction check balance
    func checkBalance() {
        
        var message = ""
        if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            self.close()
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_ACCOUNT_BALANCE
        dict[SERVICE] = SERVICE_WALLET
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = SimasAPIManager.sharedInstance().encryptedMPin as String!
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[BANK_ID] = ""
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
        SimasAPIManager.callAPI(withParameters: param) { (dict, err) in
            
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
                let messageText  = dictionary.value(forKeyPath: "message.text") as! String
                let messagecode  = dictionary.value(forKeyPath:"message.code") as! String
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                if let amount = responseDict["amount"] {
                    let amountText = (amount as! NSDictionary).value(forKey: "text") as! String
                    DLog("\(amountText)")
                    self.indicatorView.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.lblBalance.text = String(format: "Rp %@", amountText)
                    _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.close), userInfo: nil, repeats: false)
                } else if (messagecode == "631") {
                    self.close()
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    self.close()
                    SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
            }
            
        }
    }
    
    
    
    
    // MARK: Collection view for menu
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMenu.count
        ;
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        if !((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"isHidden")  as! Bool) {
            
            if (self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"disable") as! Bool {
                cell.alpha = 0.5
            } else {
                cell.alpha = 1
            }
            cell.backgroundColor = UIColor.white
            cell.updateIconRoundedWithShadow()
            
            
            let imgIcon = UIImageView(frame: CGRect(x: cell.frame.size.width/2 - 25 , y: cell.frame.size.height/2 - 35 , width: 50, height: 50))
            imgIcon.image = UIImage.init(named: "\(((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"icon") as! NSString) as String)")
            
            let lblIcon = BaseLabel(frame: CGRect(x: 0, y: imgIcon.frame.origin.y  + imgIcon.frame.size.width + 4 , width: cell.frame.size.width, height: 10))
            lblIcon.textAlignment = .center
            lblIcon.textColor = UIColor.black
            lblIcon.font = UIFont.systemFont(ofSize: 10)
            lblIcon.text = ((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"title") as! NSString) as String
            
            
            cell.addSubview(lblIcon)
            cell.addSubview(imgIcon)
            
        }
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let sizeRect = UIScreen.main.applicationFrame
        let width    = ((sizeRect.size.width - 16 * 4) / 3)
        return CGSize(width: width, height: width)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if !((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"disable")  as! Bool) {
            
            if ((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey: "title") as! String == "Pay by QR") {
                self.payBYQRBtnClicked()
            } else if ((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey: "title") as! String == "Promo Pay by QR") {
                self.promoBYQRBtnClicked()
            } else if ((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey: "title") as! String == "Daftar E-money") {
                self.registerEmoney()
            } else if ((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey: "title") as! String == "Daftar Transaksi") {
                
                if (self.accountType == AccountType.accountTypeEMoneyKYC || self.accountType == AccountType.accountTypeEMoneyNonKYC) {
                    UserDefault.setObject(true, forKey: "firstCall")
                    let vc = TransactionPeriodViewController.initWithOwnNib()
                    self.navigationController?.pushViewController(vc as UIViewController, animated: true)
                } else{
                    let vc = TransactionHistoryViewController.initWithOwnNib()
                    self.navigationController?.pushViewController(vc as UIViewController, animated: true)
                }
            } else {
                DLog("\(((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"title") as! NSString) as String)")
                let vc = (self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"action")
                self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
            }
        } else {
            
        }
    }
    
    //MARK: Unused
    func setupMenu() {
        var column = 1
        var row = 1
        let size = 85
        let padding = 16
        let lblHeight = 21
        
        var width = size * 3 + padding * 2
        let height = size + padding + lblHeight
        if (self.arrayMenu.count >= 4) {
            row = 2;
            if (self.arrayMenu.count == 4) {
                column = 2;
                width = size * 2 + padding
            } else {
                column = 3;
            }
        } else {
            column = self.arrayMenu.count
            if (self.arrayMenu.count == 2) {
                width = size * 2 + padding
            }
        }
        
        
        let container = UIView()
        var y = 0
        for i in 0  ..< row  {
            for j in 0 ..< column {
                let index = i * column + j
                if (index < self.arrayMenu.count) {
                    _ = self.arrayMenu[index]
                    var x = j * (size + padding)
                    y = i * (height + padding)
                    
                    if (self.arrayMenu.count == 5 && i == 1) {
                        // for 5 items
                        x += (size + padding) / 2
                    }
                    
                    let temp = UIView(frame: CGRect(x: x, y: y, width: size, height: height))
                    temp.backgroundColor = UIColor.black
                    
                    container.addSubview(temp)
                }
            }
        }
        y += height
        container.frame = CGRect(x: 0, y: 0, width: width, height: y)
        container.backgroundColor = UIColor.yellow
        container.center = view.center
        view.addSubview(container)
    }
    
    func generateUserkey(){
        var message = ""
        if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }

        if (UserDefault.objectFromUserDefaults(forKey: GET_USER_API_KEY) != nil) {
            let key = UserDefault.objectFromUserDefaults(forKey: GET_USER_API_KEY) as! NSString
            DIMOPay.setUserAPIKey(key as String!)
        } else {
            let dict = NSMutableDictionary()
            
            dict[SERVICE] = SERVICE_ACCOUNT
            dict[TXNNAME] = GET_USER_API_KEY
            dict[INSTITUTION_ID] = SIMASPAY
            dict[AUTH_KEY] = ""
            dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
            
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
                    if ( messagecode == GENERATE_API_KEY_SUCCESS_CODE ){
                        let userAPIKeyText  = responseDict.value(forKeyPath: "userAPIKey.text") as! String
                        UserDefault.setObject(userAPIKeyText, forKey: GET_USER_API_KEY)
                        DIMOPay.setUserAPIKey(userAPIKeyText)
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
    }
    
    func payInvoice(invoiceId:NSString, amount:Double, discountedAmount:Double,merchantName:NSString,nbOfCoupons:Int32,discountType:NSString,loyaltyProgramName:NSString,amountOfDiscount:Double,tippingAmount:Double,pointsRedeemed:Int,amountRedeemed:Int){
        let number1: Int32 = nbOfCoupons
        let numberOfCoupons = Int(number1)
      
        qrInqueryDict["invoiceId"] = invoiceId
        qrInqueryDict["amount"] = amount
        qrInqueryDict["discountedAmount"] = discountedAmount
        qrInqueryDict["merchantName"] = merchantName
        qrInqueryDict["nbOfCoupons"] = numberOfCoupons
        qrInqueryDict["discountType"] = discountType
        qrInqueryDict["loyaltyProgramName"] = loyaltyProgramName
        qrInqueryDict["amountOfDiscount"] = amountOfDiscount
        qrInqueryDict["tippingAmount"] = tippingAmount
        qrInqueryDict["pointsRedeemed"] = pointsRedeemed
        qrInqueryDict["amountRedeemed"] = amountRedeemed
        
        DLog("\(qrInqueryDict)")
        
        let window = UIApplication.shared.keyWindow!
        viewMpin = UIView()
        viewMpin.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        viewMpin.backgroundColor = UIColor.init(hexString: "F3F3F3")
        let navigation = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: 65))
        navigation.backgroundColor = UIColor.init(hexString: color_btn_red)
        var lblTitle: BaseLabel!
        lblTitle = BaseLabel()
        lblTitle.textColor = UIColor.white
        lblTitle.frame = CGRect(x: 0, y: 20, width:SimasUtility.screenSize().width, height: 44)
        lblTitle.textAlignment = .center
        lblTitle.text = "Masukan mPin"
        back = BaseButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        back.setImage(UIImage(named: "go_back_arrow"), for: UIControlState())
        back.imageEdgeInsets = UIEdgeInsetsMake(14,14,14,14)
        back.addTarget(self, action: #selector(self.actionBack), for: UIControlEvents.touchUpInside)
        navigation.addSubview(back)
        navigation.addSubview(lblTitle)
        
        let main = UIView(frame: CGRect(x: 0, y: 65, width: window.frame.width, height: window.frame.height - 65))
        main.backgroundColor = UIColor.clear
        lblMPin = BaseLabel()
        lblMPin.frame = CGRect(x: 28, y: 25, width: window.frame.width - 56, height: 17)
        tfMpin = BaseTextField()
        tfMpin.frame = CGRect(x: 28, y: 52, width: window.frame.width - 56, height: 40)
        btnNext = BaseButton()
        btnNext.frame = CGRect(x: 90, y: 130, width: window.frame.width - 180, height: 40)
        
        lblMPin.font = UIFont.boldSystemFont(ofSize: 13)
        lblMPin.text = getString("TransferLebelMPIN")
        tfMpin.font = UIFont.systemFont(ofSize: 14)
        tfMpin.backgroundColor = UIColor.white
        tfMpin.addInset()
        tfMpin.keyboardType = UIKeyboardType.numberPad
        tfMpin.tag = 7
        tfMpin.isSecureTextEntry = true
        tfMpin.delegate = self

        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        btnNext.addTarget(self, action: #selector(self.actionNext) , for: .touchUpInside)
        
        main.addSubview(lblMPin)
        main.addSubview(tfMpin)
        main.addSubview(btnNext)

        viewMpin.addSubview(navigation)
        viewMpin.addSubview(main)
        window.addSubview(viewMpin)
        tfMpin.becomeFirstResponder()
    }
    
    func actionBack() {
        DIMOPay.closeSDK()
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
             self.viewMpin.removeFromSuperview()
        }
       
    }
    
    func payBYQRBtnClicked() {
        self.initSDKPayQR()
        DIMOPay.startSDK(self, with: self)
    }
    
    func initSDKPayQR() {
        DIMOPay.setServerURL(ServerURLDev)
        DIMOPay.setMinimumTransaction(1000)
        if (UserDefault.objectFromUserDefaults(forKey: EULAPBQR) == nil) {
            DIMOPay.setEULAState(false)
        } else {
           DIMOPay.setEULAState(true)
        }
        
    }
    
    func promoBYQRBtnClicked() {
        self.initSDKPayQR()
        DIMOPay.startLoyalty(self, with: self)
    }
    
    
    /// This function will be called when authentication error page appear
    func callbackAuthenticationError() {
        
    }
    
    /// Return true to close sdk
    /// This function will be called when unknown error page appear
    func callbackUnknowError() -> Bool {
        return false
    }
    
    /// Return true to close sdk
    /// This function will be called when payment failed error page appear
    func callbackTransactionStatus(_ paymentStatus: PaymentStatus, withMessage message: String!) -> Bool {
        if (paymentStatus == PaymentStatusSuccess) {
            return true
        } else {
            return false
        }
    }
    
    /// Return true to close sdk
    /// This function will be called when invalid qr code error page appear
    func callbackInvalidQRCode() -> Bool {
         return false
    }
    
    /// This function will be called when lost internet connection error page appear
    func callbackLostConnection() {
        
    }
    
    /// This function will be called when the sdk has been closed
    func callbackSDKClosed() {
       
    }
    
    /// This function will be called when isUsingCustomDialog is Yes, and host-app need to show their own dialog
    func callbackShowDialog(_ paymentStatus: PaymentStatus, withMessage message: String!, andLoyaltyModel fidelitiz: DIMOFidelitizModel!) {
   
    }
    
    /// This function will be called when user clicked pay button and host-app need to doing payment here
    func callbackPayInvoice(_ invoice: DIMOInvoiceModel!) {
            payInvoice(invoiceId: invoice.invoiceId! as NSString, amount: invoice.originalAmount, discountedAmount: invoice.paidAmount, merchantName: invoice.merchantName! as NSString, nbOfCoupons: invoice.numberOfCoupons, discountType: invoice.discountType! as NSString, loyaltyProgramName: invoice.loyaltyProgramName! as NSString, amountOfDiscount: invoice.amountOfDiscount, tippingAmount: invoice.tipAmount, pointsRedeemed: 0, amountRedeemed: 0)
    }
    
    /// This function will be called when user cancel process payment or close invoice summary
    func callbackUserHasCancelTransaction() {
        
    }
    
    /// This function will be called when the SDK opened at the first time or there is no user api key found
    func callbackGenerateUserAPIKey() {
        self.generateUserkey()
    }
    
    /// This function will be called when the EULA state changed
    func callbackEULAStateChanged(_ state: Bool) {
        if (!state) {
            UserDefault.setObject(false, forKey: EULAPBQR)
        }
    }
    
    /// This function will be called when EULA state is false
    /// Return view controller, there is a standard view controller for eula or using your own EULA view controller
    /// example : [DIMOPay EULAWithStringHTML:@"test<br>Test2"];
    @available(iOS 2.0, *)
    func callbackShowEULA() -> UIViewController! {
        UserDefault.setObject(false, forKey: EULAPBQR)
        return DIMOPay.eula(withURL: "")
        // return DIMOPay.eula(withStringHTML: EulaTermsText)
    }
    
    func nextProses() {
        self.tfMpin.resignFirstResponder()
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_PAYMENT
        dict[TXNNAME] = TXN_QR_PAYMENT_INQUIRY
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
        dict[BILLERCODE] = QRFLASHIZ
        dict[BILLNO] = self.qrInqueryDict.object(forKey: "invoiceId")
        dict[PAYMENT_MODE] = QR_PAYMENT
        dict[AMOUNT] = self.qrInqueryDict.object(forKey: "amount")
        dict[MERCHANT_DATA] = self.qrInqueryDict.object(forKey: "merchantName")
        dict[USER_API_KEY] = UserDefault.objectFromUserDefaults(forKey: GET_USER_API_KEY)
        dict[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
        dict[DISCOUNT_AMOUNT] = self.qrInqueryDict.object(forKey: "amountOfDiscount")
        dict[LOYALITY_NAME] = self.qrInqueryDict.object(forKey: "loyaltyProgramName")
        dict[DISCOUNT_TYPE] = self.qrInqueryDict.object(forKey: "discountType")
        dict[NUMBER_OF_COUPONS] = self.qrInqueryDict.object(forKey: "nbOfCoupons")
        dict[POINTS_OF_REDEEMED] = self.qrInqueryDict.object(forKey: "pointsRedeemed")
        dict[AMOUNT_REDEEMED] = self.qrInqueryDict.object(forKey: "amountRedeemed")
        dict[TIPPING_AMOUNT] = self.qrInqueryDict.object(forKey: "tippingAmount")
        DMBProgressHUD.showAdded(to: self.viewMpin, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
        SimasAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD.hide(for: self.viewMpin, animated: true)
            // DMBProgressHUD .hideAllHUDs(for: self.viewMpin, animated: true)
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
                if ( messagecode == QR_INQUIRY_SUCCESS_CODE ) {
                    // request otp data
                    self.dictForRequestOTP[TXNNAME] = TXN_RESEND_MFAOTP
                    self.dictForRequestOTP[SERVICE] = SERVICE_WALLET
                    self.dictForRequestOTP[INSTITUTION_ID] = SIMASPAY
                    self.dictForRequestOTP[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    self.dictForRequestOTP[SOURCEPIN] = simasPayRSAencryption(self.tfMpin.text!)
                    self.dictForRequestOTP[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    self.dictForRequestOTP[CHANNEL_ID] = CHANNEL_ID_VALUE
                    self.dictForRequestOTP[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
                    self.dictForRequestOTP[AUTH_KEY] = ""
                    
                    // confirmation data
                    self.dictConfirmation[SERVICE] = SERVICE_PAYMENT
                    self.dictConfirmation[TXNNAME] = TXN_QR_PAYMENT_CONFIRMATION
                    self.dictConfirmation[INSTITUTION_ID] = SIMASPAY
                    self.dictConfirmation[AUTH_KEY] = ""
                    self.dictConfirmation[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    self.dictConfirmation[BILLERCODE] = QRFLASHIZ
                    self.dictConfirmation[BILLNO] = self.qrInqueryDict.object(forKey: "invoiceId")
                    self.dictConfirmation[PAYMENT_MODE] = QR_PAYMENT
                    self.dictConfirmation[MERCHANT_DATA] = self.qrInqueryDict.object(forKey: "merchantName")
                    self.dictConfirmation[USER_API_KEY] = UserDefault.objectFromUserDefaults(forKey: GET_USER_API_KEY)
                    self.dictConfirmation[SOURCEPOCKETCODE] = SimasAPIManager.sharedInstance().sourcePocketCode as String
                    self.dictConfirmation[DISCOUNT_AMOUNT] = self.qrInqueryDict.object(forKey: "amountOfDiscount")
                    self.dictConfirmation[LOYALITY_NAME] = self.qrInqueryDict.object(forKey: "loyaltyProgramName")
                    self.dictConfirmation[DISCOUNT_TYPE] = self.qrInqueryDict.object(forKey: "discountType")
                    self.dictConfirmation[NUMBER_OF_COUPONS] = self.qrInqueryDict.object(forKey: "nbOfCoupons")
                    self.dictConfirmation[POINTS_OF_REDEEMED] = self.qrInqueryDict.object(forKey: "pointsRedeemed")
                    self.dictConfirmation[AMOUNT_REDEEMED] = self.qrInqueryDict.object(forKey: "amountRedeemed")
                    self.dictConfirmation[TIPPING_AMOUNT] = self.qrInqueryDict.object(forKey: "tippingAmount")
                    self.dictConfirmation[TRANSFERID] = responseDict.value(forKeyPath: "transferID.text")
                    self.dictConfirmation[PARENTTXNID] = responseDict.value(forKeyPath: "parentTxnID.text")
                    self.dictConfirmation[CONFIRMED] = "true"
                    
                    self.requestOTP()
                   
                    
                } else if (messagecode == "631") {
                    DIMOPay.closeSDK()
                    self.viewMpin.removeFromSuperview()
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
    
    
    
    func actionNext() {
        var message = "";
        if (!tfMpin.isValid()){
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

        self.nextProses()
        // v.removeFromSuperview()
    }
    
    //MARK: Action button for OTP alert
    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()
        viewOtp.removeFromSuperview()
        
    }
    
    func didOTPOK() {
        DLog("OK");
        clock.invalidate()
        self.sendOTP()
    }
    
    
    //MARK: Show OTP Alert
    func showOTP()  {
        timerCount = 60
        
        let window = UIApplication.shared.keyWindow!
        viewOtp = UIView()
        viewOtp.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        viewOtp.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let viewContent = UIView(frame: CGRect(x: 28, y: 100, width: window.frame.width - 56, height: 210))
        viewContent.backgroundColor = UIColor.init(hexString: "F3F3F3")
        viewContent.layer.cornerRadius = 15.0
        
        lblTitleOtp = BaseLabel(frame: CGRect(x: 0, y: 10, width: window.frame.width - 56, height: 40))
        lblTitleOtp.textColor = UIColor.black
        lblTitleOtp.textAlignment = .center
        lblTitleOtp.font = UIFont.boldSystemFont(ofSize: 16)
        lblTitleOtp.text = "Masukan Kode OTP"
        let temp = UIView(frame: CGRect(x: 0, y: lblTitleOtp.bounds.origin.y + lblTitleOtp.bounds.size.height, width: window.frame.width - 56 , height: 170))
        let MDNString = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        let messageString = String(format: getString("ConfirmationOTPMessage"), MDNString)
        let messageAlert = UILabel(frame: CGRect(x: 10, y: 10, width: temp.frame.size.width - 20, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = messageString as String

        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)

        lblTimer = BaseLabel(frame: CGRect(x: 0, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 10, width: temp.frame.size.width, height: 15))
        lblTimer.textAlignment = .center
        lblTimer.font = UIFont.systemFont(ofSize: 12)
        lblTimer.text = "01:00"
        
        tfOtp = BaseTextField(frame: CGRect(x: 10, y: 90, width: temp.frame.size.width - 20, height: 30))
        tfOtp.font = UIFont.systemFont(ofSize: 14)
        tfOtp.backgroundColor = UIColor.white
        tfOtp.addInset()
        tfOtp.isSecureTextEntry = true
        tfOtp.keyboardType = UIKeyboardType.numberPad
        tfOtp.tag = 10
        tfOtp.placeholder = "4 digit kode OTP"
        tfOtp.delegate = self
        tfOtp.layer.borderColor = UIColor.init(hexString: "999999").cgColor
        tfOtp.layer.borderWidth = 1.0
        
        let border = UIView(frame: CGRect(x: 0, y: 130, width: temp.frame.size.width, height: 1))
        border.backgroundColor = UIColor.init(hexString: "CCCCCC")
        
        let widthTemp = temp.frame.size.width
        
        let btnCancel = UIButton(frame: CGRect(x: 0, y: 131 , width: (widthTemp/2) - 0.5, height: 40))
        btnCancel.setTitle("Cancel", for: UIControlState.normal)
        btnCancel.setTitleColor(UIColor.init(hexString: "0080FF"), for: UIControlState.normal)
        btnCancel.isUserInteractionEnabled = true
        
        let lineBorder = UIView(frame: CGRect(x: (widthTemp/2) - 0.5, y: 130, width: 1, height: 40))
        lineBorder.backgroundColor = UIColor.init(hexString: "CCCCCC")
        btnOk = UIButton(frame: CGRect(x: (widthTemp/2) + 0.5, y: 131 , width: (widthTemp/2) + 0.5, height: 40))
        btnOk.setTitle("Ok", for: UIControlState.normal)
        // btnOk.isEnabled = false
        btnOk.setTitleColor(UIColor.init(hexString: "0080FF"), for: UIControlState.normal)
        btnOk.setTitleColor(UIColor.init(hexString: "AAAAAA"), for: UIControlState.disabled)
        btnOk.isEnabled = false
        
        btnCancel.addTarget(self, action: #selector(self.didOTPCancel), for: .touchUpInside)
        btnOk.addTarget(self, action: #selector(self.didOTPOK), for: .touchUpInside)
        
        temp.addSubview(border)
        temp.addSubview(messageAlert)
        temp.addSubview(lblTimer)
        temp.addSubview(tfOtp)
        temp.addSubview(lineBorder)
        temp.addSubview(btnCancel)
        temp.addSubview(btnOk)
        
        viewContent.addSubview(lblTitleOtp)
        viewContent.addSubview(temp)
        
        viewOtp.addSubview(viewContent)
        window.addSubview(viewOtp)
        
//        let when = DispatchTime.now() + 0.25 // change 2 to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
           self.tfOtp.becomeFirstResponder()
       // }
    }
    
    //MARK: Request OTP
    func requestOTP() {
        DLog("\(self.dictForRequestOTP)")
        DMBProgressHUD.showAdded(to: self.viewMpin, animated: true)
        SimasAPIManager .callAPI(withParameters: self.dictForRequestOTP as! [AnyHashable : Any] ) { (dict, err) in
            DMBProgressHUD.hideAllHUDs(for: self.viewMpin, animated: true)
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
                
                if messagecode == "2171" {
                    self.showOTP()
                } else {
                    SimasAlertView.showAlert(withTitle: nil, message:messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
            }
        }
    }
    
    //MARK: Send OTP
    func sendOTP() {
        self.viewOtp.removeFromSuperview()
        var message = ""
        if (!SimasAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        self.dictConfirmation[MFAOTP] = simasPayRSAencryption(self.tfOtp.text!)
        DMBProgressHUD.showAdded(to: self.viewMpin, animated: true)
        
        var sessionCheck = false
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: HomeViewController.self)) {
                sessionCheck = true
                
            }
        }
        DLog("\(self.dictConfirmation)")
        
        SimasAPIManager .callAPI(withParameters: self.dictConfirmation as! [AnyHashable : Any], withSessionCheck:sessionCheck) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.viewMpin, animated: true)
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
                
                self.viewMpin.removeFromSuperview()
                if (messagecode == QR_SUCCESS_CODE) {
                    DIMOPay.notifyTransaction(PaymentStatusSuccess, withMessage: "Berhasil melakukan pembayaran dengan Qr Code", isDefaultLayout: true)
                } else if (messagecode == "631") {
                    DIMOPay.closeSDK()
                    self.viewMpin.removeFromSuperview()
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    DIMOPay.notifyTransaction(PaymentStatusFailed, withMessage: messageText, isDefaultLayout: true)
                }
                
                
            }
        }
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 10 {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            self.otpString = newString as String!
            btnOk.isEnabled = newString.length >= 4
            return newString.length <= maxLength
        } else if textField.tag == 7 {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            self.mPinString = newString as String!
            return newString.length <= maxLength
        } else {
            return true
        }
    }
    
    
    func countDown(){
        if (timerCount > 0) {
            timerCount -= 1
            lblTimer.text = "00:\(timerCount)"
        } else {
            self.viewOtp.removeFromSuperview()
            SimasAlertView.showAlert(withTitle: getString("titleEndOtp"), message: getString("messageEndOtp"), cancelButtonTitle: getString("AlertCloseButtonText"))
            clock.invalidate()
        }
    }
    
    
    //MARK: Register e-money from bank
    
    func registerEmoney() {
        let dict = NSMutableDictionary()

        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_INQUIRY_SUB
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
        
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
                if ( messagecode == SIMASPAY_POKET_ADDING_INQUIRY_SUCCES){
                    let vc = ConfirmationViewController.initWithOwnNib()
                    let dictOtp = NSMutableDictionary()
                    dictOtp[TXNNAME] = TXN_RESEND_MFAOTP
                    dictOtp[SERVICE] = SERVICE_WALLET
                    dictOtp[INSTITUTION_ID] = SIMASPAY
                    dictOtp[SOURCEMDN] =  getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    dictOtp[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
                    dictOtp[AUTH_KEY] = ""
                    
                    vc.dictForRequestOTP = dictOtp as NSDictionary
                 
                    
                    vc.MDNString = UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! String
                    let dictSendOtp = NSMutableDictionary()
               
                    dictSendOtp[SERVICE] = SERVICE_ACCOUNT
                    dictSendOtp[TXNNAME] = TXN_CONFIRM_SUB
                    dictSendOtp[INSTITUTION_ID] = SIMASPAY
                    dictSendOtp[AUTH_KEY] = ""
                    dictSendOtp[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
                    dictSendOtp[SCTL_ID] = responseDict.value(forKeyPath: "sctlID.text") as! String
                    
                    vc.dictForAcceptedOTP = dictSendOtp
                    vc.isRegister = true
                    
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
    
    @IBAction func actionChangePictureUser(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            let imageData:NSData = UIImageJPEGRepresentation(image, 0.5)! as NSData
            let strBase64 = imageData.base64EncodedString()
            
            let dict = NSMutableDictionary()
            dict[SERVICE] = SERVICE_ACCOUNT
            dict[TXNNAME] = TXN_UPDATE_PROFILE
            dict[INSTITUTION_ID] = SIMASPAY
            dict[AUTH_KEY] = ""
            dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
            dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: mPin) as! String)
            dict[PROFIL_IMAGE_STRING] = strBase64
            
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
                    if ( messagecode == SIMAPAY_SUCCESS_CHANGEPIN_PICTURE){
                        self.imgUser.image = image
                        self.lblInitial.text=""
                        UserDefault.setObject(strBase64, forKey: "imageProfil")
//                        print(strBase64)
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
