//
//  CategoriesManager.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import Foundation

extension UIView {
    func updateViewRoundedWithShadow() {
        /*
        let temp = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        temp.backgroundColor = backgroundColor
        temp.layer.cornerRadius = 5
        temp.clipsToBounds = true
        insertSubview(temp, at: 0)
        
        self.backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.black.withAlphaComponent(0.23).cgColor
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSize(width: 2, height: 2);
        layer.shadowRadius = 0.5;
 */
        let layer = self.layer
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.withAlphaComponent(0.23).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 2, height: 2);
        layer.shadowRadius = 4
        // corner radius
    }
    
    func addUnderline() {
        //buttonUnderline
        let size = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) as CGFloat
//        if (self.frame.size.width >= max || self.frame.size.height >= max) {
//            return
//        }
        let line = CALayer()
        line.frame = CGRect(x: 0, y: self.bounds.size.height - 1 , width: self.frame.size.width, height: 1)
        line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
        self.layer.addSublayer(line)
    }
}

extension UITextField {
    func length()->Int {
        return (self.text?.characters.count)!
    }
    func isValid()->Bool {
        return (self.length() > 0) ? true : false
    }
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
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
