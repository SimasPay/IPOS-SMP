//
//  LandingScreenViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/7/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LandingScreenViewController: BaseViewController {

    @IBOutlet weak var btnContactUs: BaseButton!
    @IBOutlet weak var btnActivation: BaseButton!
    @IBOutlet weak var btnLogin: BaseButton!
    
    static func initWithOwnNib() -> LandingScreenViewController {
        let obj:LandingScreenViewController = LandingScreenViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnContactUs.setTitle(getString("LoginButtonContactUs"), for: UIControlState())
        btnLogin.updateButtonType1()
        btnLogin.setTitle(getString("LandingScreenButtonLogin"), for: .normal)
        btnActivation.updateButtonType2()
        btnActivation.setTitle(getString("LandingScreenButtonActivation"), for: .normal)

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        btnContactUs.addUnderline()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionLogin(_ sender: AnyObject) {
        var message = ""
        if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }

        getPublicKey {
            let vc = LoginRegisterViewController.initWithOwnNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @IBAction func actionActivation(_ sender: AnyObject) {
        let vc = ActivationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    typealias CompletionBlock = () -> Void
    func getPublicKey(complete : @escaping () -> Void) {
        if (publicKeys == nil || publicKeys.allKeys.count == 0) {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let dict = NSMutableDictionary()
            dict[TXNNAME] = TXN_GETPUBLC_KEY
            dict[SERVICE] = SERVICE_ACCOUNT
            dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
            dict[SOURCE_APP_VERSION_KEY] = version
            dict[SOURCE_APP_OSVERSION_KEY] = "1"
            DMBProgressHUD.showAdded(to: self.view, animated: true)
            let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
            DIMOAPIManager.callAPI(withParameters: param, withSessionCheck: false, andComplete: { (dict, err) in
                DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
                if (err != nil) {
                    let error = err as! NSError
                    if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                        DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                    } else {
                        DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                    }
                    return
                }
                
                let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
                DLog("\(responseDict)")
                if (responseDict.allKeys.count == 0) {
                    DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    // success
                    if (responseDict.allKeys.count > 0) {
                        // set public keys
                        publicKeys = responseDict;
                        if (responseDict.value(forKeyPath: "message.code") as! String == "546") {
                            DIMOAlertView.showNormalTitle("Error", message: "message", alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                                exit(1)
                                }, cancelButtonTitle: "OK")
                            return
                        }
                        
                        DLog("\(publicKeys)")
                    }
                    complete()
                }
            })
        } else {
            complete()
        }
    }
}
