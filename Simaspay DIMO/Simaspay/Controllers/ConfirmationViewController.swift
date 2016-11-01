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

    var data: NSDictionary!
    var tfOTP: BaseTextField!
    static func initWithOwnNib() -> ConfirmationViewController {
        let obj:ConfirmationViewController = ConfirmationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Konfirmasi")
        self.showBackButton()
        self.view.backgroundColor = UIColor.init(hexString: color_background)

        
        self.viewContentConfirmation.layer.cornerRadius = 5.0;
        self.viewContentConfirmation.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewContentConfirmation.layer.borderWidth = 0.5
        self.viewContentConfirmation.clipsToBounds = true;
        
        
        self.btnTrue.updateButtonType1()
        self.btnTrue.setTitle("Benar", for: .normal)
        self.btnFalse.updateButtonType3()
        self.btnFalse.setTitle("Salah", for: .normal)
        btnFalse.addTarget(self, action: #selector(ConfirmationViewController.buttonStatus) , for: .touchUpInside)
        
        
        
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
        
        
        let arrayContent = data.value(forKey: "content") as! [[String:String]]
        for content in arrayContent {
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
//        let vc = StatusTransferViewController.initWithOwnNib()
//        self.navigationController?.pushViewController(vc, animated: false)
//        self.animatedFadeIn()
        self.showOTP()
    }
    
    func didOTPCancel() {
        DLog("cancel");
       
        
    }
    
    func didOTPOK() {
        DLog("OK");
        DLog("\(tfOTP.text)")
        let vc = StatusTransferViewController.initWithOwnNib()
        vc.data = data as NSDictionary!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showOTP()  {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 100))
        let messageAlert = UILabel(frame: CGRect(x: 15, y: 0, width: temp.frame.size.width, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = "Kode OTP dan link telah dikirimkan ke nomor 08881234567. Masukkan kode tersebut atau akses link yang tersedia."

        tfOTP = BaseTextField(frame: CGRect(x: 15, y: messageAlert.frame.origin.y + messageAlert.frame.size.height + 3, width: temp.frame.size.width, height: 30))
        tfOTP.borderStyle = .line
        tfOTP.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        tfOTP.layer.borderWidth = 1;
        tfOTP.placeholder = "6 digit kode OTP"
        tfOTP.isSecureTextEntry = true
        tfOTP.addInset()
        
       
        temp.addSubview(messageAlert)
        temp.addSubview(tfOTP)
        
        showOTPWith(title: "Masukkan Kode OTP", view: temp)
    }

    
}
