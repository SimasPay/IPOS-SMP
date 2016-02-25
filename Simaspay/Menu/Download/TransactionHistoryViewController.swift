//
//  TransactionHistoryViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit


class TransactionHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    var simasPayOptionType:SimasPayOptionType!
    var transactionArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let optionDict1 = ["date":"06/11/2015","type":"Transfer","isCredit":"credit","amount":"Rp 500.000"]
        let optionDict2 = ["date":"06/11/2015","type":"Bill Payme","isCredit":"debit","amount":"-Rp 35.000"]
        let optionDict3 = ["date":"Transfer","type":"Admin Fee","isCredit":"debit","amount":"-Rp 10.000"]
        let optionDict4 = ["date":"Transfer","type":"ATM Withdr","isCredit":"debit","amount":"-Rp 500.000"]
        let optionDict5 = ["date":"08/11/2015","type":"Transfer","isCredit":"credit","amount":"Rp 500.000"]
        let optionDict6 = ["date":"12/11/2015","type":"ATM Withdr","isCredit":"debit","amount":"-Rp 500.000"]
        let optionDict7 = ["date":"29/11/2015","type":"ATM Withdr","isCredit":"debit","amount":"-Rp 500.000"]

        transactionArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6,optionDict7]
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REGULAR_TRANSAKSI)
        {
            self.title = "Transaksi"
        }else{
            self.title = "Mutasi"
        }
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        var initialScrollViews = [String: UIView]()
        
        
        let historyTabeView = UITableView(frame: view.bounds, style: .Plain)
        historyTabeView.translatesAutoresizingMaskIntoConstraints = false
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
        
        
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REGULAR_TRANSAKSI)
        {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(25)-[historyTabeView]-\(25)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(89)-[historyTabeView]-\(35)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            
        }else{
            let titleLabel = UILabel()
            titleLabel.text = "Periode: 06 Nov ’15 - 29 Nov ‘15"
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
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame =
            CGRectMake(0, 0, 15, 25)
        backButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "btn-back"), forState: UIControlState.Normal)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
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
        cell.transactionDateLabel.text = dictonary["date"] as! NSString as String
        cell.transactionTypeLabel.text = dictonary["type"] as! NSString as String
        cell.transactionNameLabel.text = dictonary["isCredit"] as! NSString as String
        cell.transactionPriceLabel.text = dictonary["amount"] as! NSString as String
        
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
    
    
}