//
//  LoginRegisterViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/7/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class LoginRegisterViewController: BaseViewController, UITextFieldDelegate {


    @IBOutlet weak var btnActivationAccount: BaseButton!
    @IBOutlet weak var tfHPNumber: BaseTextField!
    @IBOutlet weak var lblEntryHPNumber: UILabel!
    @IBOutlet weak var viewTextField: UIView!
    static func initWithOwnNib() -> LoginRegisterViewController {
        let obj:LoginRegisterViewController = LoginRegisterViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()

        lblEntryHPNumber.font = UIFont.systemFont(ofSize: 18)
        lblEntryHPNumber.textColor = UIColor.init(hexString: color_text_default)
        lblEntryHPNumber.textAlignment = .center
        lblEntryHPNumber.numberOfLines = 2
        lblEntryHPNumber.text  = "Silakan masukkan Nomor Handphone Anda"
        tfHPNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHPNumber.placeholder = "No. Handphone"
        btnActivationAccount.setTitle("Aktivasi Akun", for: .normal)
        btnActivationAccount.setTitleColor(UIColor.init(hexString: color_text_default), for: .normal)
        btnActivationAccount.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        tfHPNumber.delegate =  self
    }
    override func btnDoneAction() {
        let vc = RegisterEMoneyViewController.initWithOwnNib()
        navigationController?.pushViewController(vc, animated: false)
        return
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tfHPNumber.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTextField.updateViewRoundedWithShadow()
        btnActivationAccount.addUnderline()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        BaseViewController.lastObjectForKeyboardDetector = self.btnActivationAccount
        updateUIWhenKeyboardShow()
        return true
    }


   
}
