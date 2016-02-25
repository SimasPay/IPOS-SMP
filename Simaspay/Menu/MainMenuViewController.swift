//
//  MainmenuViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 30/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController
{
    @IBOutlet weak var customMainMenuView: UIView!
    @IBOutlet weak var agentLabel: UILabel!
    @IBOutlet weak var customFooterView: UIView!
    @IBOutlet weak var footerAccountNameView: UIView!
    
    @IBOutlet weak var agentChangeUserTypeBtn: UIButton!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var changeUserTypeLabel: UILabel!
    @IBOutlet weak var logoutImageview: UIImageView!
    @IBOutlet weak var changeUserTypeImage: UIImageView!
    var menuViewArray: Array<AnyObject>!
    var simasPayUserType:SimasPayUserType!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       //accountNameLabel.textColor = UIColor.whiteColor()
       //accountNumberLabel.textColor = UIColor.whiteColor()
        
       // agentChangeUserTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(120,0,0,0)
       // logoutButton.titleEdgeInsets = UIEdgeInsetsMake(150,0,0,0)
        

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
        

        if menuViewArray.count > 5
        {self.create3X3SimasPayMenu() }
        else
        {self.create3X2SimasPayMenu()}

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    func create3X3SimasPayMenu() {
     
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
        redView.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        redView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView)
        redView.titleLabel!.numberOfLines = 2;
        redView.tag = 1
        redView.titleLabel?.textAlignment = NSTextAlignment.Center
        //redView.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        
        
        let greenView:UIButton = UIButton()
        let menuoption1 = menuViewArray[1] as! NSDictionary
        let image2 = UIImage(named: menuoption1["image"] as! NSString as String)
        greenView.backgroundColor = UIColor.clearColor()
        greenView.setBackgroundImage(image2, forState: .Normal)
        greenView.setTitle(menuoption1["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        greenView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView)
        greenView.titleLabel!.numberOfLines = 2;
        greenView.tag = 2
        greenView.titleLabel?.textAlignment = NSTextAlignment.Center
        //greenView.titleLabel!.adjustsFontSizeToFitWidth = true;
        if(greenView.titleLabel?.text == "Buka Rekening")
        {  greenView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition+10,0,0,0) }
        
        
        
        
        let blueView:UIButton = UIButton()
        let menuoption2 = menuViewArray[2] as! NSDictionary
        let image3 = UIImage(named: menuoption2["image"] as! NSString as String)
        blueView.backgroundColor = UIColor.clearColor()
        blueView.setBackgroundImage(image3, forState: .Normal)
        blueView.setTitle(menuoption2["title"] as! NSString as String, forState: UIControlState.Normal)
        blueView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        blueView.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        blueView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        blueView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(blueView)
        blueView.titleLabel!.numberOfLines = 2;
        blueView.tag = 3
        blueView.titleLabel?.textAlignment = NSTextAlignment.Center
        //blueView.titleLabel!.adjustsFontSizeToFitWidth = true;
        if(blueView.titleLabel?.text == "Tutup Rekening")
        {  blueView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition+10,0,0,0) }
        
        let redView1:UIButton = UIButton()
        let menuoption3 = menuViewArray[3] as! NSDictionary
        let image4 = UIImage(named: menuoption3["image"] as! NSString as String)
        redView1.backgroundColor = UIColor.clearColor()
        redView1.setBackgroundImage(image4, forState: .Normal)
        redView1.setTitle(menuoption3["title"] as! NSString as String, forState: UIControlState.Normal)
        redView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        redView1.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        redView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView1)
        redView1.titleLabel!.numberOfLines = 2;
        redView1.tag = 4
        redView1.titleLabel?.textAlignment = NSTextAlignment.Center
        //redView1.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        
        
        let greenView1:UIButton = UIButton()
        let menuoption4 = menuViewArray[4] as! NSDictionary
        let image5 = UIImage(named: menuoption4["image"] as! NSString as String)
        greenView1.backgroundColor = UIColor.clearColor()
        greenView1.setBackgroundImage(image5, forState: .Normal)
        greenView1.setTitle(menuoption4["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView1.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        greenView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView1)
        greenView1.titleLabel!.numberOfLines = 2;
        greenView1.tag = 5
        greenView1.titleLabel?.textAlignment = NSTextAlignment.Center
        //greenView1.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        if(greenView1.titleLabel?.text == "Bayar Pakai QR")
        {
            greenView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition+10,0,0,0)
        }
        
        let blueView1:UIButton = UIButton()
        let menuoption5 = menuViewArray[5] as! NSDictionary
        let image6 = UIImage(named: menuoption5["image"] as! NSString as String)
        blueView1.backgroundColor = UIColor.clearColor()
        blueView1.setBackgroundImage(image6, forState: .Normal)
        blueView1.setTitle(menuoption5["title"] as! NSString as String, forState: UIControlState.Normal)
        blueView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        blueView1.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        blueView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        blueView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(blueView1)
        blueView1.titleLabel!.numberOfLines = 2;
        blueView1.tag = 6
        blueView1.titleLabel?.textAlignment = NSTextAlignment.Center
        //blueView1.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        redView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        redView1.translatesAutoresizingMaskIntoConstraints = false
        greenView1.translatesAutoresizingMaskIntoConstraints = false
        blueView1.translatesAutoresizingMaskIntoConstraints = false
        
        let menuItemsArray = ["redView": redView, "greenView": greenView, "blueView": blueView,"redView1": redView1, "greenView1": greenView1, "blueView1": blueView1]

        
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
        
        let horizontalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[redView1(>=45,<=200)]-20-[greenView1(>=45,<=200)]-20-[blueView1(>=45,<=200)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let equalWidthConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[redView(==greenView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let equalWidthConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[greenView(==blueView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        
        let equalWidthConstraints11:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[redView1(==greenView1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let equalWidthConstraints21:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[greenView1(==blueView1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        
        
        let verticalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[redView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[greenView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints3:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[blueView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalHeight:Int = menuWidthHeight+45
        
        
        let verticalConstraints11:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[redView1(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints21:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[greenView1(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints31:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[blueView1(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        
        customMainMenuView.addConstraints(horizontalConstraints);
        customMainMenuView.addConstraints(horizontalConstraints1);
        
        customMainMenuView.addConstraints(equalWidthConstraints1);
        customMainMenuView.addConstraints(equalWidthConstraints2);
        customMainMenuView.addConstraints(equalWidthConstraints11);
        customMainMenuView.addConstraints(equalWidthConstraints21);
        
        customMainMenuView.addConstraints(verticalConstraints1);
        customMainMenuView.addConstraints(verticalConstraints2);
        customMainMenuView.addConstraints(verticalConstraints3);
        
        customMainMenuView.addConstraints(verticalConstraints11);
        customMainMenuView.addConstraints(verticalConstraints21);
        customMainMenuView.addConstraints(verticalConstraints31);
        
        
        
    }
    
    
    func create3X2SimasPayMenu() {
        
        var titleYposition:CGFloat = 145
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            titleYposition = 115
        }
        
        let redView:UIButton = UIButton()
        let menuoption0 = menuViewArray[0] as! NSDictionary
        let image1 = UIImage(named: menuoption0["image"] as! NSString as String)
        redView.backgroundColor = UIColor.clearColor()
        redView.setBackgroundImage(image1, forState: .Normal)
        redView.setTitle(menuoption0["title"] as! NSString as String, forState: UIControlState.Normal)
        redView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        redView.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        redView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView)
        redView.titleLabel!.numberOfLines = 2;
        redView.tag = 1
        redView.titleLabel?.textAlignment = NSTextAlignment.Center
        //redView.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        
        let greenView:UIButton = UIButton()
        let menuoption1 = menuViewArray[1] as! NSDictionary
        let image2 = UIImage(named: menuoption1["image"] as! NSString as String)
        greenView.backgroundColor = UIColor.clearColor()
        greenView.setBackgroundImage(image2, forState: .Normal)
        greenView.setTitle(menuoption1["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        greenView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView)
        greenView.titleLabel!.numberOfLines = 2;
        greenView.tag = 2
        greenView.titleLabel?.textAlignment = NSTextAlignment.Center
        //greenView.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        let blueView:UIButton = UIButton()
        let menuoption2 = menuViewArray[2] as! NSDictionary
        let image3 = UIImage(named: menuoption2["image"] as! NSString as String)
        blueView.backgroundColor = UIColor.clearColor()
        blueView.setBackgroundImage(image3, forState: .Normal)
        blueView.setTitle(menuoption2["title"] as! NSString as String, forState: UIControlState.Normal)
        blueView.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        blueView.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        blueView.titleLabel?.font = UIFont(name: "Arial", size: 13)
        blueView.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(blueView)
        blueView.titleLabel!.numberOfLines = 2;
        blueView.tag = 3
        blueView.titleLabel?.textAlignment = NSTextAlignment.Center
        //blueView.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        let redView1:UIButton = UIButton()
        let menuoption3 = menuViewArray[3] as! NSDictionary
        let image4 = UIImage(named: menuoption3["image"] as! NSString as String)
        redView1.backgroundColor = UIColor.clearColor()
        redView1.setBackgroundImage(image4, forState: .Normal)
        redView1.setTitle(menuoption3["title"] as! NSString as String, forState: UIControlState.Normal)
        redView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        redView1.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        redView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        redView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(redView1)
        redView1.titleLabel!.numberOfLines = 2;
        redView1.tag = 4
        redView1.titleLabel?.textAlignment = NSTextAlignment.Center
        //redView1.titleLabel!.adjustsFontSizeToFitWidth = true;
        
        if(redView1.titleLabel?.text == "Bayar Pakai QR")
        {
            redView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition+10,0,0,0)
        }
        
        let greenView1:UIButton = UIButton()
        let menuoption4 = menuViewArray[4] as! NSDictionary
        let image5 = UIImage(named: menuoption4["image"] as! NSString as String)
        greenView1.backgroundColor = UIColor.clearColor()
        greenView1.setBackgroundImage(image5, forState: .Normal)
        greenView1.setTitle(menuoption4["title"] as! NSString as String, forState: UIControlState.Normal)
        greenView1.titleEdgeInsets = UIEdgeInsetsMake(titleYposition,0,0,0)
        greenView1.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        greenView1.titleLabel?.font = UIFont(name: "Arial", size: 13)
        greenView1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        customMainMenuView.addSubview(greenView1)
        greenView1.titleLabel!.numberOfLines = 2;
        greenView1.tag = 5
        greenView1.titleLabel?.textAlignment = NSTextAlignment.Center
        //greenView1.titleLabel!.adjustsFontSizeToFitWidth = true;
        

        redView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        redView1.translatesAutoresizingMaskIntoConstraints = false
        greenView1.translatesAutoresizingMaskIntoConstraints = false
        
        let menuItemsArray = ["redView": redView, "greenView": greenView, "blueView": blueView,"redView1": redView1, "greenView1": greenView1, ]

        
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
        
        
        let horizontalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[redView(>=60,<=200)]-20-[greenView(>=60,<=200)]-20-[blueView(>=60,<=200)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        var horizontalGap1:Int = menuWidthHeight-40
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            horizontalGap1 = menuWidthHeight-27
        }
        
        let horizontalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(horizontalGap1))-[redView1(\(menuWidthHeight))]-20-[greenView1(\(menuWidthHeight))]-(\(horizontalGap1))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let equalWidthConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[redView(==greenView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let equalWidthConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[greenView(==blueView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        
        let equalWidthConstraints11:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("[redView1(==greenView1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
    
        let verticalConstraints1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[redView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[greenView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints3:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[blueView(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalHeight:Int = menuWidthHeight+40
        
        
        let verticalConstraints11:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[redView1(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        let verticalConstraints21:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(verticalHeight))-[greenView1(\(menuWidthHeight))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: menuItemsArray)
        
        customMainMenuView.addConstraints(horizontalConstraints);
        customMainMenuView.addConstraints(horizontalConstraints1);
        
        customMainMenuView.addConstraints(equalWidthConstraints1);
        customMainMenuView.addConstraints(equalWidthConstraints2);
        customMainMenuView.addConstraints(equalWidthConstraints11);
        
        customMainMenuView.addConstraints(verticalConstraints1);
        customMainMenuView.addConstraints(verticalConstraints2);
        customMainMenuView.addConstraints(verticalConstraints3);
        
        customMainMenuView.addConstraints(verticalConstraints11);
        customMainMenuView.addConstraints(verticalConstraints21);
    }
    
    
    func menuButtonTapped(sender:UIButton!){
        print("button Touch Down")
        
        var menuViewArray = []
        
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SubMenuViewController") as! SubMenuViewController
        mainMenuViewController.simasPayUserType = simasPayUserType
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR ||  self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER ||  self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI || self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_LAKU_PANDAI)
        {
            if sender.currentTitle == "Transfer"
            {
                let optionDict1 = ["title":"Bank Sinarmas","image":"btn-bsim","":""]
                let optionDict2 = ["title":"Bank Lain","image":"btn-banklain","":""]
                let optionDict3 = ["title":"Laku Pandai","image":"btn-lakupandai","":""]
                menuViewArray = [optionDict1,optionDict2,optionDict3]
                mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
                self.navigationController!.pushViewController(mainMenuViewController, animated: true)
            }
            
            if sender.currentTitle == "Pembelian"
            {
                let cashinViewController = PaymentViewController()
                cashinViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBELIAN
                self.navigationController!.pushViewController(cashinViewController, animated: true)
            }
            
            if sender.currentTitle == "Pembayaran"
            {
                let cashinViewController = PaymentViewController()
                cashinViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_PEMBAYARAN
                self.navigationController!.pushViewController(cashinViewController, animated: true)
            }
            
            if sender.currentTitle == "Tarik Tunai"
            {
                let cashinViewController = CashOutViewController()
                self.navigationController!.pushViewController(cashinViewController, animated: true)
            }
            
            if sender.currentTitle == "Bayar Pakai QR"
            {
                
            }
            
            if sender.currentTitle == "Rekening"
            {
                
                if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_LAKU_PANDAI)
                {
                    let optionDict1 = ["title":"Info Saldo ","image":"btn-infosaldo","":""]
                    let optionDict2 = ["title":"Mutasi","image":"btn-transaksi","":""]
                    let optionDict3 = ["title":"Ganti mPIN","image":"btn-mpin","":""]
                    menuViewArray = [optionDict1,optionDict2,optionDict3]
                }else{
                    let optionDict1 = ["title":"Info Saldo ","image":"btn-infosaldo","":""]
                    let optionDict2 = ["title":"Transaksi","image":"btn-transaksi","":""]
                    let optionDict3 = ["title":"Ganti mPIN","image":"btn-mpin","":""]
                    menuViewArray = [optionDict1,optionDict2,optionDict3]
                }

                mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
                self.navigationController!.pushViewController(mainMenuViewController, animated: true)
            }
        }
        
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT)
        {
            if sender.currentTitle == "Setor Tunai"
            {
                let cashinViewController = CashinViewController()
                self.navigationController!.pushViewController(cashinViewController, animated: true)
            }
            
            if sender.currentTitle == "Buka Rekening"
            {
                
                let agentRegisViewController =  AgentRegistrationViewC ()
                //self.storyboard!.instantiateViewControllerWithIdentifier("AgentRegistrationViewC") as! AgentRegistrationViewC
                self.navigationController!.pushViewController(agentRegisViewController, animated: true)
                
            }
            
            if sender.currentTitle == "Tutup Rekening"
            {
                let closeAccountViewController = CloseAccountViewController()
                self.navigationController!.pushViewController(closeAccountViewController, animated: true)
            }
            
            if sender.currentTitle == "Transaksi"
            {
                let optionDict1 = ["title":"Transfer","image":"btn-transfer","":""]
                let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","":""]
                let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","":""]
                let optionDict4 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","":""]
                
                menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4]
                mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
                self.navigationController!.pushViewController(mainMenuViewController, animated: true)
            }
            
            if sender.currentTitle == "Rekening"
            {
                let optionDict1 = ["title":"Info Saldo ","image":"btn-infosaldo","":""]
                let optionDict2 = ["title":"Mutasi","image":"btn-transaksi","":""]
                let optionDict3 = ["title":"Ganti mPIN","image":"btn-mpin","":""]
                
                
                
                
                menuViewArray = [optionDict1,optionDict2,optionDict3]
                 mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
                self.navigationController!.pushViewController(mainMenuViewController, animated: true)
            }
            
            if sender.currentTitle == "Referral"
            {
                let closeAccountViewController = ReferralViewController()
                self.navigationController!.pushViewController(closeAccountViewController, animated: true)
            }
        }
    }
    
    @IBAction func logoutBtnClicked(sender: AnyObject) {
    
        for  viewController in (self.navigationController?.viewControllers)!        {
            if viewController.isKindOfClass(LoginViewController)
            {
                self.navigationController?.popToViewController(viewController, animated: true)
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
}