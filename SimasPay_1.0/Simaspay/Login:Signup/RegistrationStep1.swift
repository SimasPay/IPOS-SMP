//
//  RegistrationStep1.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 17/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep1: UIViewController,UIWebViewDelegate {
    

    @IBOutlet weak var step1TitleLabel: UILabel!
    
    @IBOutlet weak var goBackLoginBtn: UIButton!
    @IBOutlet weak var termsAcceptBtn: UIButton!
    @IBOutlet weak var customBackgroundView: UIWebView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        customBackgroundView.layer.cornerRadius = 5;
        customBackgroundView.layer.masksToBounds = true;
        
        termsAcceptBtn.layer.cornerRadius = 5;
        termsAcceptBtn.layer.masksToBounds = true;
        
        goBackLoginBtn.layer.cornerRadius = 5;
        goBackLoginBtn.layer.masksToBounds = true;
        
        // Hide Viewcontroller Navigationcontroller
        self.navigationController?.navigationBarHidden = true
        
        customBackgroundView.delegate = self
        let url = NSURL (string: TERMS_CONDITIONS);
        let requestObj = NSURLRequest(URL: url!);
        customBackgroundView.loadRequest(requestObj);
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
    }
    
    
    
    @IBAction func backToLoginAction(sender: AnyObject) {
        
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
     
        EZLoadingActivity.hide()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        EZLoadingActivity.hide()
        
        SimasPayAlert.showSimasPayAlert(error!.localizedDescription,viewController:self)
    }
}