//
//  TransferBankViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/3/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit
enum TransferType : Int {
    case TransferTypeSinarmas
    case TransferTypeOtherBank
    case TransferTypeUangku
    case TransferTypeLakuPandai
    case TransferTypeOther
}

class TransferBankViewController: BaseViewController {
    @IBOutlet var lblBankName: BaseLabel!
    @IBOutlet var lblFirstTitleTf: BaseLabel!
    @IBOutlet var lblSecondTitleTf: BaseLabel!
    @IBOutlet var lblMPin: BaseLabel!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var tfBankName: BaseTextField!
    @IBOutlet var tfNoAccount: BaseTextField!
    @IBOutlet var tfAmountTransfer: BaseTextField!
    @IBOutlet var tfMpin: BaseTextField!
    
    
    var transferType : TransferType!
    var bankName : NSDictionary!
    
    @IBOutlet var btnNext: BaseButton!
    
    @IBOutlet var constraintViewBankName: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintScrollViewHeight: NSLayoutConstraint!
    static var scrollViewHeight : CGFloat = 0
    
    
    static func initWithOwnNib(type : TransferType) -> TransferBankViewController {
        let obj:TransferBankViewController = TransferBankViewController.init(nibName: String(describing: self), bundle: nil)
        obj.transferType = type
        return obj
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("Transfer"))
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        
        self.lblBankName.font = UIFont .boldSystemFont(ofSize: 13)
        self.lblBankName.text = getString("TransferLebelBankName")
        
        
        self.lblFirstTitleTf.font = self.lblBankName.font
        self.lblFirstTitleTf.text = getString("TransferLebelAccountNumber")
        
        self.lblSecondTitleTf.font = self.lblBankName.font
        self.lblSecondTitleTf.text = getString("TransferLebelAmount")
        
        self.lblMPin.font = self.lblBankName.font
        self.lblMPin.text = getString("TransferLebelMPIN")
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        btnNext.addTarget(self, action: #selector(TransferBankViewController.buttonConfirmation) , for: .touchUpInside)
        
        self.tfBankName.font = UIFont.systemFont(ofSize: 14)
        self.tfBankName.isUserInteractionEnabled = true
        self.tfBankName.isEnabled = false
        self.tfBankName.addInset()
        
        self.tfNoAccount.font = UIFont.systemFont(ofSize: 14)
        self.tfNoAccount.addInset()
        
        self.tfAmountTransfer.font = UIFont.systemFont(ofSize: 14)
        self.tfAmountTransfer.placeholder = "RP"
        self.tfAmountTransfer.addInset()
        
        self.tfMpin.font = UIFont.systemFont(ofSize: 14)
        self.tfMpin.addInset()
        
        if (self.transferType != TransferType.TransferTypeOtherBank) {
            constraintViewBankName.constant = 0
        } else {
            self.tfBankName.text = bankName.value(forKey: "name") as? String
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonConfirmation()  {
        
        let vc = ConfirmationViewController.initWithOwnNib()
        let data: [String : Any]!
        
        if (self.transferType == TransferType.TransferTypeSinarmas) {
            data = [
                "title" : "Pastikan data berikut sudah benar",
                "content" : [
                    ["Nama Pemilik Rekening" : "BAYU SANTOSO"],
                    ["Bank Tujuan" : "Bank Sinarmas"],
                    ["Nomor Rekening Tujuan" : "1122334455"],
                    ["Jumlah" : "Rp 2.500.000"],
                ]
            ]
            vc.data = data as NSDictionary!
        } else if (self.transferType == TransferType.TransferTypeOtherBank){
           let bankNameString = bankName.value(forKey: "name") as! String
            data = [
                "title" : "Pastikan data berikut sudah benar",
                "content" : [
                    ["Nama Pemilik Rekening" : "BAYU SANTOSO"],
                    ["Bank Tujuan" : bankNameString],
                    ["Nomor Rekening Tujuan" : "06001234567"],
                    ["Jumlah" : "Rp 2.500.000"],
                    ["Biaya Transfer" : "Rp 7.500"],
                ],
                "footer" :[
                    "Total Pendebitan" : "Rp 2.507.500"]

            ]
            vc.data = data as NSDictionary!
            
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
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
