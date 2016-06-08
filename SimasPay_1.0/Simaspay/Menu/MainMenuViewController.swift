//
//  MainmenuViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 30/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController,DIMOPayDelegate,CZPickerViewDelegate
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
    
    var isFlashizInitialized:Bool = false
    var  mfaOTPPicker:CZPickerView!
    var flashizInqueryDict = NSMutableDictionary() as [NSObject : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       //accountNameLabel.textColor = UIColor.whiteColor()
       //accountNumberLabel.textColor = UIColor.whiteColor()
        
       // agentChangeUserTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(120,0,0,0)
       // logoutButton.titleEdgeInsets = UIEdgeInsetsMake(150,0,0,0)
        
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
        redView.addTarget(self, action: #selector(MainMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        greenView.addTarget(self, action: #selector(MainMenuViewController.menuButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        if (self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR ||  self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER ||  self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI )
        {
            if sender.currentTitle == "Transfer"
            {
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
            
            if sender.currentTitle == "Tarik Tunai"
            {
                let cashinViewController = CashOutViewController()
                self.navigationController!.pushViewController(cashinViewController, animated: true)
            }
            
            if sender.currentTitle == "Bayar Pakai QR"
            {
                payBYQRBtnClicked()
            }
            
            if sender.currentTitle == "Rekening"
            {
                
                if(self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI)
                {
                    let optionDict1 = ["title":"Info Saldo","image":"btn-infosaldo","":""]
                    let optionDict2 = ["title":"Mutasi","image":"btn-transaksi","":""]
                    let optionDict3 = ["title":"Ganti mPIN","image":"btn-mpin","":""]
                    menuViewArray = [optionDict1,optionDict2,optionDict3]
                }else{
                    let optionDict1 = ["title":"Info Saldo","image":"btn-infosaldo","":""]
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
            if sender.currentTitle == "Bayar Pakai QR"
            {
                payBYQRBtnClicked()
            }
            
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
                let optionDict1 = ["title":"Info Saldo","image":"btn-infosaldo","":""]
                let optionDict2 = ["title":"Mutasi","image":"btn-transaksi","":""]
                let optionDict3 = ["title":"Ganti mPIN","image":"btn-mpin","":""]

                menuViewArray = [optionDict1,optionDict2,optionDict3]
                 mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
                self.navigationController!.pushViewController(mainMenuViewController, animated: true)
            }
            
            if sender.currentTitle == "Referral"
            {
                self.gotReferralViewController()
            }
        }
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
    
    
    func gotReferralViewController()
    {
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_REFRRRAL
        dict[VERSION] = "0"
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
            // Handle success response
            dispatch_async(dispatch_get_main_queue()) {
                
                EZLoadingActivity.hide()
                print("Referral List Response : ",response)
                
                let responseDict = response as! NSDictionary
                let referralList = responseDict.valueForKey("referreal_list") as! NSArray
                
                if(referralList.count > 0){
                    let referralViewController = ReferralViewController()
                    referralViewController.pickerViewData = referralList
                    self.navigationController!.pushViewController(referralViewController, animated: true)
                }
                
            }
            
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                }
                
        })

    }
    
    func gotoPurchaseViewController(){
        
        //category.purchase
        
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
        
        flashizInitSDK()
        DIMOPay.startSDK(self, withDelegate: self)
    }
    
    
    func flashizInitSDK()
    {
        DIMOPay.setServerURL(ServerURLDev)
        DIMOPay.setIsPolling(false)
        DIMOPay.setMinimumTransaction(1000)
        
    }
    
    @IBAction func closeSDKChoice(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// This function will be called when EULA state is false
    /// Return view controller, there is a standard view controller for eula or using your own EULA view controller
    /// example : [DIMOPay EULAWithStringHTML:@"test<br>Test2"];
    
    
    
    func callbackShowEULA()->UIViewController
    {
        return DIMOPay.EULAWithStringHTML(EulaTermsText)
    }
    
    /// This function will be called when the EULA state changed
    func callbackEULAStateChanged(state:Bool)
    {
        
    }
    
    
    /// This function will be called when the SDK opened at the first time or there is no user api key found
    
    func callbackGenerateUserAPIKey() {
        generateUserkey()
    }
    
    /// This function will be called when user cancel process payment or close invoice summary
    
    func callbackUserHasCancelTransaction()
    {
        
    }
    
    /// This function will be called when user clicked pay button and host-app need to doing payment here
    
    func callbackPayInvoice(invoice:DIMOInvoiceModel)
    {
        payInvoice(invoice.invoiceId, amount: invoice.originalAmount, discountedAmount: invoice.paidAmount, merchantName: invoice.merchantName, nbOfCoupons: invoice.numberOfCoupons, discountType: invoice.discountType, loyaltyProgramName: invoice.loyaltyProgramName, amountOfDiscount: invoice.amountOfDiscount, tippingAmount: invoice.tipAmount, pointsRedeemed: 0, amountRedeemed: 0)
    }

    /// This function will be called when isUsingCustomDialog is Yes, and host-app need to show their own dialog
    
    func callbackShowDialog(paymentStatus: PaymentStatus, withMessage message: String!) {
    }
    
    
    
    
    /// This function will be called when the sdk has been closed
    
    func callbackSDKClosed()
    {
        self.isFlashizInitialized = false
    }
    
    /// This function will be called when lost internet connection error page appear
    func callbackLostConnection()
    {
        
    }
    
    
    /// Return true to close sdk
    /// This function will be called when invalid qr code error page appear
    func callbackInvalidQRCode()->Bool
    {
         return false
    }

    /// Return true to close sdk
    /// This function will be called when payment failed error page appear
    
    func callbackTransactionStatus(paymentStatus: PaymentStatus, withMessage message: String!) -> Bool {
        
        return false
    }


    /// Return true to close sdk
    /// This function will be called when unknown error page appear
    func callbackUnknowError()->Bool
    {
        return false
    }
    
    
    /// This function will be called when authentication error page appear
    func callbackAuthenticationError()
    {
        
    }
    
    func payInvoice(invoiceId:NSString, amount:Double, discountedAmount:Double,merchantName:NSString,nbOfCoupons:Int32,discountType:NSString,loyaltyProgramName:NSString,amountOfDiscount:Double,tippingAmount:Double,pointsRedeemed:Int,amountRedeemed:Int)
    {
        if(amount == 0)
        {
            EZLoadingActivity.show("Loading...", disableUI: true)
            return
        }
        
        /* 
        channelID=7&
           amountRedeemed=0&
           discountType=&
           discountAmount=0& 
           numberOfCoupons=0& 
           amount=500&
           pointsRedeemed=0&
            loyalityName=&
            tippingAmount=0&
            merchantData=Pawon+Mobile+POS&
        
           service=Payment& 
          sourcePocketCode=2&
        paymentMode=QRPayment&
        sourceMDN=629550555560&
        txnName=QRPaymentInquiry&
        userAPIKey=3146a6f1680ba40878b26805635a56ab542f565d&
        billNo=QANhrLY3GlVx&
        
        institutionID=&
        
        billerCode=QRFLASHIZ& sourcePIN=8499911894479C416076EDE5&
        institutionID=&mspID=1&accountType=
        
        */
        
        flashizInqueryDict["amount"] = "\(amount)"
        flashizInqueryDict["invoiceId"] = "\(invoiceId)"
        flashizInqueryDict["merchantData"] = "\(merchantName)"
        flashizInqueryDict["nbOfCoupons"] = "\(nbOfCoupons)"
        flashizInqueryDict["discountedAmount"] = "\(discountedAmount)"
        flashizInqueryDict["amountOfDiscount"] = "\(amountOfDiscount)"
        flashizInqueryDict["discountType"] = "\(discountType)"
        flashizInqueryDict["tippingAmount"] = "\(tippingAmount)"
        flashizInqueryDict["pointsRedeemed"] = "\(pointsRedeemed)"
        flashizInqueryDict["amountRedeemed"] = "\(amountRedeemed)"
        flashizInqueryDict["loyalityName"] = "\(loyaltyProgramName)"
        
        flashizInqueryDict[BILLNO] = "\(invoiceId)"
        flashizInqueryDict[BILLERCODE] = "QRFLASHIZ"
        
        flashizInqueryDict[SERVICE] = SERVICE_PAYMENT
        flashizInqueryDict[PAYMENT_MODE] = QR_PAYMENT
        flashizInqueryDict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        flashizInqueryDict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        flashizInqueryDict[TXNNAME] =  TXN_FlashIz_BillPay_Inquiry
        
        let defaults = NSUserDefaults.standardUserDefaults()
        flashizInqueryDict[TXNNAME] =  TXN_FlashIz_BillPay_Inquiry
        flashizInqueryDict[TXN_GetUserKey] = defaults.objectForKey("GetUserAPIKey") as! String
    
        if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_ACCOUNT)
        {
            flashizInqueryDict[SOURCEPOCKETCODE] = "1"
        }
        
        if(self.simasPayUserType == SimasPayUserType.SIMASPAY_AGENT_REGULAR || self.simasPayUserType == SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER)
        {
            flashizInqueryDict[SOURCEPOCKETCODE] = "2"
        }
    
        if(self.simasPayUserType == SimasPayUserType.SIMASPAY_LAKU_PANDAI)
        {
            flashizInqueryDict[SOURCEPOCKETCODE] = "6"
        }
        
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            flashizInqueryDict, successBlock: { (response) -> Void in
                // Handle success response
                dispatch_async(dispatch_get_main_queue()) {
                    
                    EZLoadingActivity.hide()
                    
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }
                    
                    print("Flashiz Inquery Response : ",response)
                    
                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    if( messagecode == FlashIS_Inquery_SuccessCode )
                    {
                        
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
    

    func generateUserkey()
    {
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        
        let defaults = NSUserDefaults.standardUserDefaults()

        if((defaults.objectForKey("GetUserAPIKey")) != nil)
        {
            DIMOPay.setUserAPIKey(defaults.objectForKey("GetUserAPIKey") as! String)
        }else{
            
            let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
            var dict = NSMutableDictionary() as [NSObject : AnyObject]
            dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
            dict[mPIN_STRING] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
            dict[SERVICE] = SERVICE_ACCOUNT
            dict[TXNNAME] = TXN_GetUserKey
            dict[SOURCE_APP_TYPE_KEY] = "subapp"
            dict[SOURCE_APP_VERSION_KEY] = version
            dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.currentDevice().modelName)  \(UIDevice.currentDevice().systemVersion)"

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
                        
                        print("Get User API key Response : ",response)
                        
                        let responseDict = response as NSDictionary
                        let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                        let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                        
                        if( messagecode == FlashIS_User_Key_SuccessCode )
                        {
                            let userAPIKeyText  = responseDict.valueForKeyPath("response.userAPIKey.text") as! String
                             defaults.setObject(userAPIKeyText, forKey: "GetUserAPIKey")
                            DIMOPay.setUserAPIKey(userAPIKeyText)
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
    }
    

    func timeBetweenEachPollCall()->Double
    {
        return 500
    }
    
    func timeBeforeStartingPoll()->Double
    {
        return 1000
    }
    
    // MARK: showEulaView delegate method
    func didRefuseEula()
    {
        self.isFlashizInitialized = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didAcceptEula()
    {
        
    }
    
    func didCloseSdk()
    {
        
    }
    
     // MARK: MFA OTP Reading
    
    
    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "6 digit kode OTP"
        tField = textField
        tField.secureTextEntry = true
        tField.keyboardType = .NumberPad
    }
    
    
    @available(iOS 8.0, *)
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    
    
    @IBAction func senfOTPClicked(sender: AnyObject) {
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "readOTPNotification:", name:OTPNotificationKey, object: nil)
        
        let sourceMDN = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        
        mfaOTPPicker = CZPickerView.init(headerTitle: "Masukkan Kode OTP", messageText: "Kode OTP dan link telah dikirimkan ke \n nomor \(sourceMDN). Masukkan kode \n tersebut atau akses link yang tersedia.", viewController: self)
        
        mfaOTPPicker.delegate = self
        mfaOTPPicker.needFooterView = true
        mfaOTPPicker.tapBackgroundToDismiss = false;
        mfaOTPPicker.show()
        
        /*
            let sourceMDN = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
            
            let alertTitle = "Masukkan Kode OTP"
            let message = "Kode OTP dan link telah dikirimkan ke \n nomor \(sourceMDN). Masukkan kode \n tersebut atau akses link yang tersedia."
            
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
                alertController.addTextFieldWithConfigurationHandler(configurationTextField)
                alertController.addAction(UIAlertAction(title: "Batal", style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                    print("Done !!")
                    print("Item : \(self.tField.text)")
                    if(self.tField.text?.length > 0)
                    {
                        
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert("Please Enter OTP.",viewController: self)
                    }
                    
                }))
                self.presentViewController(alertController, animated: true, completion: {
                    print("completion block")
                })
                
            } else {
                // Fallback on earlier versions
                let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = message
                alert.addButtonWithTitle("OK")
                alert.addButtonWithTitle("Batal")
                alert.show()
            };

        */
        
    }
    
    func czpickerViewDidClickOKButton(pickerView: CZPickerView!, otpText: String!) {
        
      /*  if(otpText.length > 0)
        {
            if(self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TUTUP_REKENING)
            {
                self.confirmationRequestDictonary[OTP] = SimaspayUtility.simasPayRSAencryption(otpText)
            }else{
                self.confirmationRequestDictonary[MFAOTP] = SimaspayUtility.simasPayRSAencryption(otpText)
            }
            
            self.confirmationServiceRequest()
        }else{
            SimasPayAlert.showSimasPayAlert("Masukkan Kode OTP.",viewController: self)
        }
        */
    }
    
    func czpickerViewDidClickCancelButton(pickerView: CZPickerView!) {
        
    }
    
    func czpickerViewResendOTP(pickerView: CZPickerView!) {
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SERVICE] = SERVICE_WALLET
        dict[TXNNAME] = TXN_RESEND_MFAOTP
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        //dict[SCTL_ID] = self.confirmationRequestDictonary[SCTL_ID]
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
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
                    
                    if( messagecode == SIMASPAY_RESEND_OTP_SUCESS)
                    {
                        self.mfaOTPPicker.reSendOTPSuccess()
                        
                    }else if( messagecode == SIMASPAY_RESEND_OTP_FAILED)
                    {
                        
                    }else if( messagecode == SIMASPAY_RESEND_OTP_LIMIT_REACHED)
                    {
                        self.mfaOTPPicker.hide()
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                        
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                        
                    }
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                }
        })
    }
    
}