//
//  RegistrationStep3.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 28/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep3: UIViewController{
    
    @IBOutlet weak var pinFieldsView: UIView!
    @IBOutlet weak var mPINTextField: UITextField!
    @IBOutlet weak var confirmasimPINTextField: UITextField!
    @IBOutlet weak var subTitleTextLabel: UILabel!
    var showOTPAlert:Bool!
    
    var activationInqueryOTP:String!
    var activationInquerySctlId:String!
    var activationSourceMDN:String!
    
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SimaspayUtility.setMPINTextFieldImage(mPINTextField)
        SimaspayUtility.setMPINTextFieldImage(confirmasimPINTextField)
        
        SimaspayUtility.setSimasPayUIviewStyle(pinFieldsView)
        
        okButton.layer.cornerRadius = 5;
        okButton.layer.masksToBounds = true;
        
        let string = subTitleTextLabel.text! as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        // 2  [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
        let firstAttributes = [NSForegroundColorAttributeName: UIColor(netHex:0x494949),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16.0)!]
        // 3
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString("Bayu Santoso"))
        // 4
        subTitleTextLabel.attributedText = attributedString
        
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
    
    
    
    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "6 digit kode OTP"
        tField = textField
    }
    
    @available(iOS 8.0, *)
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    @IBAction func onSubmitButtonClicked(sender: AnyObject) {
        
        //&txnName=Activation  &service=Account  &sourceMDN=6244444400016  activationConfirmPin=xxxxxxxx  activationNewPin=xxxxxxx &mfaOtp=4FF699A636821E5C7FD0 &mfaTransaction=Confirm mspID=1& &parentTxnID=404006
        //&institutionID=&channelID=7&&accountType=&otp=xxxxxxxx
        
        if(!mPINTextField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Masukkan mPIN Anda", viewController: self)
            return
        }
        
        if(!confirmasimPINTextField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Masukkan Konfirmasi mPIN Anda", viewController: self)
            return
        }
        
        if(mPINTextField.text != confirmasimPINTextField.text)
        {
            SimasPayAlert.showSimasPayAlert("mPIN should be same confirmation mPIN", viewController: self)
            return
        }
        
        if (!self.showOTPAlert)
        {
            self.confirmationRequest("")
        }else{
            self.showOTPInputAlert()
        }
        
    }
     func showOTPInputAlert() {

        let alertTitle = "Masukkan Kode OTP"
        let message = "Kode OTP dan link telah dikirimkan ke \n nomor \(activationSourceMDN). Masukkan kode \n tersebut atau akses link yang tersedia."
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
            alertController.addTextFieldWithConfigurationHandler(configurationTextField)
            alertController.addAction(UIAlertAction(title: "Batal", style: UIAlertActionStyle.Cancel, handler:handleCancel))
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                print("Done !!")
                print("Item : \(self.tField.text)")
                
                self.confirmationRequest(self.tField.text!)
               
            }))
            self.presentViewController(alertController, animated: true, completion: {
                print("completion block")
            })
            
        } else {
            // Fallback on earlier versions
            let alert = UIAlertView()
            alert.title = alertTitle
            alert.message = message
            alert.addButtonWithTitle("OK")
            alert.addButtonWithTitle("Batal")
            alert.show()
        }
        
    }
    
    func confirmationRequest(otpText:String)
    {
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_INQUIRY_ACTIVATION
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = SimaspayUtility.getNormalisedMDN(activationSourceMDN)
        dict[ACTIVATION_NEWPIN] = SimaspayUtility.simasPayRSAencryption(mPINTextField.text!)
        dict[ACTIVATION_CONFORMPIN] = SimaspayUtility.simasPayRSAencryption(confirmasimPINTextField.text!)
        if(otpText.length > 0)
        {
          dict[MFAOTP] = SimaspayUtility.simasPayRSAencryption(otpText)
        }
        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
        dict[PARENTTXNID] = activationInquerySctlId
        dict[ACTIVATION_OTP] = activationInqueryOTP
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        print("Params  : ",dict)
        
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }
                    
                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    print("Response : ",responseDict)
                    if( messagecode == SIMASPAY_ACTIVATION__CONFIRMATION_SUCCESS_CODE || messagecode == SIMASPAY_ACTIVATION__CONFIRMATION_SUCCESS_CODE1)
                    {
                        
                        let step4ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationStep4") as! RegistrationStep4
                        
                        self.navigationController!.pushViewController(step4ViewController, animated: true)
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                    }
                    
                    //print("Response : ",SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_LOGIN_DATA))
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                }
                
        })
    }
    
}