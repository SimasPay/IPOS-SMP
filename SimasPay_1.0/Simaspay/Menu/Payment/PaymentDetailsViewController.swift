//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class PaymentDetailsViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    var cashinScrollview: UIScrollView!
    var simasPayOptionType:SimasPayOptionType!
    var simasPayUserType:SimasPayUserType!
    
    var contentView:UIView!
    var cashInFormDictonary:NSMutableDictionary!
    var selectedProduct:NSDictionary!
    
    var selectedBillerText:String!
    
    var step1PickerTextField:UITextField!
    var pickerViewData:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        var fieldNamesArray : [NSString] = []
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            self.title = "Pembayaran"
            
            let invoiceType = selectedProduct.valueForKey("invoiceType") as! NSString
            let invoiceTypeAray = invoiceType.componentsSeparatedByString("|")
            
            fieldNamesArray = ["Nama Produk",invoiceTypeAray[1],"mPIN"]
        }
        
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
        {
            let invoiceType = selectedProduct.valueForKey("invoiceType") as! NSString
            let invoiceTypeAray = invoiceType.componentsSeparatedByString("|")
            
            let nominalType = selectedProduct.valueForKey("Nominaltype") as! NSString
            
            self.title = "Pembelian"
            fieldNamesArray = ["Nama Produk",nominalType,invoiceTypeAray[1],"mPIN"]
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
            
            if( i == 1)
            {
                step1TextField.enabled = false
                step1TextField.text = self.selectedBillerText
                step1TextField.backgroundColor =  UIColor(netHex: Constants.TextFieldDisableBackcolor)
            }
            
            
            if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
            {
                if( i == 2 || i == 3){
                    step1TextField.keyboardType = .NumberPad
                    if( i == 3)
                    {step1TextField.secureTextEntry = true}
                }
            }
            
            
            if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
            {
                if( i == 3 || i == 4){
                    step1TextField.keyboardType = .NumberPad
                
                    if( i == 4)
                    {step1TextField.secureTextEntry = true}
                }
                
                if( i == 2)
                {
                    
                    if(self.selectedProduct.valueForKey("isPLNPrepaid") != nil && self.selectedProduct.valueForKey("isPLNPrepaid") as! String == "true")
                    {
                        step1TextField.keyboardType = .NumberPad
                        let rupeeLabel = UILabel()
                        rupeeLabel.frame = CGRect(x: 10, y: (step1TextField.frame.height-20)/2, width: 15, height: 20)
                        rupeeLabel.text = "Rp"
                        rupeeLabel.textColor = UIColor.blackColor()
                        rupeeLabel.font = UIFont(name:"HelveticaNeue", size:11)
                        
                        let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 15+15, step1TextField.frame.height))
                        mobileNumberView2.addSubview(rupeeLabel);
                        step1TextField.leftView = mobileNumberView2
                        step1TextField.leftViewMode = UITextFieldViewMode.Always
                        
                    }else{
                     
                        step1TextField.placeholder = "Pilih"
                        let dropDownImage = UIImage(named: "btn-dropdown")
                        let dropDownButton = UIButton()
                        dropDownButton.frame = CGRect(x:0, y: (step1TextField.frame.height-10)/2, width: 16, height: 10)
                        dropDownButton.addTarget(self, action: #selector(PaymentDetailsViewController.nominalAmountClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                        dropDownButton.setBackgroundImage(dropDownImage, forState: UIControlState.Normal)
                        
                        let dropDownView = UIView(frame: CGRectMake(0, 0, 15+18, step1TextField.frame.height))
                        dropDownView.addSubview(dropDownButton)
                        step1TextField.rightView = dropDownView
                        step1TextField.rightViewMode = UITextFieldViewMode.Always
                        
                        step1TextField.delegate = self
                        step1TextField.addTarget(self, action: #selector(PaymentDetailsViewController.pickerTextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
                        
                        let denomtring = self.selectedProduct.valueForKey("Denom") as! NSString
                        self.pickerViewData = denomtring.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "|"))
                    }
                    

                }
                
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
        step1FormAcceptBtn.addTarget(self, action: #selector(PaymentDetailsViewController.cashInAcceptClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        
        let buttonMargin = (self.view.frame.size.width-200)/2
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step1FormAcceptBtn]-(\(buttonMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        vertical_constraints += "[step1FormAcceptBtn(50)]-\(extraEndSpace)-|"

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
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
    
    @IBAction func nominalAmountClicked(sender: UIButton)
     {
        
     }

    @IBAction func cashInAcceptClicked(sender: UIButton)
    {
        cashInFormDictonary = NSMutableDictionary()
        
        for  subView in contentView.subviews
        {
            if (subView.isKindOfClass(UITextField))
            {
                let currentTextField = subView as! UITextField
                
                if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
                {
                    if(currentTextField.tag == 11  || currentTextField.tag == 12  || currentTextField.tag == 13 || currentTextField.tag == 14)
                    {
                        if(!currentTextField.isValid())
                        {
                            self.showRequiredMessage(currentTextField)
                            return
                        }else{
                            self.disableRequiredMessage(currentTextField)
                            
                            if(currentTextField.tag == 11)
                            {
                                cashInFormDictonary["productName"] = currentTextField.text
                            }
                            
                            if(currentTextField.tag == 12)
                            {
                                cashInFormDictonary["amount"] = currentTextField.text
                            }
                            if(currentTextField.tag == 13)
                            {
                                cashInFormDictonary["mobileNumber"] = currentTextField.text
                            }
                            if(currentTextField.tag == 14)
                            {
                                cashInFormDictonary["mPIN"] = currentTextField.text
                            }
                        }
                        
                    }
                }

                if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
                {
                    if(currentTextField.tag == 11  || currentTextField.tag == 12  || currentTextField.tag == 13)
                    {
                        if(!currentTextField.isValid())
                        {
                            self.showRequiredMessage(currentTextField)
                            return
                        }else{
                            self.disableRequiredMessage(currentTextField)
                            
                            if(currentTextField.tag == 11)
                            {
                                cashInFormDictonary["productName"] = currentTextField.text
                            }
                            
                            if(currentTextField.tag == 12)
                            {
                                cashInFormDictonary["mobileNumber"] = currentTextField.text
                            }
                            if(currentTextField.tag == 13)
                            {
                                cashInFormDictonary["mPIN"] = currentTextField.text
                            }
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
        //dict[BILLNO] = SimaspayUtility.getNormalisedMDN(cashInFormDictonary["mobileNumber"] as! NSString)
        dict[BILLNO] = cashInFormDictonary["mobileNumber"]
        dict[BILLERCODE] = self.selectedProduct.valueForKey("productCode") as! NSString
        dict[PAYMENT_MODE] = self.selectedProduct.valueForKey("paymentMode") as! NSString
        
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER || self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR){
            dict[SOURCEPOCKETCODE] = "2"
        }
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI){
            dict[SOURCEPOCKETCODE] = "6"
        }
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT){
            dict[SOURCEPOCKETCODE] = "1"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT || self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR)
            {
               dict[SERVICE] = SERVICE_AGENT
            }else{
               dict[SERVICE] = SERVICE_PAYMENT
            }
            
            dict[TXNNAME] = TXN_INQUIRY_PAYMENT
        }
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
        {
            if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT || self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR)
            {
                dict[SERVICE] = SERVICE_AGENT
            }else{
                dict[SERVICE] = SERVICE_PURCHASE_AIRTIME
            }
            
            dict[TXNNAME] = TXN_INQUIRY_PURCHASE_AIRTIME
            dict[AMOUNT] = cashInFormDictonary["amount"]  as! NSString
            dict[DENOM_CODE] = cashInFormDictonary["amount"]  as! NSString
        }
        
        dict[MFATRANSACTION] = INQUIRY
        
        print("Cashin Params  : ",dict)
        
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
                    
                    if( messagecode == SIMOBI_PURCHASE_SUCCESSCODE || messagecode == SIMOBI_PAYMENT_SUCCESSCODE)
                    {
                        
                        let transferID  = responseDict.valueForKeyPath("response.transferID.text") as! String
                        let parentTxnID = responseDict.valueForKeyPath("response.parentTxnID.text") as! String
                        let mfaModeStatus = responseDict.valueForKeyPath("response.mfaMode.text") as! String
                        let sctlID = responseDict.valueForKeyPath("response.sctlID.text") as! String
                        
                        let charges = responseDict.valueForKeyPath("response.charges.text") as! String
                        let totalDebitAmount = responseDict.valueForKeyPath("response.debitamt.text") as! String
                        
                        //transferID=7431& destMDN=6211111424& sourceMDN=8978978878& confirmed=true& parentTxnID=1019725& institutionID=simobi&channelID=7&service=AgentServices&authenticationKey=&bankID=&txnName=CashIn
                        
                        dict[TRANSFERID] = transferID
                        dict[CONFIRMED] = "true"
                        dict[PARENTTXNID] = parentTxnID
                        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
                        dict[MFATRANSACTION] = SIMASPAY_CONFIRM
                        dict[SCTL_ID] = sctlID
                    
                        let confirmationTitlesArray = NSMutableArray()
                        let confirmationValuesArray = NSMutableArray()
                        
                        let productName = self.cashInFormDictonary.valueForKey("productName") as! NSString
                        let destinationNumber = responseDict.valueForKeyPath("response.invoiceNo.text") as! String
                        let amount = responseDict.valueForKeyPath("response.creditamt.text") as! String

                        if(productName.length > 0)
                        {
                            confirmationTitlesArray[0] = "Nama Produk"
                            confirmationValuesArray[0] = productName
                        }
                        
                        
                        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
                        {
                            self.title = "Pembayaran"
                            
                            
                        }
                        
                        
                        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
                        {
                            dict[TXNNAME] = TXN_CONFIRM_PURCHASE_AIRTIME
                            
                            //let noinalAmount = self.cashInFormDictonary["amount"]  as! NSString
                            
                            let invoiceType = self.selectedProduct.valueForKey("invoiceType") as! NSString
                            let invoiceTypeAray = invoiceType.componentsSeparatedByString("|")
                            
                            let nominalType = self.selectedProduct.valueForKey("Nominaltype") as! NSString
                            
                            
                            if(amount.length > 0)
                            {
                                confirmationTitlesArray[1] = nominalType
                                confirmationValuesArray[1] = "Rp \(amount)"
                            }
                            
                            if(destinationNumber.length > 0)
                            {
                                confirmationTitlesArray[2] = invoiceTypeAray[1]
                                confirmationValuesArray[2] = destinationNumber
                            }
                            
                        }
                        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
                        {
                            dict[TXNNAME] = TXN_CONFIRM_PAYMENT

                            let invoiceType = self.selectedProduct.valueForKey("invoiceType") as! NSString
                            let invoiceTypeAray = invoiceType.componentsSeparatedByString("|")
                            
                            if(destinationNumber.length > 0)
                            {
                                confirmationTitlesArray[1] = invoiceTypeAray[1]
                                confirmationValuesArray[1] = destinationNumber
                            }
                            
                            if(amount.length > 0)
                            {
                                confirmationTitlesArray[2] = "Jumlah"
                                confirmationValuesArray[2] = "Rp \(amount)"
                            }
                        }
                        
                        
                        if(charges.length > 0)
                        {
                            confirmationTitlesArray[3] = "Biaya Administrasi"
                            confirmationValuesArray[3] = "Rp \(charges)"
                        }
                        
                        
                        if(totalDebitAmount.length > 0)
                        {
                            confirmationTitlesArray[4] = "Total Pendebitan"
                            confirmationValuesArray[4] = "Rp \(totalDebitAmount)"
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
    
    @IBAction func pickerTextFieldEditing(sender: UITextField) {
        
        self.step1PickerTextField = sender
        // 6
        let datePickerView:UIPickerView = UIPickerView()
        datePickerView.delegate = self
        sender.inputView = datePickerView
        
        self.step1PickerTextField.text = pickerViewData[0] as? String
    }
    
    
    // MARK: UIPickerView Delegate Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1}
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerViewData.count}
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row] as? String}
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.step1PickerTextField.text = pickerViewData[row] as? String}
}