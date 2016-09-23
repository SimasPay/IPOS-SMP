//
//  Utilities.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import Foundation

var strLocale: String!
var publicKeys: [NSObject : AnyObject]!
var loginResult: [NSObject : AnyObject]!
var _isLogin = false
var _MDNNumber: String!
var _mPINCode: String!
var _userApiKey: String!

var _SOURCEPOCKETCODE: String!
var _DESTPOCKETCODE: String!

enum AppLocale: Int {
    case AppLocaleEnglish = 1, AppLocaleIndonesia
}

func DLog(str: String) {
    DIMOUtility.DIMOLog(str)
}

func setLocale(appLocale: AppLocale) {
    if (appLocale == .AppLocaleEnglish) {
        strLocale = "ENGLISH"
    } else {
        strLocale = "INDONESIAN"
    }
}

func getString(key: String) -> String{
    var result: NSString =
        NSLocalizedString(key, tableName: strLocale, bundle: NSBundle.mainBundle(), value: "", comment: "")
    if (result.isEqualToString(key)) {
        result =
            NSLocalizedString(key, tableName: "INDONESIAN", bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    if (result.length == 0) {
        result = "";
    }
    return result as String;
}

func getNormalisedMDN(sourceMDN:NSString)->NSString {
    var newSourceMdn = sourceMDN
    if(newSourceMdn.length > 1 &&  newSourceMdn.hasPrefix("0"))
    {
        newSourceMdn = newSourceMdn.substringFromIndex(1)
        return "62\(newSourceMdn)"
    }
    if(!(newSourceMdn.hasPrefix("62")))
    {
        return "62\(newSourceMdn)"
    }
    return newSourceMdn
}

func simasPayRSAencryption( inputString: String)->NSString {
    let publickKeyResponse = publicKeys as NSDictionary
    let publicKey = publickKeyResponse.valueForKeyPath("PublicKeyModulus.text") as! String
    let exponentKey = publickKeyResponse.valueForKeyPath("PublicKeyExponent.text") as! String
    
    let rsa = XRSA.init(publicKeyModulus: publicKey, withPublicKeyExponent: exponentKey)
    let encryptedString = rsa.encryptToString(inputString)
    return encryptedString
}