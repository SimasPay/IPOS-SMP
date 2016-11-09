//
//  RegisterEMoneyViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/9/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class RegisterEMoneyViewController: BaseViewController, UITextFieldDelegate {

    
    @IBOutlet weak var tfConfirmMpin: BaseTextField!
    @IBOutlet weak var tfMpin: BaseTextField!
    @IBOutlet weak var tfHPNumber: BaseTextField!
    @IBOutlet weak var tfEmail: BaseTextField!
    @IBOutlet weak var tfUsername: BaseTextField!
    @IBOutlet weak var btnNext: BaseButton!
    @IBOutlet weak var viewTextField: UIView!
    static func initWithOwnNib() -> RegisterEMoneyViewController {
        let obj:RegisterEMoneyViewController = RegisterEMoneyViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showBackButton()
        self.showTitle("Pendaftaran Akun E-money")
        btnNext.updateButtonType1()
        btnNext.setTitle("Lanjut", for: .normal)
        
        tfUsername.updateTextFieldWithImageNamed("icon_username")
        tfUsername.placeholder = "Nama Lengkap"
        tfUsername.delegate = self
        
        tfEmail.updateTextFieldWithImageNamed("icon_email")
        tfEmail.placeholder = "E-mail (bila ada)"
        tfEmail.delegate = self
        
        tfHPNumber.updateTextFieldWithImageNamed("icon_Mobile")
        tfHPNumber.placeholder = "08881234567"
        tfHPNumber.delegate = self
        
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.placeholder = "mPIN"
        tfMpin.delegate = self
        
        tfConfirmMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfConfirmMpin.placeholder = "Konfirmasi mPIN"
        tfConfirmMpin.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTextField.updateViewRoundedWithShadow()
        tfUsername.addUnderline()
        tfEmail.addUnderline()
        tfHPNumber.addUnderline()
        tfMpin.addUnderline()
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfUsername{
            BaseViewController.lastObjectForKeyboardDetector = self.tfUsername.superview
        }else if textField == tfEmail{
            BaseViewController.lastObjectForKeyboardDetector = self.tfEmail.superview
        } else if textField == tfHPNumber{
            BaseViewController.lastObjectForKeyboardDetector = self.tfHPNumber.superview
        } else if textField == tfMpin{
            BaseViewController.lastObjectForKeyboardDetector = self.tfMpin.superview
        } else {
            BaseViewController.lastObjectForKeyboardDetector = self.btnNext
        }
        updateUIWhenKeyboardShow()
        return true
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
