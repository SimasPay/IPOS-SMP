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
    var MDNString:String!
    
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
        tfHPNumber.text = MDNString
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
        if textField == self.tfUsername{
            BaseViewController.lastObjectForKeyboardDetector = self.tfUsername
        } else if textField == self.tfEmail{
            BaseViewController.lastObjectForKeyboardDetector = self.tfEmail
        } else if textField == self.tfHPNumber{
            BaseViewController.lastObjectForKeyboardDetector = self.tfConfirmMpin
        } else if textField == self.tfMpin{
            BaseViewController.lastObjectForKeyboardDetector = self.viewTextField
        } else if textField == self.tfConfirmMpin{
            BaseViewController.lastObjectForKeyboardDetector = self.viewTextField
        }
        updateUIWhenKeyboardShow()
        return true
    }
    @IBAction func actionNextButton(_ sender: AnyObject) {
        var message = "";
        if (!tfUsername.isValid()) {
            message = "Masukkan username Anda"
        } else if (self.isValidEmail(testStr: tfEmail.text!) == false) {
            message = "Email Anda tidak valid"
        } else if (tfMpin.length() < 6) {
            message = "Pin harus 6 digit"
        } else if !((tfConfirmMpin.text?.isEqual(tfMpin.text))!) {
            message = "Pin harus sama"
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }

        return
        let vc = SecurityQuestionViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
