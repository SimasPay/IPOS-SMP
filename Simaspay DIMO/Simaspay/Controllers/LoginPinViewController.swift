//
//  LoginPinViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/8/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginPinViewController: BaseViewController {

    
 
    @IBOutlet weak var tfMpin: BaseTextField!

    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var lblInfoNumber: BaseLabel!
    static func initWithOwnNib() -> LoginPinViewController {
        let obj:LoginPinViewController = LoginPinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()

        let phone = "08881234567"
        let infoString = String(format: String("Silakan masukkan mPIN untuk nomor HP %@"), phone)
        lblInfoNumber.text = infoString as String
        lblInfoNumber.textAlignment = .center
        lblInfoNumber.numberOfLines = 3
        
        let range = (infoString as NSString).range(of: phone)
        let attributedString = NSMutableAttributedString(string:infoString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)], range: range)
        self.lblInfoNumber.attributedText = attributedString
        
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.placeholder = "Pin"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTextField.updateViewRoundedWithShadow()

        
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
