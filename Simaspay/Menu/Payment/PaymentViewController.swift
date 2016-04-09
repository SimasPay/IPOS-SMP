//
//  TransactionHistoryViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit


class PaymentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    var simasPayOptionType:SimasPayOptionType!
    var simasPayUserType:SimasPayUserType!
    var simasPayBillerLevel:SimasPayBillerLevel!
    var billersListArray : NSArray!
    var selectedPaymentText:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
    
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            self.title = "Pembayaran"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
        {
            self.title = "Pembelian"
            //billersListArray = ["Isi Ulang Pulsa","Voucher TV Kabel","Lainnya"]
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
        historyTabeView.backgroundColor = UIColor.clearColor()
    
        
        historyTabeView.registerNib(UINib(nibName: "TransactionHistoryCell", bundle: nil), forCellReuseIdentifier: "CustomCellOne")
        initialScrollViews["historyTabeView"] = historyTabeView
        
        
        
        
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(0)-[historyTabeView]-\(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(64)-[historyTabeView]-\(35)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))

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
        return 54
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.billersListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")
        
        let billerObject = self.billersListArray[indexPath.row] as! NSDictionary
        
        if(simasPayBillerLevel == SimasPayBillerLevel.SIMASPAY_PRODUCT_CATEGORY)
        {
             cell.textLabel?.text = billerObject.valueForKey("productCategory") as? String
        }else if(simasPayBillerLevel == SimasPayBillerLevel.SIMASPAY_PRODUCT_PROVIDER){
            cell.textLabel?.text = billerObject.valueForKey("providerName") as? String
        }else if(simasPayBillerLevel == SimasPayBillerLevel.SIMASPAY_PRODUCT_NAME){
            cell.textLabel?.text = billerObject.valueForKey("productName") as? String
        }
        
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:14)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
        let billerObject = self.billersListArray[indexPath.row] as! NSDictionary
        
        if(simasPayBillerLevel == SimasPayBillerLevel.SIMASPAY_PRODUCT_CATEGORY)
        {
            let providersArray = billerObject.valueForKey("providers") as? NSArray
            
            let billerObject = self.billersListArray[indexPath.row] as! NSDictionary
            let paymentViewController = PaymentViewController()
            paymentViewController.simasPayUserType = self.simasPayUserType
            paymentViewController.simasPayBillerLevel = SimasPayBillerLevel.SIMASPAY_PRODUCT_PROVIDER
            paymentViewController.selectedPaymentText = billerObject.valueForKey("productCategory") as? String
            paymentViewController.billersListArray = providersArray
            paymentViewController.simasPayOptionType = self.simasPayOptionType
            self.navigationController!.pushViewController(paymentViewController, animated: true)
            
        }else if(simasPayBillerLevel == SimasPayBillerLevel.SIMASPAY_PRODUCT_PROVIDER){
            
            let productsArray = billerObject.valueForKey("products") as? NSArray
            let paymentViewController = PaymentViewController()
            paymentViewController.simasPayUserType = self.simasPayUserType
            paymentViewController.simasPayBillerLevel = SimasPayBillerLevel.SIMASPAY_PRODUCT_NAME
            paymentViewController.billersListArray = productsArray
            paymentViewController.selectedPaymentText = self.selectedPaymentText
            paymentViewController.simasPayOptionType = self.simasPayOptionType
            self.navigationController!.pushViewController(paymentViewController, animated: true)
            
        }else if(simasPayBillerLevel == SimasPayBillerLevel.SIMASPAY_PRODUCT_NAME){
            
            let productName = billerObject.valueForKey("productName") as! NSString
            let paymentDetailsViewController = PaymentDetailsViewController()
            paymentDetailsViewController.simasPayUserType = self.simasPayUserType
            paymentDetailsViewController.selectedProduct = billerObject
            paymentDetailsViewController.selectedBillerText = "\(self.selectedPaymentText) - \(productName)"
            paymentDetailsViewController.simasPayOptionType = self.simasPayOptionType
            self.navigationController!.pushViewController(paymentDetailsViewController, animated: true)
        }
    }
    
}