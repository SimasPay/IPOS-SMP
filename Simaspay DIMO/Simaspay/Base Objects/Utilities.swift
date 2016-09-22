//
//  Utilities.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import Foundation

var strLocale:String!

enum AppLocale: Int {
    case AppLocaleEnglish = 1, AppLocaleIndonesia
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