//
//  SubMenuViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 04/01/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class SubMenuViewController: UIViewController
{
    @IBOutlet weak var customMainMenuView: UIView!
    @IBOutlet weak var customFooterView: UIView!
    @IBOutlet weak var agentLabel: UILabel!
    
    @IBOutlet weak var footerAccountNameView: UIView!
    
    @IBOutlet weak var agentChangeUserTypeBtn: UIButton!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var changeUserTypeLabel: UILabel!
    @IBOutlet weak var logoutImageview: UIImageView!
    @IBOutlet weak var changeUserTypeImage: UIImageView!
    
    var simasPayUserType:SimasPayUserType!
    var menuViewArray: Array<AnyObject>!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let  loginResponse = SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_LOGIN_DATA)
        accountNameLabel.text = loginResponse.valueForKeyPath("response.name.text") as? String
        accountNumberLabel.text = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN) as? String
        
        footerAccountNameView.layer.cornerRadius = 5
        
        if (simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT)
        {
            agentLabel.hidden = false
            customFooterView.backgroundColor = UIColor.whiteColor()
            
            changeUserTypeLabel.textColor = UIColor(netHex:0x5F060A)
            logoutLabel.textColor = UIColor(netHex:0x5F060A)
            footerAccountNameView.backgroundColor = UIColor(netHex:0x881014)
            logoutImageview.image = UIImage(named: "btnLogoutRed")
            changeUserTypeImage.image = UIImage(named: "btnSwitchRed")
            
        }else{
            
            agentLabel.hidden = true
            footerAccountNameView.backgroundColor = UIColor(netHex:0x42000A)
            customFooterView.backgroundColor = UIColor(netHex:0xA10118)
            agentChangeUserTypeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            logoutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        }
        
        if (simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT ||  simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR )
        {
            agentChangeUserTypeBtn.hidden = false
            changeUserTypeImage.hidden = false
            changeUserTypeLabel.hidden = false
            
        }else{
            agentChangeUserTypeBtn.hidden = true
            changeUserTypeImage.hidden = true
            changeUserTypeLabel.hidden = true
        }
        
        
        if menuViewArray.count == 3
        {self.create3X0SimasPayMenu() }
        else if menuViewArray.count == 4
        {self.create2X2SimasPayMenu() }
        else
        {self.create2X2SimasPayMenu()}
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    func create3X0SimasPayMenu() {
        
        var titleYposition:CGFloat = 145
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            titleYposition = 115
        }
        
        let redView:UIButton = UIButton()
        let menuoption0 = menuViewArray[0] as! NSDictionary
        let image1 = UIImage(named: menuoption0["image"] as! NSString as String)
        redView.backgroundColor = UIColor.clearColor()
        redView.setBackgroundImage(image1, forState: .Normal)
        redView.setTitle( menuoption0["title"] as! NSString as String, forState: UIControlState.Normal)
        redView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        redView.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        redView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView)
        redView.titleLabel!.numberOfLines = 2;
        //redView.titleLabel!.adjustsFontSizeToFitWidth = true;
        redView.titleLabel?.textAlignment = NSTextAlignment.Center
        
        if(redView.titleLabel?.text == "Bank Sinarmas")
        {
            redView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition+10,0,0,0)
        }
        
        let greenView:UIButton = UIButton()
        let menuoption1 = menuViewArray[1] as! NSDictionary
        let image2 = UIImage(named: menuoption1["image"] as! NSString as String)
        greenView.backgroundColor = UIColor.clearColor()
        greenView.setBackgroundImage(image2, forState: .Normal)
        greenView.setTitle( menuoption1["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        greenView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView)
        greenView.titleLabel!.numberOfLines = 2;
        //greenView.titleLabel!.adjustsFontSizeToFitWidth = true;
        greenView.titleLabel?.textAlignment = NSTextAlignment.Center
        
        let blueView:UIButton = UIButton()
        let menuoption2 = menuViewArray[2] as! NSDictionary
        let image3 = UIImage(named: menuoption2["image"] as! NSString as String)
        blueView.backgroundColor = UIColor.clearColor()
        blueView.setBackgroundImage(image3, forState: .Normal)
        blueView.setTitle( menuoption2["title"] as! NSString as String, forState: UIControlState.Normal)
        blueView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        blueView.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        blueView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        blueView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(blueView)
        blueView.titleLabel!.numberOfLines = 2;
       // blueView.titleLabel!.adjustsFontSizeToFitWidth = true;
        blueView.titleLabel?.textAlignment = NSTextAlignment.Center
        
        
        let backButton:UIButton = UIButton()
        let image4 = UIImage(named: "btn-menuback")
        backButton.backgroundColor = UIColor.clearColor()
        backButton.setBackgroundImage(image4, forState: .Normal)
        backButton.addTarget(self, action: #selector(SubMenuViewController.backButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        customMainMenuView.addSubview(backButton)
        backButton.titleLabel!.numberOfLines = 1;
        backButton.titleLabel!.adjustsFontSizeToFitWidth = true;
    
        redView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
    
        let menuItemsArray = ["redView": redView, "greenView": greenView, "blueView": blueView]
        
        var menuWidthHeight:Int = 120
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            menuWidthHeight = 80
        }
        
        if DeviceType.IS_IPHONE_6 {
            menuWidthHeight = 100
        }
        
        if DeviceType.IS_IPHONE_6P {
            menuWidthHeight = 120
        }
        
        
        let horizontalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[redView(>=45,<=200)]-20-[greenView(>=45,<=200)]-20-[blueView(>=45,<=200)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        
        
        let equalWidthConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[redView(==greenView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let equalWidthConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[greenView(==blueView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[redView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[greenView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints3:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[blueView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        var backButonWH:Int = 60
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            backButonWH = 45
        }
        if DeviceType.IS_IPHONE_6 {
            backButonWH = 55
        }
        if DeviceType.IS_IPHONE_6P {
            backButonWH = 65
        }
        
        
        
        // Center horizontally
        let horizontalAlignConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[superview]-(<=1)-[backButton(\(backButonWH))]",
            options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil,
            views: ["superview":customMainMenuView, "backButton":backButton])
        
        // Center vertically
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[superview]-(<=1)-[backButton(\(backButonWH))]",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: ["superview":customMainMenuView, "backButton":backButton])
        
    
        let verticalHeight:Int = menuWidthHeight+60
        
        let verticalConstraints21:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[backButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["superview":customMainMenuView, "backButton":backButton])
        
        
        
        customMainMenuView.addConstraints(horizontalConstraints);
        
        customMainMenuView.addConstraints(equalWidthConstraints1);
        customMainMenuView.addConstraints(equalWidthConstraints2);

        customMainMenuView.addConstraints(verticalConstraints1);
        customMainMenuView.addConstraints(verticalConstraints2);
        customMainMenuView.addConstraints(verticalConstraints3);
        
        customMainMenuView.addConstraints(constraints);
        customMainMenuView.addConstraints(horizontalAlignConstraints);
        customMainMenuView.addConstraints(verticalConstraints21);
    }
    
    func create2X2SimasPayMenu() {
        
        var titleYposition:CGFloat = 145
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            titleYposition = 115
        }
        
        let redView:UIButton = UIButton()
        let menuoption0 = menuViewArray[0] as! NSDictionary
        let image1 = UIImage(named: menuoption0["image"] as! NSString as String)
        redView.backgroundColor = UIColor.clearColor()
        redView.setBackgroundImage(image1, forState: .Normal)
        redView.setTitle( menuoption0["title"] as! NSString as String, forState: UIControlState.Normal)
        redView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        redView.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        redView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView)
        redView.titleLabel!.numberOfLines = 2;
        redView.titleLabel?.textAlignment = NSTextAlignment.Center
        
        let greenView:UIButton = UIButton()
        let menuoption1 = menuViewArray[1] as! NSDictionary
        let image2 = UIImage(named: menuoption1["image"] as! NSString as String)
        greenView.backgroundColor = UIColor.clearColor()
        greenView.setBackgroundImage(image2, forState: .Normal)
        greenView.setTitle( menuoption1["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        greenView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView)
        greenView.titleLabel!.numberOfLines = 2;
        greenView.titleLabel?.textAlignment = NSTextAlignment.Center
        
        let redView1:UIButton = UIButton()
        let menuoption2 = menuViewArray[2] as! NSDictionary
        let image4 = UIImage(named: menuoption2["image"] as! NSString as String)
        redView1.backgroundColor = UIColor.clearColor()
        redView1.setBackgroundImage(image4, forState: .Normal)
        redView1.setTitle( menuoption2["title"] as! NSString as String, forState: UIControlState.Normal)
        redView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        redView1.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        redView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView1)
        redView1.titleLabel!.numberOfLines = 2;
        redView1.titleLabel?.textAlignment = NSTextAlignment.Center
        
        
        
        let greenView1:UIButton = UIButton()
        let menuoption3 = menuViewArray[3] as! NSDictionary
        let image5 = UIImage(named: menuoption3["image"] as! NSString as String)
        greenView1.backgroundColor = UIColor.clearColor()
        greenView1.setBackgroundImage(image5, forState: .Normal)
        greenView1.setTitle( menuoption3["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView1.addTarget(self, action: #selector(SubMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        greenView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView1)
        greenView1.titleLabel!.numberOfLines = 2;
        greenView1.titleLabel?.textAlignment = NSTextAlignment.Center
        
        if(greenView1.titleLabel?.text == "Bayar Pakai QR")
        {
            greenView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition+10,0,0,0)
        }
        
        
        
        let backButton:UIButton = UIButton()
        let image6 = UIImage(named: "btn-menuback")
        backButton.backgroundColor = UIColor.clearColor()
        backButton.setBackgroundImage(image6, forState: .Normal)
        backButton.addTarget(self, action: #selector(SubMenuViewController.backButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        customMainMenuView.addSubview(backButton)
        backButton.titleLabel!.numberOfLines = 1;
        backButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        redView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        
        redView1.translatesAutoresizingMaskIntoConstraints = false
        greenView1.translatesAutoresizingMaskIntoConstraints = false
        
        let menuItemsArray = ["redView": redView, "greenView": greenView,"redView1": redView1, "greenView1": greenView1]
        
        
        var menuWidthHeight:Int = 120
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            menuWidthHeight = 80
        }
        
        if DeviceType.IS_IPHONE_6 {
            menuWidthHeight = 100
        }
        
        if DeviceType.IS_IPHONE_6P {
            menuWidthHeight = 120
        }
        
        
        let horizontalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=45,<=200)-[redView(>=45,<=200)]-20-[greenView(==redView)]-(>=45,<=200)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let horizontalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=45,<=200)-[redView1(>=45,<=200)]-20-[greenView1(==redView1)]-(>=45,<=200)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)

        
        let verticalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[redView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[greenView(==redView)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)

        
        let verticalHeight:Int = menuWidthHeight+40
        
        
        let verticalConstraints11:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[redView1(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints21:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[greenView1(==redView1)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        

        var backButonWH:Int = 60
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            backButonWH = 45
        }
        if DeviceType.IS_IPHONE_6 {
            backButonWH = 55
        }
        if DeviceType.IS_IPHONE_6P {
            backButonWH = 65
        }
        
        
        // Center horizontally
        let horizontalAlignConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[superview]-(<=1)-[backButton(\(backButonWH))]",
            options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil,
            views: ["superview":customMainMenuView, "backButton":backButton])
        
        // Center vertically
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[superview]-(<=1)-[backButton(\(backButonWH))]",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: ["superview":customMainMenuView, "backButton":backButton])
        
        
        let verticalHeight1:Int = menuWidthHeight+menuWidthHeight+80
        
        let verticalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight1))-[backButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["superview":customMainMenuView, "backButton":backButton])
        
        
        customMainMenuView.addConstraints(horizontalConstraints);
        customMainMenuView.addConstraints(horizontalConstraints1);
        
        customMainMenuView.addConstraints(verticalConstraints1);
        customMainMenuView.addConstraints(verticalConstraints2);
        
        customMainMenuView.addConstraints(verticalConstraints11);
        customMainMenuView.addConstraints(verticalConstraints21);
        
        customMainMenuView.addConstraints(constraints);
        customMainMenuView.addConstraints(horizontalAlignConstraints);
        customMainMenuView.addConstraints(verticalConstraints);
    }
    
    func menuButtonTapped(sender:UIButton!){
        print("button Touch Down")
        
        
        
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR ||  self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER ||  self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI)
        {
            
            if sender.currentTitle == "Bayar Pakai QR"
            {
                
            }
            
            
            if sender.currentTitle == "Bank Sinarmas"
            {
                gotToBankSinaramsViewController()
            }
            
            if sender.currentTitle == "Bank Lain"
            {
                self.gotToBankLainViewController()
            }
            
            if sender.currentTitle == "Laku Pandai"
            {
                gotToLakuPandaiTransferViewController()
            }
            
            if sender.currentTitle == "Uangku"
            {
                gotToUangkuViewController()
            }
            
            if sender.currentTitle == "Mutasi"
            {
                let viewController = DownloadViewController()
                viewController.simasPayUserType = self.simasPayUserType
                self.navigationController!.pushViewController(viewController, animated: true)
            }
            
            if sender.currentTitle == "Info Saldo"
            {
                self.gotToCheckBalanceViewController()
            }
            
            if sender.currentTitle == "Transaksi"
            {
                self.gotoTransactionViewController()
            }
            
            if sender.currentTitle == "Ganti mPIN"
            {
                let viewController = ChangePINViewController()
                viewController.title = "Ganti mPIN"
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        }
        
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT)
        {
            if sender.currentTitle == "Bayar Pakai QR"
            {
                payBYQRBtnClicked()
            }
            
            if sender.currentTitle == "Mutasi"
            {
                let viewController = DownloadViewController()
                viewController.simasPayUserType = self.simasPayUserType
                self.navigationController!.pushViewController(viewController, animated: true)
            }
            
            if sender.currentTitle == "Info Saldo"
            {
                self.gotToCheckBalanceViewController()
            }
            
            if sender.currentTitle == "Transfer"
            {
                let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SubMenuViewController") as! SubMenuViewController
                mainMenuViewController.simasPayUserType = simasPayUserType
                
                let optionDict1 = ["title":"Bank Sinarmas","image":"btn-bsim","":""]
                let optionDict2 = ["title":"Bank Lain","image":"btn-banklain","":""]
                let optionDict3 = ["title":"Laku Pandai","image":"btn-lakupandai","":""]
                let optionDict4 = ["title":"Uangku","image":"btn-Uangku","":""]
                
                menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4]
                mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
                self.navigationController!.pushViewController(mainMenuViewController, animated: true)
            }
            
            if sender.currentTitle == "Pembelian"
            {
                self.gotoPurchaseViewController()
            }
            
            if sender.currentTitle == "Pembayaran"
            {
                self.gotoPaymentsViewController()
            }
            
            
            if sender.currentTitle == "Bank Sinarmas"
            {
                gotToBankSinaramsViewController()
            }
            
            if sender.currentTitle == "Uangku"
            {
                gotToUangkuViewController()
            }
            
            if sender.currentTitle == "Bank Lain"
            {
                self.gotToBankLainViewController()
            }
            
            if sender.currentTitle == "Ganti mPIN"
            {
                let viewController = ChangePINViewController()
                viewController.title = "Ganti mPIN"
                self.navigationController!.pushViewController(viewController, animated: true)
            }
            
            if sender.currentTitle == "Laku Pandai"
            {
                gotToLakuPandaiTransferViewController()
                
            }
            
        }
    }

    
    func backButtonTapped(sender:UIButton!){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func logoutBtnClicked(sender: AnyObject) {
        
        for  viewController in (self.navigationController?.viewControllers)!        {
            if viewController.isKindOfClass(LoginViewController)
            {
                //SimasPayPlistUtility.saveDataToPlist("NO", key: IS_LOGIN)
                self.navigationController?.popToViewController(viewController, animated: false)
            }
        }
    }
    
    @IBAction func agentChnageUserTypeClicked(sender: AnyObject) {
        
        for  viewController in (self.navigationController?.viewControllers)!        {
            if viewController.isKindOfClass(AgentOptionViewController)
            {
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
    
    func gotToBankSinaramsViewController()
    {
        let viewController = TransferBankSinarmasViewC()
        viewController.simasPayUserType = self.simasPayUserType
        viewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_TRANSFER_BANKSINARMAS
        viewController.title = "Transfer - Bank Sinarmas"
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func gotToLakuPandaiTransferViewController()
    {
        let viewController = TransferBankSinarmasViewC()
        viewController.title = "Transfer - Laku Pandai"
        viewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI
        viewController.simasPayUserType = self.simasPayUserType
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    func gotToUangkuViewController()
    {
        let viewController = TransferBankSinarmasViewC()
        viewController.simasPayUserType = self.simasPayUserType
        viewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_TRANSFER_UANGKU
        viewController.title = "Transfer - Uangku"
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    func gotToBankLainViewController()
    {
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_BANK_CODES
        dict[VERSION] = "0"
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
                // Handle success response
                dispatch_async(dispatch_get_main_queue()) {
                    
                    EZLoadingActivity.hide()
                    print("Bank List Response : ",response)
                    
                    let responseDict = response as! NSDictionary
                    let bankCodeData = responseDict.valueForKey("bankData")
                    

                    if(bankCodeData?.count > 0){
                        let viewController = TransferBankListViewC()
                        viewController.bankSourceData = bankCodeData as! NSArray as [AnyObject]
                        viewController.simasPayUserType = self.simasPayUserType
                        self.navigationController!.pushViewController(viewController, animated: true)
                    }
                    
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                //SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController: (self.window?.rootViewController)!)
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                }
                
        })
   
    }
    
    func gotToCheckBalanceViewController(){
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        dict[SERVICE] = SERVICE_WALLET
        dict[TXNNAME] = TXN_ACCOUNT_BALANCE
        
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER || self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR){
            dict[SOURCEPOCKETCODE] = "2"
        }
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI){
            dict[SOURCEPOCKETCODE] = "6"
        }
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT){
            dict[SOURCEPOCKETCODE] = "1"
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
                
                
                if( messagecode == SIMAPAY_AGENT_REGULAR_BALANCE_CODE || messagecode == SIMAPAY_AGENT__BALANCE_CODE)
                {
                    let transactionTime  = responseDict.valueForKeyPath("response.time.text") as! String
                    let transactionDate  = responseDict.valueForKeyPath("response.date.text") as! String
                    let balanceAmount  = responseDict.valueForKeyPath("response.amount.text") as! String
                    
                    let viewController = CheckBalanceViewController()
                    viewController.transactionTime = transactionTime
                    viewController.transactionDate = transactionDate
                    viewController.balanceAmount = balanceAmount
                    self.navigationController!.pushViewController(viewController, animated: true)
                    
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
    
    func gotoTransactionViewController()
    {
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        dict[TXNNAME] = TXN_ACCOUNT_HISTORY
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
                    //let moreRecordsAvailabe  = responseDict.valueForKeyPath("response.MoreRecordsAvailable.text") as! String
                    
                    if( messagecode == SIMAPAY_SUCCESS_ACCOUNT_TRANSACTION_CODE)
                    {
                        let transactionArray = responseDict.valueForKeyPath("response.transactionDetails.transactionDetail") as! NSArray
                        
                        let transactionViewController = TransactionHistoryViewController()
                       
                        /*if(moreRecordsAvailabe == "true")
                        {
                            transactionViewController.isMoreDataAvailable = true
                        }else{
                            
                        }*/
                        transactionViewController.confirmationRequestDictonary = dict
                        transactionViewController.isMoreDataAvailable = false
                        transactionViewController.simasPayUserType = self.simasPayUserType
                        transactionViewController.transactionArray = transactionArray as! NSMutableArray
                        transactionViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_REGULAR_TRANSAKSI
                        self.navigationController!.pushViewController(transactionViewController, animated: true)
                        
                        
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
    
    
    func gotoPurchaseViewController(){
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_PURCHASE
        dict[VERSION] = "0"
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
            // Handle success response
            dispatch_async(dispatch_get_main_queue()) {
                
                EZLoadingActivity.hide()
                print("Purchase List Response : ",response)
                
                let responseDict = response as! NSDictionary
                let purchaseBillersList = responseDict.valueForKey("purchaseData") as! NSArray
                
                if(purchaseBillersList.count > 0){
                    let purchaseViewController = PaymentViewController()
                    purchaseViewController.simasPayUserType = self.simasPayUserType
                    purchaseViewController.billersListArray = purchaseBillersList
                    purchaseViewController.simasPayBillerLevel = SimasPayBillerLevel.SIMASPAY_PRODUCT_CATEGORY
                    purchaseViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBELIAN
                    self.navigationController!.pushViewController(purchaseViewController, animated: true)
                }
                
            }
            
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                }
                
        })
    }
    
    func gotoPaymentsViewController(){
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_PAYMENTS
        dict[VERSION] = "0"
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
            // Handle success response
            dispatch_async(dispatch_get_main_queue()) {
                EZLoadingActivity.hide()
                print("Payments List Response : ",response)
                let responseDict = response as! NSDictionary
                let paymentsBillerList = responseDict.valueForKey("paymentData") as! NSArray
                
                if(paymentsBillerList.count > 0){
                    
                    let paymentsViewController = PaymentViewController()
                    paymentsViewController.simasPayUserType = self.simasPayUserType
                    paymentsViewController.billersListArray = paymentsBillerList
                    paymentsViewController.simasPayBillerLevel = SimasPayBillerLevel.SIMASPAY_PRODUCT_CATEGORY
                    paymentsViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBAYARAN
                    self.navigationController!.pushViewController(paymentsViewController, animated: true)
                }
                
            }
            
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                }
                
        })
    }
    
    
    // MARK: PAY By QR Implementation
    
    func payBYQRBtnClicked() {
        
        for  viewController in (self.navigationController?.viewControllers)!        {
            if viewController.isKindOfClass(MainMenuViewController)
            {
                let viewC = viewController as! MainMenuViewController
                viewC.payBYQRBtnClicked()
                
            }
        }
    }
}