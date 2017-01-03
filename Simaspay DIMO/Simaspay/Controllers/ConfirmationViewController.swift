//
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/4/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController,UIAlertViewDelegate {
    @IBOutlet var viewContentConfirmation: UIView!
    @IBOutlet var btnTrue: BaseButton!
    @IBOutlet var btnFalse: BaseButton!
    @IBOutlet var constraintViewContent: NSLayoutConstraint!

    var timerCount = 60
    var clock:Timer!
    var lblTimer: BaseLabel!
    var btnResandOTP: BaseButton!
    var tfOTP: BaseTextField!
    var MDNString:String!
    var data: NSDictionary!
    var dictForRequestOTP: NSDictionary!
    var dictForAcceptedOTP: NSDictionary!
    
    static func initWithOwnNib() -> ConfirmationViewController {
        let obj:ConfirmationViewController = ConfirmationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Konfirmasi")
        self.showBackButton()
        self.view.backgroundColor = UIColor.init(hexString: color_background)

        DLog("\(data)")
        self.viewContentConfirmation.layer.cornerRadius = 5.0;
        self.viewContentConfirmation.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewContentConfirmation.layer.borderWidth = 0.5
        self.viewContentConfirmation.clipsToBounds = true;
        
        
        self.btnTrue.updateButtonType1()
        self.btnTrue.setTitle("Benar", for: .normal)
        self.btnFalse.updateButtonType3()
        self.btnFalse.setTitle("Salah", for: .normal)
        btnTrue.addTarget(self, action: #selector(ConfirmationViewController.buttonStatus) , for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPCancel), name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPOK), name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let padding:CGFloat = 16
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width - 2 * 25
        let heightContent:CGFloat = 15
        let heightTitleContent:CGFloat = 15
        let margin:CGFloat = 10
        var y:CGFloat = 16
        
        
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
        let height = y + margin
        self.constraintViewContent.constant = height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonStatus()  {
        self.requestOTP()
        self.showOTP()
    }
    
    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()
    
    }

    
        func didOTPOK() {
            DLog("OK");
            clock.invalidate()
            self.sendOTP(OTP: self.tfOTP.text!)
            return
            let vc = ActivationSuccessViewController.initWithOwnNib()
            navigationController?.pushViewController(vc, animated: false)
        }
    
        func showOTP()  {
            let temp = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 400))
            let messageAlert = UILabel(frame: CGRect(x: 10, y: 0, width: temp.frame.size.width, height: 60))
            messageAlert.font = UIFont.systemFont(ofSize: 13)
            messageAlert.textAlignment = .center
            messageAlert.numberOfLines = 4
            messageAlert.text = "Kode OTP dan link telah dikirimkan ke nomor 08881234567. Masukkan kode tersebut atau akses link yang tersedia."
    
            clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ActivationPinViewController.countDown), userInfo: nil, repeats: true)
    
            btnResandOTP = BaseButton(frame: CGRect(x: 10, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 3, width: temp.frame.size.width, height: 15))
            btnResandOTP.setTitle("Kirim Ulang", for: .normal)
            btnResandOTP.setTitleColor(UIColor.init(hexString: color_btn_alert), for: .normal)
            btnResandOTP.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            btnResandOTP.titleLabel?.textAlignment = .center
            btnResandOTP.addTarget(self, action: #selector(ActivationPinViewController.resendOTP), for: .touchUpInside)
            btnResandOTP.isHidden = true
    
            lblTimer = BaseLabel(frame: CGRect(x: 10, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 3, width: temp.frame.size.width, height: 15))
            lblTimer.textAlignment = .center
            lblTimer.font = UIFont.systemFont(ofSize: 12)
            lblTimer.text = "01:00"
    
    
            tfOTP = BaseTextField(frame: CGRect(x: 10, y: lblTimer.frame.origin.y + lblTimer.frame.size.height + 3, width: temp.frame.size.width, height: 30))
            tfOTP.borderStyle = .line
            tfOTP.layer.borderColor = UIColor.init(hexString: color_border).cgColor
            tfOTP.layer.borderWidth = 1;
            tfOTP.placeholder = "6 digit kode OTP"
            tfOTP.isSecureTextEntry = true
            tfOTP.addInset()
    
            temp.addSubview(btnResandOTP)
            temp.addSubview(lblTimer)
            temp.addSubview(messageAlert)
            temp.addSubview(tfOTP)
    
            showOTPWith(title: "Masukkan Kode OTP", view: temp)
        }
        func countDown(){
            if (timerCount > 0) {
                timerCount -= 1
                lblTimer.text = "00:\(timerCount)"
            } else {
                lblTimer.isHidden = true
                btnResandOTP.isHidden = false
            }
        }
        func resendOTP()  {
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ActivationPinViewController.countDown), userInfo: nil, repeats: true)
        
        }
    func requestOTP() {
        DIMOAPIManager .callAPI(withParameters: dictForRequestOTP as! [AnyHashable : Any]!) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            
            
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                print(responseDict)
                
                
            }
        }
    }
    
    func sendOTP(OTP: String) {
        let dict = NSMutableDictionary()
        dict["otp"] = OTP
        let temp = NSMutableDictionary(dictionary: dict);
        temp .addEntries(from: dictForAcceptedOTP as! [AnyHashable : Any])
        dictForAcceptedOTP = temp as NSDictionary
        
        DIMOAPIManager .callAPI(withParameters: dictForAcceptedOTP as! [AnyHashable : Any]!) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            let dictionary = NSDictionary(dictionary: dict!)
            
            
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                print(responseDict)
                
                
            }
        }

    }



}
