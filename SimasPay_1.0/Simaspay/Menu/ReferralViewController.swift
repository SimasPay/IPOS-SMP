//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class ReferralViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate
{
    var cashinScrollview: UIScrollView!
    var contentView:UIView!
    var cashInFormDictonary:NSMutableDictionary!
    
    var step1PickerTextField:UITextField!
    
    var pickerViewData:NSArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Referensi Nasabah"
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
        
        let fieldNamesArray : [NSString] = ["Nama Lengkap*","Nomor Handphone*","E-mail","Produk yang Diinginkan*"]
        
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
            
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            
            vertical_constraints  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step1TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
            
            if( i == 1){
                step1TextField.keyboardType = .NamePhonePad
            }
            if( i == 2 ){
                step1TextField.keyboardType = .NumberPad
            }
            if( i == 3){
                step1TextField.keyboardType = .EmailAddress
            }
            

            if( i == 4)
            {
                step1TextField.text = "Lainnya"
                let dropDownImage = UIImage(named: "btn-dropdown")
                let dropDownButton = UIButton()
                dropDownButton.frame = CGRect(x:0, y: (step1TextField.frame.height-9)/2, width: 16, height: 9)
                dropDownButton.setImage(dropDownImage, forState: UIControlState.Normal)
                dropDownButton.addTarget(self, action: #selector(ReferralViewController.pickerTextFieldEditing(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                let dropDownView = UIView(frame: CGRectMake(0, 0, 16+5, step1TextField.frame.height))
                dropDownView.addSubview(dropDownButton)
                step1TextField.rightView = dropDownView
                step1TextField.rightViewMode = UITextFieldViewMode.Always
                
                step1TextField.delegate = self
                step1TextField.addTarget(self, action: #selector(ReferralViewController.pickerTextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
                
            }
            
            if( i == fieldNamesArray.count)
            {
                
                let step2TextField = UITextView(frame: CGRect.zero)
                step2TextField.text = "Sebutkan…"
                step2TextField.backgroundColor = UIColor.whiteColor()
                step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2TextField.translatesAutoresizingMaskIntoConstraints = false
                step2TextField.layer.cornerRadius = 5
                step2TextField.editable = false
                step2TextField.delegate = self
                step2TextField.keyboardType = .NamePhonePad
                step2TextField.textColor = UIColor.lightGrayColor()
                contentView.addSubview(step2TextField)
                step2TextField.tag = 10+i+1
                initialScrollViews["step2TextField1_\(i)"] = step2TextField
                
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField1_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
                
                
                vertical_constraints  += "[step2TextField1_\(i)(\(70))]-\(nextFieldMArgin)-"
                
            }
            
            
            
            
        }
        
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        contentView.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: #selector(ReferralViewController.cashInAcceptClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(60)-[step1FormAcceptBtn]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        vertical_constraints += "[step1FormAcceptBtn(50)]-\(extraEndSpace)-|"
        
        
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReferralViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if(self.pickerViewData.count > 0)
        {
            let firstTextField = contentView.viewWithTag(14) as! UITextField
            let workObj = self.pickerViewData[0] as! NSDictionary
            firstTextField.text = workObj.valueForKey("referrealName") as? String
        }
        
        
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
        
        var isProductSelected = false
        
        for  subView in contentView.subviews
        {
            if (subView.isKindOfClass(UITextField))
            {
                let currentTextField = subView as! UITextField
                
                if(currentTextField.tag == 11  || currentTextField.tag == 12 )
                {
                    if(!currentTextField.isValid())
                    {
                        self.showRequiredMessage(currentTextField)
                        return
                    }else{
                        self.disableRequiredMessage(currentTextField)
                        
                        if(currentTextField.tag == 11)
                        {
                            cashInFormDictonary["fullName"] = currentTextField.text
                        }
                        if(currentTextField.tag == 12)
                        {
                            cashInFormDictonary["mobileNumber"] = currentTextField.text
                        }
                    }
                }
                
                if(currentTextField.tag == 13)
                {
                    
                    if(currentTextField.isValid())
                    {
                        if(SimaspayUtility.isValidEmail(currentTextField.text!))
                        {
                            cashInFormDictonary["emailID"] = currentTextField.text
                        }else{
                            SimasPayAlert.showSimasPayAlert("Please Enter a Valid Email-id",viewController: self)
                            return
                        }
                    }else{
                        
                        cashInFormDictonary["emailID"] = ""
                    }
                }
                
                if(currentTextField.tag == 14)
                {
                    if(currentTextField.text != "Lainnya")
                    {
                        self.disableRequiredMessage(currentTextField)
                        
                        if(currentTextField.tag == 14)
                        {
                            cashInFormDictonary["productDesired"] = currentTextField.text
                            cashInFormDictonary["others"] = ""
                            isProductSelected = true
                        }
                    }
                }
            }
            
            if (subView.isKindOfClass(UITextView) && !isProductSelected)
            {
                let productDesiredTextField = contentView.viewWithTag(14) as! UITextField
                let currentTextView = subView as! UITextView
                
                if(currentTextView.tag == 15)
                {
                    if(productDesiredTextField.text == "Lainnya" && currentTextView.text == "Sebutkan…")
                    {
                        self.showRequiredTextViewMessage(currentTextView)
                        return
                    }else{
                        
                        self.disableRequiredTextViewMessage(currentTextView)
                           cashInFormDictonary["others"] = currentTextView.text
                           cashInFormDictonary["productDesired"] = productDesiredTextField.text
                    }
                }
            }
        }
        
        self.inqueryServiceRequest()
    }
    
    
    func inqueryServiceRequest ()
    {
        //destMDN=6212345122&sourceMDN=621234567890&sourcePIN=xxxxxxx&others=Others&email=a@b.com& channelID=7&service=AgentServices&authenticationKey=&fullName=Sun&productDesired=Others&txnName=ProductReferral
        
        let emailId = cashInFormDictonary["emailID"] as! NSString
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SERVICE] = SERVICE_AGENT
        dict[TXNNAME] = TXN_PRODUCT_REFERRAL
        
        //dict[DESTMDN] = SimaspayUtility.getNormalisedMDN(cashInFormDictonary["mobileNumber"] as! NSString)
        dict[DESTMDN] = cashInFormDictonary["mobileNumber"]
        dict[FULL_NAME] = cashInFormDictonary["fullName"] as! NSString
        
        if(emailId.length > 0)
        {
           dict[EMAIL] = emailId
        }else{
            dict[EMAIL] = ""
        }
        
        
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        dict[SERVICE] = SERVICE_AGENT
        
        dict[OTHERS] = cashInFormDictonary["others"] as! NSString
        dict[PRODUCT_DESIRED] = cashInFormDictonary["productDesired"] as! NSString
        
        let confirmationTitlesArray = NSMutableArray()
        let confirmationValuesArray = NSMutableArray()
        
        let fullName = cashInFormDictonary["fullName"] as! NSString
        
        // SimaspayUtility.getNormalisedMDN(self.cashInFormDictonary["mobileNumber"] as! NSString)
        
        let destinationNumber = self.cashInFormDictonary["mobileNumber"] as! NSString
        
        var index = 0
        if(fullName.length > 0)
        {
            confirmationTitlesArray[index] = "Nama Lengkap"
            confirmationValuesArray[index] = fullName
            index += 1
        }
        
        if(destinationNumber.length > 0)
        {
            confirmationTitlesArray[index] = "Nomor Handphone"
            confirmationValuesArray[index] = destinationNumber
            index += 1
        }
        
        if(emailId.length > 0)
        {
            confirmationTitlesArray[index] = "E-mail"
            confirmationValuesArray[index] = emailId
            index += 1
        }
        
        
        let productDesiredTextField = contentView.viewWithTag(14) as! UITextField
        if(productDesiredTextField.text == "Lainnya")
        {
            confirmationTitlesArray[index] = "Produk yang Diinginkan"
            confirmationValuesArray[index] = cashInFormDictonary["others"] as! NSString
            index += 1
        }else{
            confirmationTitlesArray[index] = "Produk yang Diinginkan"
            confirmationValuesArray[index] = cashInFormDictonary["productDesired"] as! NSString
            index += 1
        }
    
        print("Cashin Params  : ",dict)
        
        let confirmationViewController = ConfirmationViewController()
        confirmationViewController.showOTPAlert = false
        confirmationViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_REFERRAL
        confirmationViewController.confirmationTitlesArray = confirmationTitlesArray as Array<AnyObject>
        confirmationViewController.confirmationValuesArray = confirmationValuesArray as Array<AnyObject>
        confirmationViewController.confirmationRequestDictonary = dict
        self.navigationController!.pushViewController(confirmationViewController, animated: true)

    }
    
    func showRequiredTextViewMessage(currentTextField:UIView)
    {
        currentTextField.layer.borderWidth = 1
        currentTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
        
        let errorTag = 104
        let errorLabel = contentView.viewWithTag(errorTag)
        errorLabel!.hidden = false
    }
    
    func disableRequiredTextViewMessage(currentTextField:UIView)
    {
        currentTextField.layer.borderWidth = 0
        currentTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        let errorTag = 104
        let errorLabel = contentView.viewWithTag(errorTag)
        errorLabel!.hidden = true
    }
    
    func showRequiredMessage(currentTextField:UIView)
    {
        currentTextField.layer.borderWidth = 1
        currentTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
        
        let errorTag = 100+currentTextField.tag-10
        let errorLabel = contentView.viewWithTag(errorTag)
        errorLabel!.hidden = false
    }
    
    func disableRequiredMessage(currentTextField:UIView)
    {
        currentTextField.layer.borderWidth = 0
        currentTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        let errorTag = 100+currentTextField.tag-10
        let errorLabel = contentView.viewWithTag(errorTag)
        errorLabel!.hidden = true
    }
    
    
    
    @IBAction func pickerTextFieldEditing(sender: AnyObject) {
        
        let firstTextField = contentView.viewWithTag(14) as! UITextField
        
        self.step1PickerTextField = firstTextField
        // 6
        let datePickerView:UIPickerView = UIPickerView()
        datePickerView.delegate = self
        firstTextField.inputView = datePickerView
        
        
    }
    
    
    // MARK: UIPickerView Delegate Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return pickerViewData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let refListObject = pickerViewData[row]
        return refListObject.valueForKey("referrealName") as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        let refListObject = pickerViewData[row]
        self.step1PickerTextField.text = refListObject.valueForKey("referrealName") as? String
        
        for  subView in contentView.subviews
        {
            if (subView.isKindOfClass(UITextView))
            {
                let productDesiredTextField = contentView.viewWithTag(14) as! UITextField
                let currentTextView = subView as! UITextView
                if(currentTextView.tag == 15)
                {
                    if(productDesiredTextField.text == "Lainnya")
                    {
                        currentTextView.editable = true
                    }else{
                        currentTextView.text = "Sebutkan…"
                        currentTextView.textColor = UIColor.lightGrayColor()
                        currentTextView.editable = false
                    }
                }
            }
            
        }

        dismissKeyboard()
        //print("selected option \(pickerViewData[row])")
    }
    

    // MARK: UITextView Delegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Sebutkan…"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}