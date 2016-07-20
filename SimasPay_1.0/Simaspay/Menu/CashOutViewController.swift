//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class CashOutViewController: UIViewController,UITextFieldDelegate
{
    var cashinScrollview: UIScrollView!
    var contentView:UIView!
    var cashInFormDictonary:NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Tarik Tunai"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]

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
        
        let fieldNamesArray : [NSString] = ["Nomor Handphone Agen","Jumlah","mPIN"]
        
        for i in 1...3 {
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
            
            if( i == 1 || i == 2 || i == 3){
                step1TextField.keyboardType = .NumberPad
            }
            
            if( i == 3)
            {
                step1TextField.delegate = self
                step1TextField.secureTextEntry = true
            }
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
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            
            vertical_constraints  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step1TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
            
        }
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        contentView.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: #selector(CashOutViewController.cashInAcceptClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        let buttonMargin = (self.view.frame.size.width-200)/2
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step1FormAcceptBtn]-(\(buttonMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        vertical_constraints += "[step1FormAcceptBtn(50)]-\(extraEndSpace)-|"

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CashOutViewController.dismissKeyboard))
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
                            if(currentTextField.text?.length < 6)
                            {
                                SimasPayAlert.showSimasPayAlert("mPIN yang Anda masukkan harus 6 angka.", viewController: self)
                                return
                            }
                            
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
    
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SERVICE] = SERVICE_WALLET
        dict[TXNNAME] = TXN_CASHOUT_INQUERY
        dict[AMOUNT] = cashInFormDictonary["amount"]  as! NSString
        //dict[DESTMDN] = SimaspayUtility.getNormalisedMDN(cashInFormDictonary["mobileNumber"] as! NSString)
        dict[DESTMDN] = cashInFormDictonary["mobileNumber"]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(cashInFormDictonary["mPIN"] as! String)
        dict[MFATRANSACTION] = INQUIRY
        
        dict[SOURCEPOCKETCODE] = "6"
        dict[DESTPOCKETCODE] = "6" //"1"
        
        print("Inquery Params : ",dict)
        
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
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
                    
                     print("Confirmation Response : ",response)
                    
                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    if( messagecode == SIMASPAY_CAHSIN_CASHOUT_INQUERY_SUCCESS)
                    {
                        
                        let transferID  = responseDict.valueForKeyPath("response.transferID.text") as! String
                        let parentTxnID = responseDict.valueForKeyPath("response.parentTxnID.text") as! String
                        let mfaModeStatus = responseDict.valueForKeyPath("response.mfaMode.text") as! String
                        let sctlID = responseDict.valueForKeyPath("response.sctlID.text") as! String
                        
                        //transferID=7438&destMDN=8978978878&sourceMDN=6211111424&confirmed=true&parentTxnID=1019770& channelID=7&service=Wallet&mfaTransaction=Confirm&mfaOtp=7E7CE&authenticationKey=&txnName=CashOut
                        
                        dict[TXNNAME] = TXN_CASHOUT_CONFIRMATION
                        dict[TRANSFERID] = transferID
                        dict[CONFIRMED] = "true"
                        dict[PARENTTXNID] = parentTxnID
                        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
                        dict[SCTL_ID] = sctlID
                        
                        let confirmationTitlesArray = NSMutableArray()
                        let confirmationValuesArray = NSMutableArray()
                        
                        let accountName = responseDict.valueForKeyPath("response.name.text") as! String
                        //SimaspayUtility.getNormalisedMDN(self.cashInFormDictonary["mobileNumber"] as! NSString)
                        let destinationNumber = self.cashInFormDictonary["mobileNumber"] as! NSString
                        let amount = responseDict.valueForKeyPath("response.debitamt.text") as! String
                        
                        if(accountName.length > 0)
                        {
                            confirmationTitlesArray[0] = "Nama Agen"
                            confirmationValuesArray[0] = accountName
                        }
                        
                        if(accountName.length > 0)
                        {
                            confirmationTitlesArray[1] = "Nomor Handphone Agen"
                            confirmationValuesArray[1] = destinationNumber
                        }
                        
                        if(amount.length > 0)
                        {
                            confirmationTitlesArray[2] = "Jumlah"
                            confirmationValuesArray[2] = "Rp \(amount)"
                        }
                        
                        let confirmationViewController = ConfirmationViewController()
                        if(mfaModeStatus == "OTP")
                        {
                            confirmationViewController.showOTPAlert = true
                        }else{
                            confirmationViewController.showOTPAlert = false
                        }
                        confirmationViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_TARIK_TUNAI
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
    
    // MARK: UITextField Delegate Methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool
    {
        let maxLength = 6
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return  newString.length <= maxLength
        
    }
}