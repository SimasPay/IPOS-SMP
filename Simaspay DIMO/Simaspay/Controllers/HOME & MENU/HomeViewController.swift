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

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DIMOPayDelegate {
    
    @IBOutlet weak var lblViewMove: BaseLabel!
    @IBOutlet weak var lblBalance: BaseLabel!
    @IBOutlet var lblTypeHome: BaseLabel!
    @IBOutlet var lblUsername: BaseLabel!
    @IBOutlet var lblNoAccount: BaseLabel!
    @IBOutlet weak var btnSwitchAccount: UIButton!
     @IBOutlet weak var lblSwitchAccount: UILabel!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    var accountType : AccountType!
    var arrayMenu: NSArray!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet weak var viewMove: UIView!
    @IBOutlet var collectionView: UICollectionView!
    var gradientLayer : CAGradientLayer!
    
    
    static var positionx:CGFloat = 0
   
    static func initWithOwnNib() -> HomeViewController {
        let obj:HomeViewController = HomeViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    static func initWithAccountType(_ type: AccountType) -> HomeViewController {
        let vc = HomeViewController.initWithOwnNib()
        vc.accountType = type
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        imgUser.backgroundColor = UIColor.black
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
        DIMOAPIManager.sharedInstance().sourcePocketCode =  self.accountType == AccountType.accountTypeRegular ? "2": self.accountType == AccountType.accountTypeEMoneyKYC ? "1": self.accountType == AccountType.accountTypeEMoneyNonKYC ? "1": "6"
        
        //Array of menu
        arrayMenu = [
            [
                "title" : "Daftar Transaksi",
                "icon" : "icon_Transaction",
                "action" :self.accountType == AccountType.accountTypeEMoneyKYC ? TransactionPeriodViewController.initWithOwnNib() : self.accountType == AccountType.accountTypeEMoneyNonKYC ? TransactionPeriodViewController.initWithOwnNib():self.accountType == AccountType.accountTypeRegular ? TransactionHistoryViewController.initWithOwnNib() :TransactionHistoryViewController.initWithOwnNib(),
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
                "action" : TransactionHistoryViewController.initWithOwnNib(),
                "disable" : false,
                "isHidden": false
            ],
            [
                "title" : "Promo Pay by QR",
                "icon" : "icon_Promo",
                "action" : TransactionHistoryViewController.initWithOwnNib(),
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
        let timer = DIMOAPIManager.staticTimer()
        timer?.invalidate()
        
        lblViewMove.font = UIFont.systemFont(ofSize: 14)
        lblViewMove.textColor = UIColor.white
        lblViewMove.textAlignment = .center
        lblViewMove.text = getString("HomeTitleSliderBalace")
        
    }
    override func viewWillLayoutSubviews() {
        imgUser.layer.cornerRadius = (imgUser.bounds.size.width / 2) as CGFloat
        imgUser.backgroundColor = UIColor.black
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
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: SOURCEMDN)
        prefs.removeObject(forKey: ACCOUNT_NUMBER)
        prefs.removeObject(forKey: USERNAME)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            print(vc)
            if (vc.isKind(of: LoginRegisterViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            } else if (vc.isKind(of: LandingScreenViewController.self)) {
                 self.navigationController!.popToViewController(vc, animated: true);
                return
            }
        }
        let vc = LoginRegisterViewController(nibName: "LoginRegisterViewController", bundle: nil)
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
        if (!DIMOAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            self.close()
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_ACCOUNT_BALANCE
        dict[SERVICE] = SERVICE_WALLET
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = DIMOAPIManager.sharedInstance().encryptedMPin as String!
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[BANK_ID] = ""
        dict[SOURCEPOCKETCODE] = DIMOAPIManager.sharedInstance().sourcePocketCode as String
        
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            
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
                    DIMOAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    self.close()
                    DIMOAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
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
            DLog("\(((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"title") as! NSString) as String)")
            let vc = (self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"action")
            self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
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
        
    }
    
    func payBYQRBtnClicked() {
        flashizInitSDK()
        DIMOPay.startSDK(self, with: self)
    }
    
    
    func flashizInitSDK()
    {
        DIMOPay.setServerURL(ServerURLDev)
        DIMOPay.setIsPolling(false)
        DIMOPay.setMinimumTransaction(1000)
        
    }
    
    /// This function will be called when authentication error page appear
    func callbackAuthenticationError() {
        
    }
    
    /// Return true to close sdk
    /// This function will be called when unknown error page appear
    func callbackUnknowError() -> Bool {
        return true
    }
    
    /// Return true to close sdk
    /// This function will be called when payment failed error page appear
    func callbackTransactionStatus(_ paymentStatus: PaymentStatus, withMessage message: String!) -> Bool {
         return true
    }
    
    /// Return true to close sdk
    /// This function will be called when invalid qr code error page appear
    func callbackInvalidQRCode() -> Bool {
         return true
    }
    
    /// This function will be called when lost internet connection error page appear
    func callbackLostConnection() {
        
    }
    
    /// This function will be called when the sdk has been closed
    func callbackSDKClosed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// This function will be called when isUsingCustomDialog is Yes, and host-app need to show their own dialog
    func callbackShowDialog(_ paymentStatus: PaymentStatus, withMessage message: String!, andLoyaltyModel fidelitiz: DIMOFidelitizModel!) {
        
    }
    
    /// This function will be called when user clicked pay button and host-app need to doing payment here
    func callbackPayInvoice(_ invoice: DIMOInvoiceModel!) {
        
    }
    
    /// This function will be called when user cancel process payment or close invoice summary
    func callbackUserHasCancelTransaction() {
        
    }
    
    /// This function will be called when the SDK opened at the first time or there is no user api key found
    func callbackGenerateUserAPIKey() {
        // self.generateKey()
    }
    
    /// This function will be called when the EULA state changed
    func callbackEULAStateChanged(_ state: Bool) {
        
    }
    
    /// This function will be called when EULA state is false
    /// Return view controller, there is a standard view controller for eula or using your own EULA view controller
    /// example : [DIMOPay EULAWithStringHTML:@"test<br>Test2"];
    @available(iOS 2.0, *)
    func callbackShowEULA() -> UIViewController! {
        return DIMOPay.eula(withStringHTML: EulaTermsText)
    }
}
