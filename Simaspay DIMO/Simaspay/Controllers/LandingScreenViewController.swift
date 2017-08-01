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
    
    
    //MARK: Action button
    @IBAction func actionLogin(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let MDNString = defaults.string(forKey: SOURCEMDN)
        if MDNString == nil {
            let vc = LoginRegisterViewController.initWithOwnNib()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = LoginPinViewController.initWithOwnNib()
            vc.MDNString = MDNString
            self.navigationController?.pushViewController(vc, animated: false)
        }

    }

    @IBAction func actionActivation(_ sender: AnyObject) {
        let vc = ActivationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionContactUS(_ sender: Any) {
        var data = [String: String]()
        data["mobilenumber_1"] = "1500153"
        data["mobilenumber_2"] = "(021)50188888"
        data["emailid"] = "care@banksinarmas.com"
        data["website"] = "www.banksinarmas.com"
        let vc = ContactUSViewController.initWithOwnNib()
        vc.contactUsInfo = data as NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
