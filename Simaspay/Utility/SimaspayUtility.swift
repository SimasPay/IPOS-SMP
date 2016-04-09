//
//  SimaspayUtility.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 16/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

let simasPayPlistFileName:String = "simaspayApplication.plist"


enum SimasPayUserType : Int
{
    case SIMASPAY_REGULAR_BANK_CUSTOMER
    case SIMASPAY_LAKU_PANDAI
    
    case SIMASPAY_AGENT_ACCOUNT
    case SIMASPAY_AGENT_REGULAR
    
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

enum SimasPayBillerLevel : Int
{
    case SIMASPAY_PRODUCT_CATEGORY
    case SIMASPAY_PRODUCT_PROVIDER
    case SIMASPAY_PRODUCT_NAME
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
    case SIMASPAY_PEMBAYARAN
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


extension String {
    var length: Int {
        return (self as NSString).length
    }
}

extension NSString
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}


extension UIImage
{
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}


extension UITextField
{
    func isValid()->Bool
    {
        return (self.text!.length > 0) ? true : false
    }
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
    
    class func getNormalisedMDN(var sourceMDN:NSString)->NSString
    {
        if(sourceMDN.length > 1 &&  sourceMDN.hasPrefix("0"))
        {
            sourceMDN = sourceMDN.substringFromIndex(1)
            return "62\(sourceMDN)"
        }
        if(!(sourceMDN.hasPrefix("62")))
        {
            return "62\(sourceMDN)"
        }
        return sourceMDN
    }

    class func simasPayRSAencryption( inputString: String)->NSString
    {
        let publickKeyResponse = SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_PUBLIC_KEY)
        let publicKey = publickKeyResponse.valueForKeyPath("response.PublicKeyModulus.text") as! String
        let exponentKey = publickKeyResponse.valueForKeyPath("response.PublicKeyExponent.text") as! String
        
        let rsa = XRSA.init(publicKeyModulus: publicKey, withPublicKeyExponent: exponentKey)
        let encryptedString = rsa.encryptToString(inputString)
        return encryptedString
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
            fieldLabel.attributedText = attString
        }
        
    }
    
    class func getSimasPayBackButton(viewController:UIViewController)->UIButton
    {
     
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 10, 18)
        backButton.addTarget(viewController, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "btn-back"), forState: UIControlState.Normal)
        return backButton
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
 
    class func print(items: Any..., separator: String = " ", terminator: String = "\n") {
        
        #if DEBUG
            
            var idx = items.startIndex
            let endIdx = items.endIndex
            
            repeat {
                Swift.print(items[idx++], separator: separator, terminator: idx == endIdx ? terminator : separator)
            }
                while idx < endIdx
            
        #endif
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

}