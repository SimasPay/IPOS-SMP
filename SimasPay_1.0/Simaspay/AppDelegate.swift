//
//  AppDelegate.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationVar:UIApplication!
    var isFirstTime : Bool!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        applicationVar = application
        
        isFirstTime = true
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        XRSA.resetKeychain()
        self.getSimasPayPublicKey()
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        /*let publickKeyResponse = SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_PUBLIC_KEY)
        if(publickKeyResponse == nil && !isFirstTime)
        {
            getSimasPayPublicKey()
        } */
        
        getSimasPayPublicKey()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        print("Calling Application Bundle ID : %@", options["UIApplicationOpenURLOptionsSourceApplicationKey"]);
        
        print("URL Scheme : \(url.scheme)")
        print("URL Query : \(url.query)")
        
        print("URL Dictonary : \(SimasPayPlistUtility.parseQueryString(url.query))")
        
        NSNotificationCenter.defaultCenter().postNotificationName(OTPNotificationKey, object: nil, userInfo: SimasPayPlistUtility.parseQueryString(url.query))

        
        return true
    }
    
    func getSimasPayPublicKey()
    {
        let navigationController = applicationVar.windows[0].rootViewController as! UINavigationController
        let activeViewCont = navigationController.visibleViewController
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GETPUBLC_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
    
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
            // Handle success response
                dispatch_async(dispatch_get_main_queue()) {
                    let responseDict = response as NSDictionary
                    SimasPayPlistUtility.saveDataToPlist(responseDict, key: SIMASPAY_PUBLIC_KEY)
                    print("Response : ",SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_PUBLIC_KEY))
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController: activeViewCont!)
                }
                
            })
        
    }
}

