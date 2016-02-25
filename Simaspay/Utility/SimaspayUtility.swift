//
//  SimaspayUtility.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 16/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

let simasPayPlistFileName:String = "simaspayApplication.plist"


enum SimasPayUserType : Int
{
    case SIMASPAY_REGULAR_BANK_CUSTOMER
    case SIMASPAY_LAKU_PANDAI
    case SIMASPAY_AGENT_REGULAR
    case SIMASPAY_AGENT_LAKU_PANDAI
    case SIMASPAY_AGENT_ACCOUNT
}


enum SimasPayMainMenuOptionType : Int
{
    case SIMASPAY_TRANSFER
    case SIMASPAY_PEMBELIAN
    case SIMASPAY_PEMBAYARAN
    case SIMASPAY_TARIK_TUNAI
    case SIMASPAY_BAYAR_PAKAI_QR
    case SIMASPAY_REKENING
    
    case SIMASPAY_SETOR_TUNAI
    case SIMASPAY_BUKA_REKENING
    case SIMASPAY_TUTUP_REKENING
    case SIMASPAY_TRANSAKSI
    case SIMASPAY_REFERRAL
}

enum SimasPaySubMenuOptionType : Int
{
    case SIMASPAY_TRANSFER
    case SIMASPAY_TARIK_TUNAI
    case SIMASPAY_BAYAR_PAKAI_QR
    case SIMASPAY_REKENING
    
    case SIMASPAY_SETOR_TUNAI
    case SIMASPAY_BUKA_REKENING
    case SIMASPAY_TUTUP_REKENING
    case SIMASPAY_TRANSAKSI
    case SIMASPAY_REFERRAL
    
    case SIMASPAY_PEMBELIAN
    case SIMASPAY_PEMBAYARAN

}



enum SimasPayOptionType : Int
{
    case SIMASPAY_TRANSFER
    case SIMASPAY_TARIK_TUNAI
    case SIMASPAY_BAYAR_PAKAI_QR
    case SIMASPAY_REKENING
    
    case SIMASPAY_SETOR_TUNAI
    case SIMASPAY_BUKA_REKENING
    case SIMASPAY_TUTUP_REKENING
    case SIMASPAY_TRANSAKSI
    case SIMASPAY_REFERRAL
    case SIMASPAY_AGENT_REGISTRATION
    
    case SIMASPAY_TRANSFER_BANKSINARMAS
    case SIMASPAY_TRANSFER_BANK_LAIN
    case SIMASPAY_TRANSFER_LAKU_PANDAI
    
    case SIMASPAY_REGULAR_TRANSAKSI
    
    case SIMASPAY_PEMBELIAN
    case SIMASPAY_PEMBELIAN_BILLER_LIST
    case SIMASPAY_PEMBAYARAN
    case SIMASPAY_PEMBAYARAN_BILLER_LIST
}


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}





extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func simasPayRedColor() -> UIColor {
        return UIColor(red: 204/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    static func agentRegisBtnLightColor() -> UIColor {
        return UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1.0)
    }
    
    static func downloadViewTitleColor() -> UIColor {
        return UIColor(red: 91/255.0, green: 91/255.0, blue: 91/255.0, alpha: 1.0)
    }
}


extension UIView {
    
    func addDashedBorder() {
        let color = UIColor.redColor().CGColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).CGPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
}


class SimaspayUtility: NSObject {
    
