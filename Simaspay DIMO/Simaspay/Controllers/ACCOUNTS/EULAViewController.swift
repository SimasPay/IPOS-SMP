//
//  EULAViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class EULAViewController: BaseViewController,UIWebViewDelegate {

    
    @IBOutlet var labelTitle: BaseLabel!
    @IBOutlet var btnDisagree: BaseButton!
    @IBOutlet var btnAgree: BaseButton!
    @IBOutlet var viewFrame: UIView!
    @IBOutlet var webView: UIWebView!
    let padding:CGFloat = 12.0
    static func initWithOwnNib() -> EULAViewController {
        let obj:EULAViewController = EULAViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = "Syarat dan Ketentuan"
        lblTitle.font = UIFont.boldSystemFont(ofSize: 19)
        
        btnAgree.updateButtonType1()
        btnAgree.setTitle(getString("EulaButtonAgree"), for: UIControlState())
        btnDisagree.updateButtonType3()
        btnDisagree.setTitle(getString("EulaButtonDisagree"), for: UIControlState())
        
        
        viewFrame.backgroundColor = UIColor.white
        viewFrame.updateViewRoundedWithShadow()
        
        btnAgree.addTarget(self, action: #selector(EULAViewController.buttonClick) , for: .touchUpInside)
        loadAddressURL()
        
        
    }
    func loadAddressURL(){
        let requesturl = NSURL(string: TERMS_CONDITIONS)
        let request = NSURLRequest(url: requesturl! as URL)
        webView.delegate =  self
        webView.loadRequest(request as URLRequest)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @available(iOS 2.0, *)
    public func webViewDidStartLoad(_ webView: UIWebView){
        DMBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    @available(iOS 2.0, *)
    public func webViewDidFinishLoad(_ webView: UIWebView){
        DMBProgressHUD.hide(for: self.view, animated: true)
    }
    
    //MARK: Action button to landing page
    func buttonClick()  {
        let vc = LandingScreenViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "eulaState")
        defaults.synchronize()
    }

    //MARK: exit app if select disagree button
    @IBAction func actionDisagree(_ sender: AnyObject) {
      exit(0)
    }
  


}
