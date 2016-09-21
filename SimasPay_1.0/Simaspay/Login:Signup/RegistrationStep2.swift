//
//  RegistrationStep2.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 28/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep2: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var kodeOTPTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mobileNumberTextField.delegate = self
        kodeOTPTextField.delegate = self
        kodeOTPTextField.tag = 100
        SimaspayUtility.setMobileNumberTextFieldImage(mobileNumberTextField)
        SimaspayUtility.setOTPTextFieldImage(kodeOTPTextField)
        
        SimaspayUtility.setSimasPayUIviewStyle(loginFieldsView)
        SimaspayUtility.simasPayUnderlineButtonTextLabel(resendOTPButton)
        
        okButton.layer.cornerRadius = 5;
        okButton.layer.masksToBounds = true;
        
        SimaspayUtility.simasPayUnderlineButtonTextLabel(backToLoginButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationStep2.dismissKeyboard))
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
    
    
    
    @IBAction func submitButtonClicked(sender: AnyObject)
    {
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        if(!mobileNumberTextField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Harap masukkan nomor handphone Anda.", viewController: self)
            return
        }
        
        if(!kodeOTPTextField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Masukkan mPIN Anda", viewController: self)
            return
        }
        
        if(kodeOTPTextField.text?.length < 6)
        {
            SimasPayAlert.showSimasPayAlert("Kode Aktivasi yang anda masukkan harus 6 angka.", viewController: self)
            return
        }
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_INQUIRY_ACTIVATION
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = SimaspayUtility.getNormalisedMDN(mobileNumberTextField.text!)
        dict[ACTIVATION_OTP] = SimaspayUtility.simasPayRSAencryption(kodeOTPTextField.text!)
        //dict[INSTITUTION_ID] = SIMOBI
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        dict[MFATRANSACTION] = INQUIRY

        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                
                dispatch_async(dispatch_get_main_queue()) {
                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String                    
                    
                    EZLoadingActivity.hide()
                    
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }
                    
                    print("Response : ",responseDict)
                    if( messagecode == SIMASPAY_ACTIVATION__INQUERY_SUCCESS_CODE)
                    {
                        let userName = responseDict.valueForKeyPath("response.name.text") as! String
                        let mfaModeStatus = responseDict.valueForKeyPath("response.mfaMode.text") as! String
                        let sctlID = responseDict.valueForKeyPath("response.sctlID.text") as! String
                        
                        
                        let step3ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationStep3") as! RegistrationStep3
                        step3ViewController.activationInqueryOTP = SimaspayUtility.simasPayRSAencryption(self.kodeOTPTextField.text!) as String
                        step3ViewController.activationInquerySctlId = responseDict.valueForKeyPath("response.sctlID.text") as! String
                        //SimaspayUtility.getNormalisedMDN(self.mobileNumberTextField.text!) as String
                        step3ViewController.activationSourceMDN = self.mobileNumberTextField.text!
                        
                        step3ViewController.activationSctlID = sctlID
                        if(mfaModeStatus == "OTP")
                        {
                            step3ViewController.showOTPAlert = true
                        }else{
                            step3ViewController.showOTPAlert = false
                        }
                        step3ViewController.userName = userName
                        self.navigationController!.pushViewController(step3ViewController, animated: true)
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                    }
                    
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                }
                
        })
        
        
    }
    
    func showResentOTPMessage() {
        
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
    
    @IBAction func resentOTPClicked(sender: AnyObject)
    {
        if(!mobileNumberTextField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Harap masukkan nomor handphone Anda.", viewController: self)
            return
        }
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_RESENDOTP
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = mobileNumberTextField.text
            

        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let responseDict = response as NSDictionary
                    let responseDictObject = responseDict.valueForKey("response") as! NSDictionary
                    print("Response : ",responseDict)
                    
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    EZLoadingActivity.hide()
                    
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }
                    
                    if((responseDictObject.objectForKey("OneTimePin")) != nil)
                    {
                        self.showResentOTPMessage()
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                    }
                    
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                }
                
        })
        
    }
    
    
    @IBAction func backToLoginClicked(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        var maxLength = 15
        
        if textField.tag == 100 {
            maxLength = 6
        }
        
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
        
        
    }
    
}