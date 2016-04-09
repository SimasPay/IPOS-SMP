//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class TransferBankSinarmasViewC: UIViewController
{
    var cashinScrollview: UIScrollView!
    var simasPayOptionType:SimasPayOptionType!
    var simasPayUserType:SimasPayUserType!
    
    var contentView:UIView!
    var cashInFormDictonary:NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,  NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        cashinScrollview = UIScrollView()
        cashinScrollview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(cashinScrollview)
        
        
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["cashinScrollview"] = cashinScrollview
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        
        contentView = UIView()
        cashinScrollview.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        initialScrollViews["contentView"] = contentView
        
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(==cashinScrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let topMargin = 20
        let labelFieldMArgin = 10
        let nextFieldMArgin = 20
        let textFieldHeight = 38
        let errorLabelWidth = 50
        let extraEndSpace = 30
        
        var vertical_constraints = "V:|-\(topMargin)-"
        
        var fieldNamesArray : [NSString] = ["Nomor Rekening Tujuan","Jumlah","mPIN"]
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI)
        {
            fieldNamesArray = ["Nomor Handphone Tujuan","Jumlah","mPIN"]
        }
        for i in 1...fieldNamesArray.count {
            let step1Label = UILabel()
            step1Label.text = "\(fieldNamesArray[i-1])"
            step1Label.font = UIFont(name:"HelveticaNeue-Medium", size:12.5)
            step1Label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(step1Label)
            
            let step1ErrorLabel = UILabel()
            step1ErrorLabel.text = "wajib diisi"
            step1ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            step1ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
            step1ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            step1ErrorLabel.hidden = true
            step1ErrorLabel.tag = 100+i
            contentView.addSubview(step1ErrorLabel)
            
            initialScrollViews["step1Label_\(i)"] = step1Label
            initialScrollViews["step1ErrorLabel_\(i)"] = step1ErrorLabel
            
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1Label_\(i)]-0-[step1ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
            
            let step1TextField = UITextField(frame: CGRect.zero)
            step1TextField.backgroundColor = UIColor.whiteColor()
            step1TextField.enabled = true
            step1TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
            step1TextField.translatesAutoresizingMaskIntoConstraints = false
            step1TextField.borderStyle = .None
            step1TextField.layer.cornerRadius = 5
            step1TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            contentView.addSubview(step1TextField)
            step1TextField.tag = 10+i
            
            let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step1TextField.frame.height))
            step1TextField.leftView = mobileNumberView;
            step1TextField.leftViewMode = UITextFieldViewMode.Always
            initialScrollViews["step1TextField_\(i)"] = step1TextField
            
            step1TextField.keyboardType = .NumberPad
            
            if(i == 3)
            {
              step1TextField.secureTextEntry = true
            }

            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            
            vertical_constraints  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step1TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
            
            
            if( i == 2)
            {
                
                let rupeeLabel = UILabel()
                rupeeLabel.frame = CGRect(x: 10, y: (step1TextField.frame.height-20)/2, width: 15, height: 20)
                rupeeLabel.text = "Rp"
                rupeeLabel.textColor = UIColor.blackColor()
                rupeeLabel.font = UIFont(name:"HelveticaNeue", size:11)
                
                let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 15+15, step1TextField.frame.height))
                mobileNumberView2.addSubview(rupeeLabel);
                step1TextField.leftView = mobileNumberView2
                step1TextField.leftViewMode = UITextFieldViewMode.Always
            }
            
            
            
        }

        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        contentView.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: "cashInAcceptClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(60)-[step1FormAcceptBtn]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        vertical_constraints += "[step1FormAcceptBtn(50)]-\(extraEndSpace)-|"

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hide Viewcontroller Navigationcontroller
        //SimaspayUtility.clearNavigationBarcolor(self.navigationController!)  DBDBDB
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
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    @IBAction func cashInAcceptClicked(sender: UIButton)
    {
        
        cashInFormDictonary = NSMutableDictionary()
        
        for  subView in contentView.subviews
        {
            if (subView.isKindOfClass(UITextField))
            {
                let currentTextField = subView as! UITextField
                
                if(currentTextField.tag == 11  || currentTextField.tag == 12 || currentTextField.tag == 13)
                {
                    if(!currentTextField.isValid())
                    {
                        self.showRequiredMessage(currentTextField)
                        return
                    }else{
                        self.disableRequiredMessage(currentTextField)
                        
                        if(currentTextField.tag == 11)
                        {
                            cashInFormDictonary["mobileNumber"] = currentTextField.text
                        }
                        if(currentTextField.tag == 12)
                        {
                            cashInFormDictonary["amount"] = currentTextField.text
                        }
                        if(currentTextField.tag == 13)
                        {
                            cashInFormDictonary["mPIN"] = currentTextField.text
                        }
                    }
                    
                }
            }
        }
        
        self.inqueryServiceRequest()
    }
    
    
    func inqueryServiceRequest ()
    {
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }

        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(cashInFormDictonary["mPIN"] as! String)
        dict[MFATRANSACTION] = INQUIRY
        dict[AMOUNT] = cashInFormDictonary["amount"]  as! NSString

        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANKSINARMAS)
        {
            dict[DESTBANKACCOUNT] = SimaspayUtility.getNormalisedMDN(cashInFormDictonary["mobileNumber"] as! NSString)
            dict[DEST_BANK_CODE] = "153"
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT)
            {
                
                dict[SOURCEPOCKETCODE] = "1"
                dict[DESTPOCKETCODE] = "2"
                dict[SERVICE] = SERVICE_AGENT
            }
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR)
            {
                dict[SOURCEPOCKETCODE] = "2"
                dict[DESTPOCKETCODE] = "2"
                dict[SERVICE] = SERVICE_BANK
            }
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER)
            {
                dict[SOURCEPOCKETCODE] = "2"
                dict[DESTPOCKETCODE] = "2"
                dict[SERVICE] = SERVICE_BANK
            }
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI)
            {
                dict[SOURCEPOCKETCODE] = "6"
                dict[DESTPOCKETCODE] = "2"
                dict[SERVICE] = SERVICE_WALLET
            }
            
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI)
        {
            dict[DESTMDN] = SimaspayUtility.getNormalisedMDN(cashInFormDictonary["mobileNumber"] as! NSString)
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT)
            {
                dict[SOURCEPOCKETCODE] = "1"
                dict[DESTPOCKETCODE] = ""
                dict[SERVICE] = SERVICE_AGENT
            }
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR)
            {
                dict[SOURCEPOCKETCODE] = "2"
                dict[DESTPOCKETCODE] = "6"
                dict[SERVICE] = SERVICE_BANK
            }
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER)
            {
                dict[SOURCEPOCKETCODE] = "2"
                dict[DESTPOCKETCODE] = "6"
                dict[SERVICE] = SERVICE_BANK
            }
            
            if(self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI)
            {
                dict[SOURCEPOCKETCODE] = "6"
                dict[DESTPOCKETCODE] = "6"
                dict[SERVICE] = SERVICE_WALLET
                
            }
            
            dict[TXNNAME] = TXN_INQUIRY_SELFBANK
        }

        print("Transfer  Params : ",dict)
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
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
                    
                    if( messagecode == SIMOBI_SELFBANK_TRANSFER_INQ_SUCCESSCODE)
                    {
                        
                        let transferID  = responseDict.valueForKeyPath("response.transferID.text") as! String
                        let parentTxnID = responseDict.valueForKeyPath("response.parentTxnID.text") as! String
                        let mfaModeStatus = responseDict.valueForKeyPath("response.mfaMode.text") as! String

                        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
                        dict[CONFIRMED] = "true"
                        dict[TRANSFERID] = transferID
                        dict[PARENTTXNID] = parentTxnID
                        dict[TXNNAME] = TXN_CONFIRM_SELFBANK
                        
                        let confirmationTitlesArray = NSMutableArray()
                        let confirmationValuesArray = NSMutableArray()
                        
                        
                        var destinationNumber = SimaspayUtility.getNormalisedMDN(self.cashInFormDictonary["mobileNumber"] as! NSString)
                        let amount = responseDict.valueForKeyPath("response.debitamt.text") as! String
                        
                        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANKSINARMAS)
                        {
                            let accountName = responseDict.valueForKeyPath("response.ReceiverAccountName.text") as! String
                            
                            if(accountName.length > 0)
                            {
                                confirmationTitlesArray[0] = "Nama Pemilik Rekening"
                                confirmationValuesArray[0] = accountName
                            }
                            
                            confirmationTitlesArray[1] = "Bank Tujuan"
                            confirmationValuesArray[1] = "Bank Sinarmas"
                            
                            if(accountName.length > 0)
                            {
                                confirmationTitlesArray[2] = "Nomor Rekening Tujuan"
                                confirmationValuesArray[2] = destinationNumber
                            }
                            
                            if(amount.length > 0)
                            {
                                confirmationTitlesArray[2] = "Jumlah"
                                confirmationValuesArray[2] = "Rp \(amount)"
                            }
                        }
                        
                        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI)
                        {
                            destinationNumber = self.cashInFormDictonary["mobileNumber"] as! NSString
                            let accountName = responseDict.valueForKeyPath("response.ReceiverAccountName.text") as! String
                            
                            if(accountName.length > 0)
                            {
                                confirmationTitlesArray[0] = "Nama Pemilik Rekening"
                                confirmationValuesArray[0] = accountName
                            }

                            if(accountName.length > 0)
                            {
                                confirmationTitlesArray[1] = "Nomor Handphone Tujuan"
                                confirmationValuesArray[1] = destinationNumber
                            }
                            
                            if(amount.length > 0)
                            {
                                confirmationTitlesArray[2] = "Jumlah"
                                confirmationValuesArray[2] = "Rp \(amount)"
                            }
                        }
                        
                        
                        let confirmationViewController = ConfirmationViewController()
                        if(mfaModeStatus == "OTP")
                        {
                            confirmationViewController.showOTPAlert = true
                        }else{
                            confirmationViewController.showOTPAlert = false
                        }
                        confirmationViewController.simasPayOptionType = self.simasPayOptionType
                        confirmationViewController.confirmationTitlesArray = confirmationTitlesArray as Array<AnyObject>
                        confirmationViewController.confirmationValuesArray = confirmationValuesArray as Array<AnyObject>
                        confirmationViewController.confirmationRequestDictonary = dict
                        self.navigationController!.pushViewController(confirmationViewController, animated: true)
                        
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
    
    func showRequiredMessage(currentTextField:UITextField)
    {
        currentTextField.layer.borderWidth = 1
        currentTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
        
        let errorTag = 100+currentTextField.tag-10
        let errorLabel = contentView.viewWithTag(errorTag)
        errorLabel!.hidden = false
    }
    
    func disableRequiredMessage(currentTextField:UITextField)
    {
        currentTextField.layer.borderWidth = 0
        currentTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        let errorTag = 100+currentTextField.tag-10
        let errorLabel = contentView.viewWithTag(errorTag)
        errorLabel!.hidden = true
    }


    
    
}