//
//  LoginRegisterViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/7/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginRegisterViewController: BaseViewController {

    static func initWithOwnNib() -> LoginRegisterViewController {
        let obj:LoginRegisterViewController = LoginRegisterViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
