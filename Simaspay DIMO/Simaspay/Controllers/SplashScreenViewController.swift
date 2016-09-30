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
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(SplashScreenViewController.firstPage), userInfo: nil, repeats: false)
    }
    
    func firstPage() {
        let vc = LoginViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        vc.animatedFadeIn()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
