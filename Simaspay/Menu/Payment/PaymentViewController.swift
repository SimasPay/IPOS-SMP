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
    var transactionArray = []
    var selectedPaymentText:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
    
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            self.title = "Pembayaran"
            transactionArray = ["Tagihan Handphone","Telepon","Asuransi","Cicilan","Tiket","TV Kabel","Internet","Lainnya"]
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN_BILLER_LIST)
        {
           self.title = "Pembayaran"
           transactionArray = ["Smartfren","Kartu Halo","Kartu Halo","XL/Axis","Esia","Telkom Flexi Classic","Three"]
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
        {
            self.title = "Pembelian"
            transactionArray = ["Isi Ulang Pulsa","Voucher TV Kabel","Lainnya"]
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN_BILLER_LIST)
        {
            self.title = "Pembelian"
            transactionArray = ["Smartfren","Esia","Flexi","IM3","Kartu As","Mentari","Simpati"]
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
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 15, 25)
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
        return 54
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = transactionArray[indexPath.row] as!  NSString as String
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:14)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
        if(indexPath.row == 0)
        {
            if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
            {
                let paymentViewController = PaymentViewController()
                paymentViewController.selectedPaymentText = transactionArray[indexPath.row] as!  NSString as String
                paymentViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBAYARAN_BILLER_LIST
                self.navigationController!.pushViewController(paymentViewController, animated: true)
            }
            
            if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN_BILLER_LIST)
            {
                let paymentDetailsViewController = PaymentDetailsViewController()
                paymentDetailsViewController.selectedBillerText = "\(self.selectedPaymentText)-\(transactionArray[indexPath.row] as!  NSString as String)"
                paymentDetailsViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBAYARAN
                self.navigationController!.pushViewController(paymentDetailsViewController, animated: true)
            }
            
            if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
            {
                let paymentViewController = PaymentViewController()
                paymentViewController.selectedPaymentText = transactionArray[indexPath.row] as!  NSString as String
                paymentViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBELIAN_BILLER_LIST
                self.navigationController!.pushViewController(paymentViewController, animated: true)
            }
            
            if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN_BILLER_LIST)
            {
                let paymentDetailsViewController = PaymentDetailsViewController()
                paymentDetailsViewController.selectedBillerText = "\(self.selectedPaymentText)-\(transactionArray[indexPath.row] as!  NSString as String)"
                paymentDetailsViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBELIAN
                self.navigationController!.pushViewController(paymentDetailsViewController, animated: true)
            }
        }
        
        
        
        
        
    }
    
}