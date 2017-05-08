//
//  SplashScreenViewController.swift
//  Simaspay
//
//  Created by Dimo on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {
    
    @IBOutlet var lblWelcome: BaseLabel!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var imgLogoSinarmas: UIImageView!
    
    var timer = Timer()
    var state :Bool = false
    
    
    static func initWithOwnNib() -> SplashScreenViewController {
        let obj:SplashScreenViewController = SplashScreenViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {   
        super.viewDidLoad()
    
        lblWelcome.textAlignment = .center
        lblWelcome.text = getString("SplashLableWelcome")
        
        imgLogo.image = UIImage(named: "logo_Image")
        imgLogoSinarmas.image = UIImage(named: "logo_SinarmasBank_Image")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        state = defaults.bool(forKey: "eulaState")
        var message = ""
        if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showNormalTitle("Error", message: message, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                exit(1)
            }, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        self.getPublicKey()
    }
    
    
    //MARK: Get public key
    //    typealias CompletionBlock = () -> Void
    func getPublicKey() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_GETPUBLC_KEY
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "1"
        dict[SIMASPAY_ACTIVITY] = SIMASPAY_ACTIVITY_VALUE
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager.callAPI(withParameters: param, withSessionCheck: false, andComplete: { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
//                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                    DIMOAlertView.showNormalTitle("Error", message: error.userInfo["error"] as! String, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                        exit(1)
                    }, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
//                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                    DIMOAlertView.showNormalTitle("Error", message: error.localizedDescription, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                        exit(1)
                    }, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
            if (responseDict.allKeys.count == 0) {
//                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
                DIMOAlertView.showNormalTitle("Error", message: String("ErrorMessageRequestFailed"), alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                    exit(1)
                }, cancelButtonTitle: "OK")
                return
            } else {
                // success
                if (responseDict.allKeys.count > 0) {
                    // set public keys
                    publicKeys = responseDict;
                    let message = responseDict.value(forKeyPath: "message.text") as! String
                    if (responseDict.value(forKeyPath: "message.code") as! String == "546") {
                        DIMOAlertView.showNormalTitle("Error", message: message, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                            exit(1)
                        }, cancelButtonTitle: "OK")
                        return
                    } else if (responseDict.value(forKeyPath: "message.code") as! String == "2310") {
                        DIMOAlertView.showNormalTitle("", message: message, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                            UIApplication.shared.openURL(NSURL(string: responseDict.value(forKeyPath: "AppURL.text") as! String)! as URL)
                             exit(1)
                        }, cancelButtonTitle: getString("AlertCloseButtonText"))
                    } else if (responseDict.value(forKeyPath: "message.code") as! String == "null"){
                        DIMOAlertView.showNormalTitle("Error", message: message, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                            exit(1)
                        }, cancelButtonTitle: "OK")
                    } else {
                        self.firstPage()
                    }
                    
                } else {
                    DIMOAlertView.showNormalTitle("Error", message: "Server error", alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                        exit(1)
                    }, cancelButtonTitle: "OK")
                }
            }
        })
    }
    
    //MARK: function selection viewcontroller
    func firstPage() {
        if state {
            let vc = LandingScreenViewController.initWithOwnNib()
            self.navigationController?.pushViewController(vc, animated: false)
            vc.animatedFadeIn()
        } else {
            let vc = EULAViewController.initWithOwnNib()
            self.navigationController?.pushViewController(vc, animated: false)
            vc.animatedFadeIn()
            
            
        }
    }
    
}
