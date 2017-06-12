//
//  SecurityQuestionResetController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/23/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import Foundation

import UIKit

class SecurityQuestionResetController: BaseViewController, UIAlertViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblInfo: BaseLabel!
    @IBOutlet weak var btnRegister: BaseButton!
    @IBOutlet weak var tfAnswer: BaseTextField!
    @IBOutlet weak var btnScrollView: NSLayoutConstraint!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var viewTFQuetion: UIView!
    @IBOutlet weak var viewTfAnswer: UIView!
    
    var question: String = ""
    var mdn: String = ""
    
    static func initWithOwnNib() -> SecurityQuestionResetController {
        let obj:SecurityQuestionResetController = SecurityQuestionResetController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton(subMenu: false)
        self.showTitle("Reset mPIN", subMenu: false)
        
        lblQuestion.text = question
        
        tfAnswer.placeholder = getString("SecurityQuestionTextfieldAnswerPlaceholder")
        tfAnswer.addInset()
        tfAnswer.font = UIFont.systemFont(ofSize: 16)
        
        btnRegister.updateButtonType1()
        btnRegister.setTitle("Konfirmasi", for: .normal)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTFQuetion.updateViewRoundedWithShadow()
        viewTfAnswer.updateViewRoundedWithShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        self.btnScrollView.constant = BaseViewController.keyboardSize.height
        self.view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        self.btnScrollView.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        
        if !tfAnswer.isValid() {
            SimasAlertView.showAlert(withTitle: "", message: "Masukkan jawaban Anda", cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
     
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_FORGOT_PIN_INQUIRY
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = mdn
        dict[SECURITY_QUESTION] = question
        dict[SECURITY_ANSWER] = tfAnswer.text
        
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
                if ( messagecode == "2045" ){
                    let vc = NewPinController.initWithOwnNib()
                    vc.sctlID = responseDict.value(forKeyPath: "sctlID.text") as! String
                    vc.mdn = self.mdn
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if ( messagecode == "2046" ) {
                    SimasAlertView.showAlert(withTitle: nil, message: "Jawaban Anda belum sesuai.", cancelButtonTitle: getString("AlertCloseButtonText"))
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
    
    @IBAction func actionContactUs(_ sender: Any) {
        
    
    }


    
}
