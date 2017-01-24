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
        
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(SplashScreenViewController.firstPage), userInfo: nil, repeats: false)
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
