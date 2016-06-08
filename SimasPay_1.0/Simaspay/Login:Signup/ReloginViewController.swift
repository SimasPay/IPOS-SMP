//
//  ReloginViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 29/04/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation


import UIKit

class ReloginViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var mPINTextField: UITextField!
    @IBOutlet weak var subTitleTextLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mPINTextField.delegate = self
        SimaspayUtility.setMPINTextFieldImage(mPINTextField)
        SimaspayUtility.setSimasPayUIviewStyle(loginFieldsView)
        SimaspayUtility.simasPayUnderlineButtonTextLabel(contactUsButton)
        
        //okButton.layer.cornerRadius = 5;
        //okButton.layer.masksToBounds = true;
        
        let sourceMDN = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        subTitleTextLabel.text = "Silakan masukkan mPIN untuk nomor HP \(sourceMDN)"
        
        let string = subTitleTextLabel.text! as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        // 2  [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
        let firstAttributes = [NSForegroundColorAttributeName: UIColor(netHex:0x494949),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16.0)!]
        // 3
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString("\(sourceMDN)"))
        // 4
        subTitleTextLabel.attributedText = attributedString
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReloginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
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
        
        if(!mPINTextField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Masukkan mPIN Anda", viewController: self)
            return
        }
        
        

    }
    
    
    func doLoginRequest(mPINText:String)
    {
        
        
        self.dismissKeyboard()
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_LOGIN_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[mPIN_STRING] = SimaspayUtility.simasPayRSAencryption(mPINText)
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.currentDevice().modelName)  \(UIDevice.currentDevice().systemVersion)"
        
        print("Login Params : ",dict)
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    print("Login Response : ",response)
                    
                    EZLoadingActivity.hide()
                    
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }
                    
                    let responseDict = response as NSDictionary
                    let responseDictObject = responseDict.valueForKey("response") as! NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    
                    
                    if( messagecode == SIMASPAY_LOGIN_SUCCESS_CODE)
                    {
                        let isUserType  = responseDict.valueForKeyPath("response.type.text") as! String
                        SimasPayPlistUtility.saveDataToPlist(mPINText, key: SOURCEPIN)
                        
                        //userAPIKey
                        if((responseDictObject.objectForKey("userAPIKey")) != nil)
                        {
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(responseDictObject.valueForKeyPath("userAPIKey.text"), forKey: "GetUserAPIKey")
                        }
                        SimasPayPlistUtility.saveDataToPlist(responseDict, key: SIMASPAY_LOGIN_DATA)
                        if( isUserType == SIMASPAY_LOGIN_AGENT_TYPE)
                        {
                            // AGENT LOGIN FlOW
                            let agentOptionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AgentOptionViewController") as! AgentOptionViewController
                            self.navigationController!.pushViewController(agentOptionViewController, animated: true)
                            
                        }else{
                            
                            let isBank  = responseDict.valueForKeyPath("response.isBank.text") as! String
                            
                            if( isBank == SIMASPAY_LOGIN_REGULAR_TYPE)
                            {
                                self.showRegularCustomerFlow()
                                SimasPayPlistUtility.saveDataToPlist("2", key: SOURCEPOCKETCODE)
                                SimasPayPlistUtility.saveDataToPlist("2", key: DESTPOCKETCODE)
                                
                            }else{
                                SimasPayPlistUtility.saveDataToPlist("6", key: SOURCEPOCKETCODE)
                                SimasPayPlistUtility.saveDataToPlist("2", key: DESTPOCKETCODE)
                                self.showLakuPandaiCustomerFlow()
                            }
                        }
                        
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
    
    
    func showRegularCustomerFlow ()
    {
        var menuViewArray = []
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        let optionDict1 = ["title":"Transfer","image":"btn-transfer","SimasPayMainMenuOptionType":"SIMASPAY_TRANSFER"]
        let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","SimasPayMainMenuOptionType":"SIMASPAY_PEMBELIAN"]
        let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","SimasPayMainMenuOptionType":"SIMASPAY_PEMBAYARAN"]
        let optionDict4 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","SimasPayMainMenuOptionType":"SIMASPAY_BAYAR_PAKAI_QR"]
        let optionDict5 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
        
        menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5]
        mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER
        mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)
    }
    
    func showLakuPandaiCustomerFlow()
    {
        var menuViewArray = []
        
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        let optionDict1 = ["title":"Transfer","image":"btn-transfer","SimasPayMainMenuOptionType":"SIMASPAY_TRANSFER"]
        let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","SimasPayMainMenuOptionType":"SIMASPAY_PEMBELIAN"]
        let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","SimasPayMainMenuOptionType":"SIMASPAY_PEMBAYARAN"]
        let optionDict4 = ["title":"Tarik Tunai","image":"btn-tariktunai","SimasPayMainMenuOptionType":"SIMASPAY_TARIK_TUNAI"]
        let optionDict5 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","SimasPayMainMenuOptionType":"SIMASPAY_BAYAR_PAKAI_QR"]
        let optionDict6 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
        
        menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6]
        mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_LAKU_PANDAI
        mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)
    }
    
    @IBAction func contactButtonClicked(sender: AnyObject)
    {
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_CONTACTUS
        dict[VERSION] = "0"
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
            // Handle success response
            dispatch_async(dispatch_get_main_queue()) {
                
                EZLoadingActivity.hide()
                print("ContactUs Response : ",response)
                
                let responseDict = response as! NSDictionary
                let contactUsData = responseDict.valueForKey("contactus") as! NSDictionary
                
                if(contactUsData.allKeys.count > 0){
                    
                    let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContactusViewController") as! ContactusViewController
                    viewController.contactUsDictonary = contactUsData
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
                
            }
            
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                }
                
        })
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        
        let maxLength = 4
        //let currentString: NSString = textField.text!
        //let newString: NSString =
        //currentString.stringByReplacingCharactersInRange(range, withString: string)
        
        
        let  newLength : Int = (textField.text?.length)!+string.length - range.length
        
        if (newLength > maxLength) {
            return false
        }
        
        if (newLength >= maxLength) {
            
            //[self checkPin:[textField.text stringByReplacingCharactersInRange:range withString:string]];
            
            var txtAfterUpdate:NSString = self.mPINTextField.text! as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            self.mPINTextField.text = txtAfterUpdate as String
            doLoginRequest(txtAfterUpdate as String)
            return true
        }
        
        //return newString.length <= maxLength
        
        return true
        
        
    }

}