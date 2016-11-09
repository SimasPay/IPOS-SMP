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
        let vc = LoginRegisterViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func actionActivation(_ sender: AnyObject) {
        let vc = ActivationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
