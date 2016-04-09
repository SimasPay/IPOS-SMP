//
//  TransactionHistoryViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit
import QuickLook

class TransactionHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate
{
    
    var simasPayOptionType:SimasPayOptionType!
    var simasPayUserType:SimasPayUserType!
    var transactionArray :NSMutableArray =  NSMutableArray()
    
    var confirmationRequestDictonary = NSMutableDictionary() as [NSObject : AnyObject]
    
    var currentPageNumber = 0
    var historyTabeView:UITableView!
    var isMoreDataAvailable = false
    
    var filePath:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        /*let optionDict1 = ["date":"06/11/2015","type":"Transfer","isCredit":"credit","amount":"Rp 500.000"]
        let optionDict2 = ["date":"06/11/2015","type":"Bill Payme","isCredit":"debit","amount":"-Rp 35.000"]
        let optionDict3 = ["date":"Transfer","type":"Admin Fee","isCredit":"debit","amount":"-Rp 10.000"]
        let optionDict4 = ["date":"Transfer","type":"ATM Withdr","isCredit":"debit","amount":"-Rp 500.000"]
        let optionDict5 = ["date":"08/11/2015","type":"Transfer","isCredit":"credit","amount":"Rp 500.000"]
        let optionDict6 = ["date":"12/11/2015","type":"ATM Withdr","isCredit":"debit","amount":"-Rp 500.000"]
        let optionDict7 = ["date":"29/11/2015","type":"ATM Withdr","isCredit":"debit","amount":"-Rp 500.000"]

        transactionArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6,optionDict7] */
        
