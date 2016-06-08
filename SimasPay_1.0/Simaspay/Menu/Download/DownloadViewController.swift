//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class DownloadViewController: UIViewController
{
    var cashinScrollview: UIScrollView!
    var simasPayUserType:SimasPayUserType!
    var periodDatePicker:UIDatePicker!
    
    var currentPickerTextField:UITextField!
    
    var isOption1Selected:Bool!
    var isOption2Selected:Bool!
    var isOption3Selected:Bool!
    var isOption4Selected:Bool!
    
    var optionCheckBox1:UIButton!
    var optionCheckBox2:UIButton!
    var optionCheckBox3:UIButton!
    var optionCheckBox4:UIButton!
    
    var option4TextField1:UITextField!
    var option4TextField2:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Mutasi"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        isOption1Selected = true
        isOption2Selected = false
        isOption3Selected = false
        isOption4Selected = false
        
        
        cashinScrollview = UIScrollView()
        cashinScrollview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(cashinScrollview)
        
        
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["cashinScrollview"] = cashinScrollview
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        
        let contentView = UIView()
        cashinScrollview.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        initialScrollViews["contentView"] = contentView
        
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(==cashinScrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let topMargin = 20
        let nextFieldMArgin = 25
        let nextFieldLabelMargin = 37
        let checkBoxWH = 27
        
        
        let titleLabel = UILabel(frame: CGRectMake(0,0, self.view.frame.width, 40))
        titleLabel.text = "Silakan pilih periode transaksi \n yang ingin Anda lihat"
        titleLabel.font = UIFont(name:"HelveticaNeue", size:15)
        titleLabel.textColor = UIColor.downloadViewTitleColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(titleLabel)
        initialScrollViews["titleLabel"] = titleLabel
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(30)-[titleLabel]-\(30)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        
        optionCheckBox1 = self.getOptionCheckBox()
        optionCheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        optionCheckBox1.addTarget(self, action: #selector(DownloadViewController.downloadOption1Selected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(optionCheckBox1)
        initialScrollViews["optionCheckBox1"] = optionCheckBox1
        
        let optionLabel1 = self.getOptionLabel()
        optionLabel1.text = "Bulan ini"
        contentView.addSubview(optionLabel1)
        initialScrollViews["optionLabel1"] = optionLabel1
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox1(\(checkBoxWH))]-10-[optionLabel1]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))

        optionCheckBox2 = self.getOptionCheckBox()
        optionCheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox2.addTarget(self, action: #selector(DownloadViewController.downloadOption2Selected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(optionCheckBox2)
        initialScrollViews["optionCheckBox2"] = optionCheckBox2
        
        let optionLabel2 = self.getOptionLabel()
        optionLabel2.text = "Bulan lalu"
        contentView.addSubview(optionLabel2)
        initialScrollViews["optionLabel2"] = optionLabel2
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox2(\(checkBoxWH))]-10-[optionLabel2]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        optionCheckBox3 = self.getOptionCheckBox()
        optionCheckBox3.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox3.addTarget(self, action: #selector(DownloadViewController.downloadOption3Selected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(optionCheckBox3)
        initialScrollViews["optionCheckBox3"] = optionCheckBox3
        
        let optionLabel3 = self.getOptionLabel()
        optionLabel3.text = "2 bulan lalu"
        contentView.addSubview(optionLabel3)
        initialScrollViews["optionLabel3"] = optionLabel3
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox3(\(checkBoxWH))]-10-[optionLabel3]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))

        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(topMargin)-[titleLabel(42)]-50-[optionCheckBox1(\(checkBoxWH))]-\(nextFieldMArgin)-[optionCheckBox2(\(checkBoxWH))]-\(nextFieldMArgin)-[optionCheckBox3(\(checkBoxWH))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(topMargin)-[titleLabel(42)]-53-[optionLabel1]-\(nextFieldLabelMargin)-[optionLabel2]-\(nextFieldLabelMargin)-[optionLabel3]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        optionCheckBox4 = self.getOptionCheckBox()
        optionCheckBox4.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox4.addTarget(self, action: #selector(DownloadViewController.downloadOption4Selected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(optionCheckBox4)
        initialScrollViews["optionCheckBox4"] = optionCheckBox4
        
        
        let option4Label1 = self.getOptionLabel()
        option4Label1.text = "Periode dari"
        contentView.addSubview(option4Label1)
        initialScrollViews["option4Label1"] = option4Label1
        
        
        option4TextField1 = self.getCustomTextField()
        option4TextField1.tag = 100
        option4TextField1.addTarget(self, action: #selector(DownloadViewController.step1TextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
        option4TextField1.tintColor = UIColor.clearColor()
        contentView.addSubview(option4TextField1)
        initialScrollViews["option4TextField1"] = option4TextField1
        
        let mobilenumberImageView = UIImageView()
        mobilenumberImageView.frame = CGRect(x: 9, y: (option4TextField1.frame.height-20)/2, width: 20, height: 20)
        let phoneImage = UIImage(named: "ic-calendar")
        mobilenumberImageView.image = phoneImage
        
        let mobileNumberView = UIView(frame: CGRectMake(0, 0, 20+18, option4TextField1.frame.height))
        mobileNumberView.addSubview(mobilenumberImageView)
        option4TextField1.rightView = mobileNumberView
        option4TextField1.rightViewMode = UITextFieldViewMode.Always
        
        let mobileNumberView11 = UIView(frame: CGRectMake(0, 0, 10, option4TextField1.frame.height))
        option4TextField1.leftView = mobileNumberView11;
        option4TextField1.leftViewMode = UITextFieldViewMode.Always
        
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox4(\(checkBoxWH))]-10-[option4Label1]-[option4TextField1]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[optionCheckBox3]-\(nextFieldMArgin)-[optionCheckBox4(\(checkBoxWH))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[optionLabel3]-\(nextFieldLabelMargin-2)-[option4Label1]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[optionLabel3]-\(nextFieldLabelMargin-10)-[option4TextField1(35)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let option4Label2 = self.getOptionLabel()
        option4Label2.text = "Hingga"
        contentView.addSubview(option4Label2)
        initialScrollViews["option4Label2"] = option4Label2
        
        option4TextField2 = self.getCustomTextField()
        option4TextField2.tag = 200
        option4TextField2.addTarget(self, action: #selector(DownloadViewController.step1TextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
        option4TextField2.tintColor = UIColor.clearColor()
        contentView.addSubview(option4TextField2)
        initialScrollViews["option4TextField2"] = option4TextField2
        
        let mobilenumberImageView2 = UIImageView()
        mobilenumberImageView2.frame = CGRect(x: 9, y: (option4TextField2.frame.height-20)/2, width: 20, height: 20)
        let phoneImage2 = UIImage(named: "ic-calendar")
        mobilenumberImageView2.image = phoneImage2
    
        let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 20+18, option4TextField2.frame.height))
        mobileNumberView2.addSubview(mobilenumberImageView2);
        option4TextField2.rightView = mobileNumberView2
        option4TextField2.rightViewMode = UITextFieldViewMode.Always
        
        let mobileNumberView12 = UIView(frame: CGRectMake(0, 0, 10, option4TextField2.frame.height))
        option4TextField2.leftView = mobileNumberView12;
        option4TextField2.leftViewMode = UITextFieldViewMode.Always
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox4(\(checkBoxWH))]-10-[option4Label2(==option4Label1)]-[option4TextField2]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[option4TextField1]-\(12)-[option4Label2]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[option4TextField1]-\(5)-[option4TextField2(35)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        contentView.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: #selector(DownloadViewController.downLoadTransactionHistory(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        let buttonMargin = (self.view.frame.size.width-200)/2
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(buttonMargin)-[step1FormAcceptBtn]-\(buttonMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[option4TextField2]-50-[step1FormAcceptBtn(50)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        

        
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
    
    
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    @IBAction func downloadOption1Selected(sender: UIButton)
    {
        optionCheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        optionCheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox3.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox4.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        isOption1Selected = true
        isOption2Selected = false
        isOption3Selected = false
        isOption4Selected = false
        
        option4TextField1.enabled = false
        option4TextField2.enabled = false
    }
    
    @IBAction func downloadOption2Selected(sender: UIButton)
    {
        optionCheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        optionCheckBox3.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox4.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        isOption1Selected = false
        isOption2Selected = true
        isOption3Selected = false
        isOption4Selected = false
        
        option4TextField1.enabled = false
        option4TextField2.enabled = false
    }
    
    @IBAction func downloadOption3Selected(sender: UIButton)
    {
        optionCheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox3.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        optionCheckBox4.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        isOption1Selected = false
        isOption2Selected = false
        isOption3Selected = true
        isOption4Selected = false
        
        option4TextField1.enabled = false
        option4TextField2.enabled = false
    }
    
    @IBAction func downloadOption4Selected(sender: UIButton)
    {
        optionCheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox3.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        optionCheckBox4.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        
        isOption1Selected = false
        isOption2Selected = false
        isOption3Selected = false
        isOption4Selected = true
        
        option4TextField1.enabled = true
        option4TextField2.enabled = true
        
        
    }
    
    
    
    @IBAction func cashInAcceptClicked(sender: UIButton)
    {

        let confirmationViewController = TransactionHistoryViewController()
        self.navigationController!.pushViewController(confirmationViewController, animated: true)
    }
    
    func getOptionLabel()->UILabel
    {
        let optionLabel1 = UILabel()
        optionLabel1.textColor = UIColor.blackColor()
        optionLabel1.font =  UIFont(name:"HelveticaNeue", size:14)
        optionLabel1.translatesAutoresizingMaskIntoConstraints = false
        optionLabel1.textAlignment = NSTextAlignment.Left
        
        return optionLabel1
    }
    
    func getOptionCheckBox()->UIButton
    {
        let optionCheckBox1:UIButton = UIButton()
        optionCheckBox1.backgroundColor = UIColor.clearColor()
        optionCheckBox1.translatesAutoresizingMaskIntoConstraints = false
        return optionCheckBox1
    }
    
    func getCustomTextField()->UITextField
    {
        let checkBoxTextField1 = UITextField(frame: CGRect.zero)
        checkBoxTextField1.backgroundColor = UIColor.whiteColor()
        checkBoxTextField1.enabled = false
        checkBoxTextField1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
        checkBoxTextField1.translatesAutoresizingMaskIntoConstraints = false
        checkBoxTextField1.borderStyle = .None
        checkBoxTextField1.layer.cornerRadius = 5
        checkBoxTextField1.text = "DD-MM-YYYY"
        
        return checkBoxTextField1
    }
    
    
    
    @IBAction func step1TextFieldEditing(sender: UITextField) {
        
        self.currentPickerTextField = sender
        
        periodDatePicker = UIDatePicker()
        
        periodDatePicker.datePickerMode = .Date
        
        
        
        if(sender.tag == 200) // To Date
        {
            if(option4TextField1.text == "DD-MM-YYYY")
            {
                SimasPayAlert.showSimasPayAlert("Harap lengkapi tanggal periode transaksi",viewController: self)
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            
            let fromDate = dateFormatter.dateFromString(option4TextField1.text!)
            let numberDays = SimasPayPlistUtility.daysBetweenDate(fromDate, andDate: NSDate())
            
            if(numberDays <= 90)
            {
                periodDatePicker.maximumDate = NSDate()
            }else{
                let toDateString = SimasPayPlistUtility.dateForThreeMonths(3, fromDate: fromDate)
                periodDatePicker.maximumDate = toDateString
            }
            
            
            periodDatePicker.minimumDate = fromDate
            
        }else{
            
            periodDatePicker.maximumDate = NSDate()
        }
        
        

        
        
        
        
        periodDatePicker.addTarget(self, action: #selector(DownloadViewController.datePickerValueChanged(_:)), forControlEvents: .ValueChanged)
        sender.inputView = periodDatePicker
    }
    
    // 7
    func datePickerValueChanged(sender:UIDatePicker) {
        self.currentPickerTextField.text = self.formatDate(sender.date)
    }

    func formatDate(date:NSDate)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate:String = dateFormatter.stringFromDate(date)
        return formattedDate
        
    }
    
    func timeStampfromDate(date:NSDate)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "ddMMyyyy"
        let formattedDate:String = dateFormatter.stringFromDate(date)
        return formattedDate
    }
    
    func downLoadTransactionHistory(sender: UIButton)
    {
     
        var fromDateString = ""
        var toDateString = ""
        
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .ShortStyle
        dateFormatter1.dateFormat = "MM"
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateStyle = .ShortStyle
        dateFormatter2.dateFormat = "yyyy"
        
        if (isOption1Selected == true)
        {
            fromDateString = self.timeStampfromDate(SimasPayPlistUtility.dateFromPeriodType(0))
            toDateString = self.timeStampfromDate(NSDate()) as String
        }
        
        
        if(isOption2Selected == true)
        {
            
            let monthString = dateFormatter1.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(1))
            let yearString = dateFormatter2.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(1))
            fromDateString = "01\(monthString)\(yearString)"
            
            
            let dateString = "\(dateFormatter1.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(1)))\(dateFormatter2.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(1)))"
            
            toDateString = "\(SimasPayPlistUtility.getNumberOfDaysInMonth(dateString).length)\(dateString)"
            
        }
        
        
        if(isOption3Selected == true)
        {

            let monthString = dateFormatter1.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(2))
            
            let yearString = dateFormatter2.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(2))
            
            fromDateString = "01\(monthString)\(yearString)"
            
            let dateString = "\(dateFormatter1.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(1)))\(dateFormatter2.stringFromDate(SimasPayPlistUtility.dateFromPeriodType(1)))"
            
            toDateString = "\(SimasPayPlistUtility.getNumberOfDaysInMonth(dateString).length)\(dateString)"
            
        }
        
        if(isOption4Selected == true)
        {
            fromDateString = (option4TextField1.text?.stringByReplacingOccurrencesOfString("-", withString: ""))!
            toDateString = (option4TextField2.text?.stringByReplacingOccurrencesOfString("-", withString: ""))!
        }
        
        print("From date String \(fromDateString)")
        print("To date String \(toDateString)")
                
        self.gotoTransactionViewController(fromDateString, toDateString: toDateString)
    }
    
    func gotoTransactionViewController(fromDate:NSString,toDateString:NSString)
    {
        // NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[SimobiManager shareInstance] sourceMDN],SOURCEMDN,[[SimobiManager shareInstance] sourcePIN],SOURCEPIN,@"2",SOURCEPOCKETCODE,TXN_ACCOUNT_HISTORY,TXNNAME,SERVICE_BANK,SERVICE,nil];
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        dict[TXNNAME] = TXN_ACCOUNT_HISTORY
        dict[FROM_DATE] = fromDate
        dict[TO_DATE] = toDateString
        dict[PAGENUMBER] = "0"
        
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER || self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR){
            dict[SOURCEPOCKETCODE] = "2"
            dict[SERVICE] = SERVICE_BANK
        }
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI){
            dict[SOURCEPOCKETCODE] = "6"
            dict[SERVICE] = SERVICE_WALLET
        }
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT){
            dict[SOURCEPOCKETCODE] = "1"
            dict[SERVICE] = SERVICE_WALLET
        }
        
        print("Request  Params : ",dict)
        
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
                    
                    print("Transaction History Response : ",response)
                    
                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    
                    
                    if( messagecode == SIMAPAY_TRANSACTION_HISTORY_CODE)
                    {
                        let moreRecordsAvailabe  = responseDict.valueForKeyPath("response.MoreRecordsAvailable.text") as! String
                        let transactionCount  = responseDict.valueForKeyPath("response.totalTxnCount.text") as! String
                        
                        let transactionArray:NSArray
                        
                        if(transactionCount == "1")
                        {
                           let tempTransactionArray = NSMutableArray()
                           let transactionDict = responseDict.valueForKeyPath("response.transactionDetails.transactionDetail") as! NSDictionary
                            tempTransactionArray.addObject(transactionDict)
                           transactionArray = tempTransactionArray
                            
                        }else{
                          transactionArray = responseDict.valueForKeyPath("response.transactionDetails.transactionDetail") as! NSArray
                        }
                        
                        //06 Nov ’15 - 29 Nov ‘15
                        
                        
                        
                        
                        if(transactionArray.count > 0)
                        {
                            let transactionViewController = TransactionHistoryViewController()
                            transactionViewController.confirmationRequestDictonary = dict
                            
                            if(moreRecordsAvailabe == "true")
                            {
                               transactionViewController.isMoreDataAvailable = true
                            }else{
                                transactionViewController.isMoreDataAvailable = false
                            }
                            transactionViewController.periodString = "\(self.periodFormatDate(fromDate as String)) - \(self.periodFormatDate(toDateString as String))"
                            transactionViewController.simasPayUserType = self.simasPayUserType
                            transactionViewController.transactionArray = transactionArray as! NSMutableArray
                            self.navigationController!.pushViewController(transactionViewController, animated: true)
                        }else{
                            SimasPayAlert.showSimasPayAlert("No Transaction Found.",viewController: self)
                        }
                        
                        
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                        
                        if( messagecode == SIMASPAY_LOGIN_EXPIRE_CODE)
                        {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    }
                    
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                //SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController: (self.window?.rootViewController)!)
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                }
                
        })
    }
    
    func periodFormatDate(date:String)->String
    {
        //01042016
        //06 Nov ’15
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.dateFormat = "ddMMyyyy"
        
        let formattedDate:NSDate = dateFormatter.dateFromString(date)!
        dateFormatter.dateFormat = "dd MMM '''"
        //"dd MMM '''yyyy"
        var periodFormattedDate:String = dateFormatter.stringFromDate(formattedDate)
        dateFormatter.dateFormat = "yy"
        
        periodFormattedDate = periodFormattedDate.stringByAppendingString(dateFormatter.stringFromDate(formattedDate))
        
        
        return periodFormattedDate
        
    }
    
}