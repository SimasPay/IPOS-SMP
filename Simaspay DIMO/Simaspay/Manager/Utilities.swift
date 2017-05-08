//
//  Utilities.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import Foundation

var strLocale: String!
var publicKeys: NSDictionary!
var loginResult: NSDictionary!
var _isLogin = false
var _MDNNumber: String!
var _mPINCode: String!
var _userApiKey: String!

var _SOURCEPOCKETCODE: String!
var _DESTPOCKETCODE: String!

enum AppLocale: Int {
    case appLocaleEnglish = 1, appLocaleIndonesia
}

func DLog(_ str: String) {
    SimasUtility.dimoLog(str)
}

func setLocale(_ appLocale: AppLocale) {
    if (appLocale == .appLocaleEnglish) {
        strLocale = "ENGLISH"
    } else {
        strLocale = "INDONESIAN"
    }
}

func getString(_ key: String) -> String{
    var result: NSString =
        NSLocalizedString(key, tableName: strLocale, bundle: Bundle.main, value: "", comment: "") as NSString
    if (result.isEqual(to: key)) {
        result =
            NSLocalizedString(key, tableName: "INDONESIAN", bundle: Bundle.main, value: "", comment: "") as NSString
    }
    
    if (result.length == 0) {
        result = "";
    }
    return result as String;
}

func getNormalisedMDN(_ sourceMDN:NSString)->NSString {
    var newSourceMdn = sourceMDN
    if(newSourceMdn.length > 1 &&  newSourceMdn.hasPrefix("0"))
    {
        newSourceMdn = newSourceMdn.substring(from: 1) as NSString
        return "62\(newSourceMdn)" as NSString
    }
    if(!(newSourceMdn.hasPrefix("62")))
    {
        return "62\(newSourceMdn)" as NSString
    }
    return newSourceMdn
}


func showOTPWith(title: String, view : UIView) {
    DIMOAlertView.showPrompt(withTitle: title, view: view, okTitle: "OK") { (index, alertView) in
        if index == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
        }
    }
}

func simasPayRSAencryption( _ inputString: String)-> String {
    let publickKeyResponse = publicKeys as NSDictionary
    let publicKey = publickKeyResponse.value(forKeyPath: "PublicKeyModulus.text") as! String
    let exponentKey = publickKeyResponse.value(forKeyPath: "PublicKeyExponent.text") as! String
    
    let rsa = XRSA.init(publicKeyModulus: publicKey, withPublicKeyExponent: exponentKey)
    let encryptedString = rsa?.encrypt(to: inputString)
    return encryptedString!
}