        //transactionArray = NSMutableArray()
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REGULAR_TRANSAKSI)
        {
            self.title = "Transaksi"
        }else{
            self.title = "Mutasi"
        }
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        var initialScrollViews = [String: UIView]()
        
        
        historyTabeView = UITableView(frame: view.bounds, style: .Plain)
        historyTabeView.translatesAutoresizingMaskIntoConstraints = false
        historyTabeView.showsVerticalScrollIndicator = false
        historyTabeView.rowHeight = UITableViewAutomaticDimension
        historyTabeView.estimatedRowHeight = 44
        historyTabeView.delegate = self
        historyTabeView.dataSource = self
        self.view.addSubview(historyTabeView)
        
        let tblView =  UIView(frame: CGRectZero)
        historyTabeView.tableFooterView = tblView
        historyTabeView.tableFooterView!.hidden = true
        
        
        historyTabeView.layer.cornerRadius = 5
        historyTabeView.layer.borderWidth = 0.3
        historyTabeView.layer.borderColor = UIColor.grayColor().CGColor
        
        historyTabeView.registerNib(UINib(nibName: "TransactionHistoryCell", bundle: nil), forCellReuseIdentifier: "CustomCellOne")
        initialScrollViews["historyTabeView"] = historyTabeView
        
        if(isMoreDataAvailable == true)
        {
            let loadControl = UILoadControl()
            loadControl.addTarget(self, action: "loadMoreTransactionsData:", forControlEvents: UIControlEvents.ValueChanged)
            historyTabeView.loadControl = loadControl
        }
        
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REGULAR_TRANSAKSI)
        {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(25)-[historyTabeView]-\(25)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(89)-[historyTabeView]-\(35)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            
        }else{
            let titleLabel = UILabel()
            //titleLabel.text = "Periode: 06 Nov ’15 - 29 Nov ‘15"
            titleLabel.text = ""
            titleLabel.font = UIFont(name:"HelveticaNeue", size:14)
            titleLabel.textColor = UIColor.downloadViewTitleColor()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.textAlignment = NSTextAlignment.Left
            self.view.addSubview(titleLabel)
            
            initialScrollViews["titleLabel"] = titleLabel
            
            let string = titleLabel.text! as NSString
            let attributedString = NSMutableAttributedString(string: string as String)
            let firstAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 14.0)!]
            attributedString.addAttributes(firstAttributes, range: string.rangeOfString("Periode"))
            titleLabel.attributedText = attributedString
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(25)-[titleLabel]-\(25)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(25)-[historyTabeView]-\(25)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(89)-[titleLabel]-10-[historyTabeView]-\(35)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            

            
            let backButtonItem = UIBarButtonItem(customView: SimaspayUtility.getSimasPayBackButton(self))
            self.navigationItem.rightBarButtonItem = backButtonItem

            
        }
        
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
        
        
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 74
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCellOne", forIndexPath: indexPath) as! TransactionHistoryCell
    
        let dictonary = transactionArray[indexPath.row] as! NSDictionary
        
        let sourceTransactionTime = dictonary.valueForKeyPath("transactionTime.text") as! String
        let transactionType = dictonary.valueForKeyPath("transactionType.text") as! String
        let isCreditStatus = dictonary.valueForKeyPath("isCredit.text") as! String
        let amount = dictonary.valueForKeyPath("amount.text") as! String
        
       /* var formattedDate  = ""
        //var formattedTime  = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "ddMMyyhhmmss"
        let formattedDateTime = dateFormatter.dateFromString(sourceTransactionTime)
        dateFormatter.dateFormat = "dd/MM/yy"
        formattedDate = dateFormatter.stringFromDate(formattedDateTime!) */
        
        //dateFormatter.dateFormat = "hh:mm:ss"
        //formattedTime = dateFormatter.stringFromDate(formattedDateTime!)
        
        
        
        cell.transactionDateLabel.text = sourceTransactionTime
        cell.transactionTypeLabel.text = transactionType
        
        if(isCreditStatus == "true")
        {
           cell.transactionNameLabel.text = "credit"
        }else{
            cell.transactionNameLabel.text = "debit"
        }
        
        
        cell.transactionPriceLabel.text = "Rp\(amount)"
        
        cell.transactionNameLabel.layer.cornerRadius = 3
        cell.transactionNameLabel.layer.masksToBounds = true
        
        if(cell.transactionNameLabel.text == "credit"){
         cell.transactionNameLabel.backgroundColor =  UIColor(netHex: 0x14BC28)
        }
        
        if(cell.transactionNameLabel.text == "debit"){
            cell.transactionNameLabel.backgroundColor =  UIColor(netHex: 0x5B9BFF)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    

    
    
    @objc private func loadMoreTransactionsData(sender: AnyObject?) {

        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        currentPageNumber++
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict = self.confirmationRequestDictonary as [NSObject : AnyObject]
        dict[PAGENUMBER] = "\(currentPageNumber)"
        
        //EZLoadingActivity.show("Loading...", disableUI: true)
        
        
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
                    
                    if( messagecode == SIMAPAY_TRANSACTION_HISTORY_CODE)
                    {
                        let newTransactionArray = responseDict.valueForKeyPath("response.transactionDetails.transactionDetail") as! NSArray
                        if(newTransactionArray.count > 0)
                        {
                            for var i=0 ; i < newTransactionArray.count ; i++
                            {
                                self.transactionArray.addObject(newTransactionArray.objectAtIndex(i))
                                self.historyTabeView.reloadData()
                                self.historyTabeView.loadControl!.endLoading()
                            }
                        }else{
                            self.historyTabeView.loadControl!.endLoading()
                            self.historyTabeView.loadControl = nil
                            SimasPayAlert.showSimasPayAlert("No Transaction Found.",viewController: self)
                        }
                    }else if( messagecode == SIMAPAY_NO_TRANSACTION_HISTORY_CODE)
                    {
                        self.isMoreDataAvailable = false
                        self.historyTabeView.loadControl!.endLoading()
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                    }else{
                        self.historyTabeView.loadControl!.endLoading()
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
    
    
    func downLoadButtonClicked(sender:UIBarButtonItem)
    {
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        dict[TXNNAME] = TXN_DownLoad_History_PDF
        
        dict[FROM_DATE] = self.confirmationRequestDictonary[FROM_DATE]
        dict[TO_DATE] = self.confirmationRequestDictonary[TO_DATE]
        
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
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }

                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    let downLoadURLText  = responseDict.valueForKeyPath("response.downloadURL.text") as! String
                    
                    let downLoadPDFURL = "\(DOWNLOAD_PDF_URL)\(downLoadURLText)"
                    if( messagecode == DownloadTransactionHistory_Code)
                    {
                        ServiceModel.downloadDataForURL(downLoadPDFURL,  successBlock: { (response) -> Void in
                            // Handle success response
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                if(response == nil)
                                {
                                    SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                                    return
                                }
                                print("Transaction History PDF Response : ",response)
                                let fileManager = NSFileManager.defaultManager()
                                let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                                let fileURL = documentsURL.URLByAppendingPathComponent("SimasPay.pdf")
                                let path = fileURL.path!
                                //fileManager.removeItemAtPath(path)
                                fileManager.createFileAtPath(path, contents: response,attributes: nil)
                                self.filePath = path
                                EZLoadingActivity.hide()
                                self.previewPDFDownloaded()
                            }
                            
                            }, failureBlock: { (error: NSError!) -> Void in
                                SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                                dispatch_async(dispatch_get_main_queue()) {
                                    EZLoadingActivity.hide()
                                }
                        })

                    }else{
                        EZLoadingActivity.hide()
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
    
    
    func previewPDFDownloaded(){

        let previewController:QLPreviewController = QLPreviewController()
        previewController.currentPreviewItemIndex = 0
        previewController.dataSource = self
        previewController.delegate = self
    
        self.navigationController?.presentViewController(previewController, animated: true, completion: nil)

    }
    
    internal func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int
    {
        return 1
    }
    
    internal func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem
    {

        return NSURL.fileURLWithPath(self.filePath! as String)
    }
    
    
    func writePDFToDisk (pdfObject:NSData) {
        
        let fileManager = NSFileManager.defaultManager()
        
        var docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last! as NSURL
        docURL = docURL.URLByAppendingPathComponent( "myDocument.pdf")
        
        fileManager.createFileAtPath(docURL.path!, contents: pdfObject,attributes: nil)
        
     //   pdfObject.writeToURL(docURL, atomically: true)
    }
    
    func retrievePDFFromDisk () -> AnyObject {
        var docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last! as NSURL
        docURL = docURL.URLByAppendingPathComponent( "myDocument.pdf")
        return docURL
    }
}