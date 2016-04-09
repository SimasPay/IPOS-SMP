//
//  ViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activationButton: UIButton!
    @IBOutlet weak var mobilenumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var contactUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.cornerRadius = 5;
        loginButton.layer.masksToBounds = true;
        
        activationButton.layer.cornerRadius = 5;
        activationButton.layer.masksToBounds = true;

        
        SimaspayUtility.setMobileNumberTextFieldImage(mobilenumberField)
        SimaspayUtility.setMPINTextFieldImage(passwordField)
        
        SimaspayUtility.setSimasPayUIviewStyle(loginFieldsView)
        SimaspayUtility.simasPayUnderlineButtonTextLabel(contactUsButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide Viewcontroller Navigationcontroller
        //SimaspayUtility.clearNavigationBarcolor(self.navigationController!)
        //self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.navigationController?.navigationBarHidden = true

    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        
        self.dismissKeyboard()
    
        if(!mobilenumberField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Masukkan nomor handphone", viewController: self)
            return
        }
        
        if(!passwordField.isValid())
        {
            SimasPayAlert.showSimasPayAlert("Masukkan mPIN Anda", viewController: self)
            return
        }
        
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
          SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        let publickKeyResponse = SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_PUBLIC_KEY)
        if( publickKeyResponse == nil)
        {
            getSimasPayPublicKey()
        }else{
            doLoginRequest()
        }
    }
    
    func getSimasPayPublicKey()
    {
        
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GETPUBLC_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                dispatch_async(dispatch_get_main_queue()) {
                     EZLoadingActivity.hide()
                    let responseDict = response as NSDictionary
                    print("Response : ",responseDict)
                    if(responseDict.valueForKeyPath("response.Success.text") != nil)
                    {
                        let responseStatus  = responseDict.valueForKeyPath("response.Success.text") as! String
                        if(responseStatus == "true")
                        {
                            SimasPayPlistUtility.saveDataToPlist(responseDict, key: SIMASPAY_PUBLIC_KEY)
                            self.doLoginRequest()
                        }
                    }
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                 EZLoadingActivity.hide()
                SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                dispatch_async(dispatch_get_main_queue()) {
                }
                
        })
        
    }
    
    func doLoginRequest()
    {
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_LOGIN_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = SimaspayUtility.getNormalisedMDN(mobilenumberField.text!)
        dict[mPIN_STRING] = SimaspayUtility.simasPayRSAencryption(passwordField.text!)
        dict[SIMASPAY_ACTIVITY] = ACTIVITY_STATUS
        
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.currentDevice().modelName)  \(UIDevice.currentDevice().systemVersion)"
        
        print("Login Params : ",dict)
        
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
                        
                        SimasPayPlistUtility.saveDataToPlist(SimaspayUtility.getNormalisedMDN(self.mobilenumberField.text!), key: SOURCEMDN)
                        SimasPayPlistUtility.saveDataToPlist(self.passwordField.text, key: SOURCEPIN)
                        
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
                        
                        self.passwordField.text! = ""
                        
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
    

}

