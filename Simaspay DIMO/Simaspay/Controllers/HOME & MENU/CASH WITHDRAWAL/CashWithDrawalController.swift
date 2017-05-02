//
//  CashWithDrawalController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/1/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

//MARK: Transfer type
enum WithDrawalType : Int {
    case WithDrawalTypeMe
    case WithDrawalTypeOther
}

class CashWithDrawalController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var lblFirstTitleTf: BaseLabel!
    @IBOutlet var lblSecondTitleTf: BaseLabel!
    @IBOutlet var lblMPin: BaseLabel!
    
    @IBOutlet var tfNoAccount: BaseTextField!
    @IBOutlet var tfAmountTransfer: BaseTextField!
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var viewBackground: UIView!
    
    var withDrawalType : WithDrawalType!
    
    @IBOutlet var btnNext: BaseButton!
    
    @IBOutlet var constraintViewAcount: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintScrollViewHeight: NSLayoutConstraint!
    static var scrollViewHeight : CGFloat = 0
    
    
    static func initWithOwnNib(type : WithDrawalType) -> CashWithDrawalController {
        let obj:CashWithDrawalController = CashWithDrawalController.init(nibName: String(describing: self), bundle: nil)
        obj.withDrawalType = type
        return obj
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        
        self.lblFirstTitleTf.font = UIFont .boldSystemFont(ofSize: 13)
        self.lblFirstTitleTf.text = getString("TransferLebelMdn")
        
        self.lblSecondTitleTf.font = self.lblFirstTitleTf.font
        self.lblSecondTitleTf.text = getString("TransferLebelAmount")
        
        self.lblMPin.font = self.lblFirstTitleTf.font
        self.lblMPin.text = getString("TransferLebelMPIN")
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        btnNext.addTarget(self, action: #selector(self.actionNext) , for: .touchUpInside)
        
        self.tfNoAccount.font = UIFont.systemFont(ofSize: 14)
        self.tfNoAccount.addInset()
        self.tfNoAccount.delegate = self
        
        self.tfAmountTransfer.font = UIFont.systemFont(ofSize: 14)
        self.tfAmountTransfer.placeholder = "RP"
        self.tfAmountTransfer.addInset()
        
        self.tfMpin.font = UIFont.systemFont(ofSize: 14)
        self.tfMpin.addInset()
        self.tfMpin.delegate = self
        
        if (self.withDrawalType != WithDrawalType.WithDrawalTypeMe) {
            constraintViewAcount.constant = 0
            self.showTitle(getString("WithDrawalMe"))
        } else {
            self.showTitle(getString("WithDrawalOther"))
        }
        
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 3 {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return true
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionNext() {
        var message = "";
        if (!tfNoAccount.isValid()) {
            message = "Masukan " + getString("TransferLebelMdn")
        } else if (!tfAmountTransfer.isValid()){
            message = "Masukan " + getString("TransferLebelAmount")
        } else if (!tfMpin.isValid()){
            message = "Masukan " + getString("TransferLebelMPIN")
        } else if (tfMpin.length() < 6) {
            message = "PIN harus 6 digit "
        } else if (!DIMOAPIManager.isInternetConnectionExist()) {
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        nextProces()
    }
    
    //MARK: function comfirmation
    func nextProces()  {
        
    }
    
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        TransferBankViewController.scrollViewHeight = constraintScrollViewHeight.constant
        constraintScrollViewHeight.constant = TransferBankViewController.scrollViewHeight - BaseViewController.keyboardSize.height
        self.view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        constraintScrollViewHeight.constant = TransferBankViewController.scrollViewHeight
        self.view.layoutIfNeeded()
    }
    
    
}
