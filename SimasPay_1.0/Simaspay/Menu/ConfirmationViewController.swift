//
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class ConfirmationViewController: UIViewController,CZPickerViewDelegate
{
    
    var confirmationScrollview: UIScrollView!
    var simasPayOptionType:SimasPayOptionType!
    var confirmationTitlesArray: Array<AnyObject>!
    var confirmationValuesArray: Array<AnyObject>!
    
    var showOTPAlert:Bool!
    
    var confirmationRequestDictonary = NSMutableDictionary() as [NSObject : AnyObject]
    

    var isSubscriberClosingFalied:Bool = false
    var subcriberCloseFaliedReason:String!
    var  mfaOTPPicker:CZPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Konfirmasi"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
    
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        confirmationScrollview = UIScrollView()
        confirmationScrollview.backgroundColor = UIColor.clearColor()
        confirmationScrollview.translatesAutoresizingMaskIntoConstraints=false
        confirmationScrollview.scrollEnabled = true
        self.view.addSubview(confirmationScrollview)
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["confirmationScrollview"] = confirmationScrollview

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[confirmationScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[confirmationScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        let confirmationView = UIView()
        confirmationView.backgroundColor = UIColor.whiteColor()
        confirmationView.translatesAutoresizingMaskIntoConstraints=false
        confirmationView.layer.cornerRadius = 5
        initialScrollViews["confirmationView"] = confirmationView
        confirmationScrollview.addSubview(confirmationView)
        
        
        //SimaspayUtility.setSimasPayUIviewStyle(confirmationView)
        let buttonMargin = (self.view.frame.size.width-200)/2
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Benar", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmationScrollview.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: #selector(ConfirmationViewController.senfOTPClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        
        let cancelButton:UIButton = UIButton()
        cancelButton.backgroundColor = UIColor(netHex:0xDBDBDB)
        cancelButton.setTitle("Salah", forState: UIControlState.Normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.titleLabel?.font = UIFont(name:"HelveticaNeue", size:20)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        confirmationScrollview.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(ConfirmationViewController.popToRoot(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["cancelButton"] = cancelButton
        cancelButton.layer.cornerRadius = 5
        
        let width = self.view.frame.width-40
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[confirmationView(\(width))]-20-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
        
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step1FormAcceptBtn]-(\(buttonMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[cancelButton]-(\(buttonMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[confirmationView]-20-[step1FormAcceptBtn(50)]-\(15)-[cancelButton(50)]-\(30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let topMargin = 15
        let leftRightMargin = 20
        var titleLabelHeight = 21

        let titleLabel = UILabel()
        if(self.isSubscriberClosingFalied)
        {
            cancelButton.hidden = true
            titleLabel.text = self.subcriberCloseFaliedReason
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .ByWordWrapping
            titleLabel.textColor = UIColor(netHex:0xCC0000)
            titleLabelHeight = 42
            
            step1FormAcceptBtn.setTitle("Kembali", forState: UIControlState.Normal)
            
        }else{
            titleLabel.text = "Pastikan data berikut sudah benar"
        }
        
        titleLabel.font = UIFont(name:"HelveticaNeue", size:13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.Center
        confirmationView.addSubview(titleLabel)
        initialScrollViews["titleLabel"] = titleLabel
        
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[titleLabel]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        
        var vertical_constraints = "V:|-\(topMargin)-[titleLabel(\(titleLabelHeight))]-20-"
        
        for i in 1...confirmationTitlesArray.count {
            let confirmationTitleLabel = UILabel()
            confirmationTitleLabel.text = "\(confirmationTitlesArray[i-1])"
            confirmationTitleLabel.font = UIFont(name:"Helvetica", size:12.5)
            confirmationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmationView.addSubview(confirmationTitleLabel)
            initialScrollViews["confirmationTitleLabel\(i)"] = confirmationTitleLabel
            
            let confirmationValueLabel = UILabel()
            confirmationValueLabel.text = "\(confirmationValuesArray[i-1])"
            confirmationValueLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
            confirmationValueLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmationView.addSubview(confirmationValueLabel)
            initialScrollViews["confirmationValueLabel\(i)"] = confirmationValueLabel
            
            vertical_constraints  += "[confirmationTitleLabel\(i)(21)][confirmationValueLabel\(i)(21)]-10-"
            
            if( i == confirmationTitlesArray.count-1 &&  (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN))
            {
                let dottedLineView = SimasPayDottedLine()
                dottedLineView.translatesAutoresizingMaskIntoConstraints = false
                confirmationView.addSubview(dottedLineView)
                initialScrollViews["dottedLineView"] = dottedLineView
                
                confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[dottedLineView]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
                
                vertical_constraints  += "[dottedLineView(2)]-10-"
            }
            
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[confirmationTitleLabel\(i)]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
            
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[confirmationValueLabel\(i)]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
        }
        
        vertical_constraints += "|"
        
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))

    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().barTintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        UINavigationBar.appearance().tintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        self.navigationController?.navigationBarHidden = false
        let backButtonItem = UIBarButtonItem(customView: SimaspayUtility.getSimasPayBackButton(self))
        self.navigationItem.leftBarButtonItem = backButtonItem

    }


    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "6 digit kode OTP"
        tField = textField
        tField.secureTextEntry = true
        tField.keyboardType = .NumberPad
    }
    
    
    
    
    
    func readOTPNotification(notification: NSNotification) {
        let tokenString = notification.userInfo!["token"] as! String
        self.tField.text = tokenString
    }
    
    @IBAction func senfOTPClicked(sender: AnyObject) {
        
        
        if(self.isSubscriberClosingFalied)
        {
            self.navigationController!.popViewControllerAnimated(true)
            return
        }
        

        if (!self.showOTPAlert)
        {
            self.confirmationServiceRequest()
        }else{
            czpickerViewResendOTP(nil)
        }
    }
    
    func showOTPPopUP()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConfirmationViewController.readOTPNotification(_:)), name:OTPNotificationKey, object: nil)
        
        var sourceMDN = ""
        
        if(self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TUTUP_REKENING){
            sourceMDN = self.confirmationRequestDictonary[DESTMDN] as! String
        }else{
            sourceMDN = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN) as! String
        }
        
        mfaOTPPicker = CZPickerView.init(headerTitle: "Masukkan Kode OTP", messageText: "Kode OTP dan link telah dikirimkan ke \n nomor \(sourceMDN). Masukkan kode \n tersebut atau akses link yang tersedia.", viewController: self)
        
        mfaOTPPicker.delegate = self
        mfaOTPPicker.needFooterView = true
        mfaOTPPicker.tapBackgroundToDismiss = false;
        mfaOTPPicker.show()
    }
    
    func czpickerViewDidClickOKButton(pickerView: CZPickerView!, otpText: String!) {
        
        if(otpText.length > 0)
        {
            if(self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TUTUP_REKENING)
            {
                self.confirmationRequestDictonary[OTP] = SimaspayUtility.simasPayRSAencryption(otpText)
            }else{
                self.confirmationRequestDictonary[MFAOTP] = SimaspayUtility.simasPayRSAencryption(otpText)
            }
            
            self.confirmationServiceRequest()
        }else{
            SimasPayAlert.showSimasPayAlert("Masukkan Kode OTP.",viewController: self)
        }
        
    }
    
    func czpickerViewDidClickCancelButton(pickerView: CZPickerView!) {
        
        popToMainViewController()
        
    }
    
    func czpickerViewResendOTP(pickerView: CZPickerView!) {
     
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }

        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SERVICE] = SERVICE_WALLET
        dict[TXNNAME] = TXN_RESEND_MFAOTP
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        dict[SCTL_ID] = self.confirmationRequestDictonary[SCTL_ID]
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        print("Confirmation Params : ",dict)
        
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
                    
                    print("Confirmation Response : ",response)
                    
                    if( messagecode == SIMASPAY_RESEND_OTP_SUCESS)
                    {
                        if((pickerView) != nil)
                        {
                            self.mfaOTPPicker.reSendOTPSuccess()
                        }else{
                            self.showOTPPopUP()
                        }
                        

                    }else if( messagecode == SIMASPAY_RESEND_OTP_FAILED)
                    {
                        
                    }else if( messagecode == SIMASPAY_RESEND_OTP_LIMIT_REACHED)
                    {
                        self.mfaOTPPicker.hide()
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                        
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
    
    func confirmationServiceRequest ()
    {
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict = self.confirmationRequestDictonary as [NSObject : AnyObject]
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        print("Confirmation Params : ",dict)

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
                    let responseDictObject = responseDict.valueForKey("response") as! NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    
                    print("Confirmation Response : ",response)
                    
                    if( messagecode == SIMASPAY_AGENT_REGISTRATION_SUCESS || messagecode == SIMOBI_SELFBANK_TRANSFER_CONFIRM_SUCCESSCODE || messagecode == SIMOBI_LAKU_IBT_TRANSFER_CONFIRM_SUCCESSCODE || messagecode == SIMOBI_LAKU_LAKU_TRANSFER_CONFIRM_SUCCESSCODE || messagecode ==
                        SIMOBI_TRANSFER_LAKU_CONFIRM_SUCCESSCODE ||  messagecode == SUBCRIBER_CLOSING_CONFIRMATION_SUCCESS || messagecode == SIMASPAY_CAHSIN_CONFIRMATION_SUCCESS || messagecode == SIMASPAY_CAHSOUT_CONFIRMATION_SUCCESS || messagecode == SIMAPAY_SUCCESS_PURCHASE_CODE  || messagecode == SIMAPAY_SUCCESS_PAYMENT_CODE || messagecode == SIMAPAY_SUCCESS_REFERRAL_CODE  || messagecode == SIMOBI_TRANSFER_UANGKU_CONFIRM_SUCCESSCODE)
                    {
                        
                        var tansactionID = ""
                        if((responseDictObject.objectForKey("sctlID")) != nil)
                        {
                            tansactionID =   responseDict.valueForKeyPath("response.sctlID.text") as! String
                        }
                    
                         self.gotoStausViewController(tansactionID)
                        
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                        if( messagecode == SIMASPAY_LOGIN_EXPIRE_CODE)
                        {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    }
                    
                    
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                }
                
        })
    }
    
    func gotoStausViewController(transactionID:NSString)
    {
        //var confirmationTitlesArray : [NSString] = NSArray() as! [NSString]
        //var confirmationValuesArray : [NSString] = NSArray() as! [NSString]
        
        let confirmationViewController = StatusViewController()
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_SETOR_TUNAI)
        {
            
            confirmationViewController.statusTitle = "Setor Tunai Berhasil"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TUTUP_REKENING)
        {
            confirmationViewController.statusTitle = "Rekening Berhasil Ditutup"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REFERRAL)
        {
            
            confirmationViewController.statusTitle = "Referral Berhasil"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REFERRAL)
        {
    
            confirmationViewController.statusTitle = "Referral Berhasil"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_AGENT_REGISTRATION)
        {
            confirmationViewController.statusTitle = "Data Terkirim!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TARIK_TUNAI)
        {
            
            confirmationViewController.statusTitle = "Tarik Tunai Berhasil"
        }
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            
            confirmationViewController.statusTitle = "Pembayaran Berhasil!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
        {
            
            confirmationViewController.statusTitle = "Pembelian Berhasil!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANKSINARMAS || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_UANGKU)
        {
            
            
            confirmationViewController.statusTitle = "Transfer Berhasil!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN)
        {
            let tempConfirmationTitlesArray = NSMutableArray()
            let tempConfirmationValuesArray = NSMutableArray()
            
            tempConfirmationTitlesArray[0] = self.confirmationTitlesArray[0]
            tempConfirmationValuesArray[0] = self.confirmationValuesArray[0]
            tempConfirmationTitlesArray[1] = self.confirmationTitlesArray[1]
            tempConfirmationValuesArray[1] = self.confirmationValuesArray[1]
            tempConfirmationTitlesArray[2] = self.confirmationTitlesArray[2]
            tempConfirmationValuesArray[2] = self.confirmationValuesArray[2]
            tempConfirmationTitlesArray[3] = self.confirmationTitlesArray[3]
            tempConfirmationValuesArray[3] = self.confirmationValuesArray[3]
            tempConfirmationTitlesArray[4] = self.confirmationTitlesArray[5]
            tempConfirmationValuesArray[4] = self.confirmationValuesArray[5]
            
            confirmationViewController.confirmationTitlesArray = tempConfirmationTitlesArray as Array<AnyObject>
            confirmationViewController.confirmationValuesArray = tempConfirmationValuesArray as Array<AnyObject>
        }else{
            confirmationViewController.confirmationTitlesArray = self.confirmationTitlesArray
            confirmationViewController.confirmationValuesArray = self.confirmationValuesArray
        }
        
        
        
        confirmationViewController.isFromChangePIN = false
        confirmationViewController.transactionID = transactionID
        confirmationViewController.simasPayOptionType = self.simasPayOptionType
        self.navigationController!.pushViewController(confirmationViewController, animated: true)
    }
    
     func popToMainViewController() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for viewController:UIViewController in viewControllers{
            if(viewController.isKindOfClass(SubMenuViewController) == true) {
                self.navigationController?.navigationBarHidden = true
                self.navigationController?.popToViewController(viewController as! SubMenuViewController, animated: true)
                break;
            }
        }
        
        for viewController:UIViewController in viewControllers{
            if(viewController.isKindOfClass(MainMenuViewController) == true) {
                self.navigationController?.navigationBarHidden = true
                self.navigationController?.popToViewController(viewController as! MainMenuViewController, animated: true)
                break;
            }
        }
        
    }
}