    // type method
    class func clearNavigationBarcolor( navigationController : UINavigationController ) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.translucent = true
    }
    
    

    //Set SimasPay title label with attributes text 
    class func setSimaspayAttributestitleLabel(titleLabel:UILabel){
        
        // 1
        let string = titleLabel.text! as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        // 2
        let firstAttributes = [NSForegroundColorAttributeName: UIColor.darkTextColor()]
        // 3
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString("pay"))
        // 4
        titleLabel.attributedText = attributedString
        
        /* if UIScreen.mainScreen().bounds.size.height == 480 {
        // iPhone 4
        simaspayTitleLabel.font = simaspayTitleLabel.font.fontWithSize(45)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
        // IPhone 5
        simaspayTitleLabel.font = simaspayTitleLabel.font.fontWithSize(45)
        } else*/ if UIScreen.mainScreen().bounds.size.width == 375 {
            // iPhone 6
            titleLabel.font = titleLabel.font.fontWithSize(60)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            // iPhone 6+
            titleLabel.font = titleLabel.font.fontWithSize(65)
        } /*else if UIScreen.mainScreen().bounds.size.width == 768 {
        // iPad
        simaspayTitleLabel.font = simaspayTitleLabel.font.fontWithSize(20)
        } */
        
    }
    
    // Set Simaspay style to  UIView
    class func setSimasPayUIviewStyle(simaspayUIView:UIView) {
        
        simaspayUIView.layer.cornerRadius = 5;
        //simaspayUIView.layer.masksToBounds = true;
        
        simaspayUIView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        simaspayUIView.layer.shadowOpacity = 0.5;
        simaspayUIView.layer.shadowOffset = CGSizeMake(2, 2);
        simaspayUIView.layer.shadowRadius = 0.5;
    }
    
    
    
    // Set Simaspay style to  textfields
    class func setSimasPayTextfieldStyle(simaspayTextField:UITextField) {
        
        simaspayTextField.layer.cornerRadius = 5;
        simaspayTextField.layer.masksToBounds = false;
        
        simaspayTextField.layer.shadowColor = UIColor.lightGrayColor().CGColor
        simaspayTextField.layer.shadowOpacity = 0.5;
        simaspayTextField.layer.shadowOffset = CGSizeMake(2, 2);
        simaspayTextField.layer.shadowRadius = 0.5;
        
    }
    //Set MobileNumber textfield leftimage title label with attributes text
    class func setMobileNumberTextFieldImage(mobilenumberField:UITextField) {
        
        let mobilenumberImageView = UIImageView();
        mobilenumberImageView.frame = CGRect(x: 9, y: (mobilenumberField.frame.height-25)/2, width: 18, height: 25)
        let phoneImage = UIImage(named: "iPhone");
        mobilenumberImageView.image = phoneImage;
        
        let mobileNumberView = UIView(frame: CGRectMake(0, 0, 20+18, mobilenumberField.frame.height))
        mobileNumberView.addSubview(mobilenumberImageView);
        mobilenumberField.leftView = mobileNumberView;
        mobilenumberField.leftViewMode = UITextFieldViewMode.Always
    }
    
    
    
    //Set mPIN  textfield leftimage title label with attributes text
    class func setMPINTextFieldImage(passwordField:UITextField) {
        
        let passwordImageView = UIImageView();
        passwordImageView.frame = CGRect(x: 10, y: (passwordField.frame.height-25)/2, width: 20, height: 25)
        let passwordimage = UIImage(named: "mPin");
        passwordImageView.image = passwordimage;
        
        let passwordView = UIView(frame: CGRectMake(0, 0, 20+20, passwordField.frame.height))
        passwordView.addSubview(passwordImageView);
        passwordField.leftView = passwordView;
        passwordField.leftViewMode = UITextFieldViewMode.Always
        
    }
    
    //Set OTP  textfield leftimage title label with attributes text
    class func setOTPTextFieldImage(passwordField:UITextField) {
        
        let passwordImageView = UIImageView();
        passwordImageView.frame = CGRect(x: 9, y: (passwordField.frame.height-25)/2, width: 18, height: 25)
        let passwordimage = UIImage(named: "ic-otp");
        passwordImageView.image = passwordimage;
        
        let passwordView = UIView(frame: CGRectMake(0, 0, 20+18, passwordField.frame.height))
        passwordView.addSubview(passwordImageView);
        passwordField.leftView = passwordView;
        passwordField.leftViewMode = UITextFieldViewMode.Always
        
    }
    
    class func simasPayUnderlineButtonTextLabel(button: UIButton) {
        
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: button.titleLabel!.text!)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, button.titleLabel!.text!.utf16.count))
        button.setAttributedTitle(titleString, forState: .Normal)
    }
    
    class func applyStarMarkToLabel(fieldLabel:UILabel)
    {
        //let font:UIFont? = UIFont(name: "Helvetica", size:17)
        //let fontSuper:UIFont? = UIFont(name: "Helvetica", size:16)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: fieldLabel.text!, attributes: [NSFontAttributeName:fieldLabel.font!])
        let range: Range<String.Index> = fieldLabel.text!.rangeOfString("*")!
        if fieldLabel.text!.rangeOfString("*") != nil
        {
            let index: Int = fieldLabel.text!.startIndex.distanceTo(range.startIndex)
            attString.setAttributes([NSFontAttributeName:fieldLabel.font!,NSBaselineOffsetAttributeName:0], range: NSRange(location:index,length:1))
            fieldLabel.attributedText = attString;
        }
        
    }
    
    
    
    // Get the documents Directory
    func documentsDirectory() -> String {
        
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        
        return documentsFolderPath
    }
    
    // Get path for a file in the directory
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let writePath = (documentsDirectory() as NSString).stringByAppendingPathComponent(simasPayPlistFileName)
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(writePath)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(writePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return (writePath as NSString).stringByAppendingPathComponent(filename)
    }
    
    // type method to save data to .Plist file
    class func saveDataToPlist(toSaveData:AnyObject,toSaveKey:NSString)
    {
        
        let path = SimaspayUtility().fileInDocumentsDirectory(simasPayPlistFileName)
        
        if let checkToSaveData = toSaveData as? String
        {
            do {
                try checkToSaveData.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            }
            catch {
                print("Error saving file at path: \(path) with error: \(error)")
            }
        }
        
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.setObject(toSaveData, forKey: toSaveKey)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            
            if let privPath = NSBundle.mainBundle().pathForResource(simasPayPlistFileName, ofType: "plist")
            {
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.setObject(toSaveData, forKey: toSaveKey)
                    if dict.writeToFile(path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
    
    class func getDataFromPlist(dataForKey:NSString)->AnyObject
    {
        let path = SimaspayUtility().fileInDocumentsDirectory(simasPayPlistFileName)
        
        var output:AnyObject = false
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            output = dict.objectForKey(dataForKey)!
        }else{
            
            if let privPath = NSBundle.mainBundle().pathForResource(simasPayPlistFileName, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    output = dict.objectForKey(dataForKey)!
                }else{
                    output = false
                    print("error_read")
                }
            }else{
                output = false
                print("error_read")
            }
        }
        return output
    }
    
}