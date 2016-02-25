//
//  RegistrationStep2.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 28/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep2: UIViewController{
    
    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var kodeOTPTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SimaspayUtility.setMobileNumberTextFieldImage(mobileNumberTextField)
        SimaspayUtility.setOTPTextFieldImage(kodeOTPTextField)
        
        SimaspayUtility.setSimasPayUIviewStyle(loginFieldsView)
        SimaspayUtility.simasPayUnderlineButtonTextLabel(resendOTPButton)
        
        okButton.layer.cornerRadius = 5;
        okButton.layer.masksToBounds = true;
        
        SimaspayUtility.simasPayUnderlineButtonTextLabel(backToLoginButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
    }
    
    @IBAction func resentOTPClicked(sender: AnyObject) {
        
        let alertTitle = "Mohon Tunggu"
        let message = "Kami sudah mengirimkan SMS \n kode OTP yang baru untuk Anda.\nApabila SMS belum diterima,\nsilakan cek koneksi atau hubungi \nmobile service provider Anda."
        
       if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
        
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
        
            presentViewController(alertController, animated: true, completion: nil)
        
        } else {
            // Fallback on earlier versions
        
            let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = message
                alert.addButtonWithTitle("OK")
                alert.show()
        
        
        };
        
        
    }
    @IBAction func backToLoginClicked(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}