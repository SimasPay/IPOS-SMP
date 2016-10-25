//
//  DetailPaymentPurchaseViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/20/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class DetailPaymentPurchaseViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  

    
    var isPurchase = false
    @IBOutlet var constraintHightNoTransaction: NSLayoutConstraint!
    
    @IBOutlet var tfNomTransaction: BaseTextField!
    @IBOutlet var tfNoAccount: BaseTextField!
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var btnNext: BaseButton!

    @IBOutlet var lblNomTransaction: BaseLabel!
    @IBOutlet var lblMpin: BaseLabel!
    @IBOutlet var lblNoAccount: BaseLabel!
    @IBOutlet var lblNameProduct: BaseTextField!
    @IBOutlet var lblTitleNameProduct: BaseLabel!
    static func initWithOwnNib(isPurchased : Bool) -> DetailPaymentPurchaseViewController {
       
        let obj:DetailPaymentPurchaseViewController = DetailPaymentPurchaseViewController.init(nibName: String(describing: self), bundle: nil)
         obj.isPurchase = isPurchased
        return obj
    }

    var pickOption = ["one", "two", "three", "seven", "fifteen"]
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintScrollViewHeight: NSLayoutConstraint!
    static var scrollViewHeight : CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(self.isPurchase ? "Pembelian" : "Pembayaran")
        self.showBackButton()
        lblTitleNameProduct.text = "Nama Produk"
        lblTitleNameProduct.font = UIFont.boldSystemFont(ofSize: 13)
        lblNameProduct.text = "Isi Ulang Pulsa - Smartfren"
        lblNameProduct.isUserInteractionEnabled = true
        lblNameProduct.isEnabled = false
        lblNameProduct.font = UIFont.systemFont(ofSize: 14)
        lblNameProduct.addInset()
        
        lblNomTransaction.font = lblTitleNameProduct.font
        lblNomTransaction.text = "Nominal Pulsa"
        lblNoAccount.font = lblTitleNameProduct.font
        lblNoAccount.text = "Nomor Handphone"
        lblMpin.font = lblTitleNameProduct.font
        lblMpin.text = "mPIN"
        
        tfNomTransaction.addInset()
        tfNoAccount.addInset()
        tfMpin.addInset()
        
        tfNomTransaction.rightViewMode =  UITextFieldViewMode.always
        tfNomTransaction.updateTextFieldWithRightImageNamed("icon_arrow_down")

        
        btnNext.updateButtonType1()
        btnNext.setTitle("Lanjut", for: .normal)
    
        
        if !self.isPurchase {
            constraintHightNoTransaction.constant = 0
        }
       

        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        self.tfNomTransaction.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
         return pickOption.count
    }

    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickOption[row]
    }
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.tfNomTransaction.text = pickOption[row]
    }
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        if (DetailPaymentPurchaseViewController.scrollViewHeight == 0) {
            DetailPaymentPurchaseViewController.scrollViewHeight = constraintScrollViewHeight.constant
            constraintScrollViewHeight.constant = DetailPaymentPurchaseViewController.scrollViewHeight - BaseViewController.keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        constraintScrollViewHeight.constant = DetailPaymentPurchaseViewController.scrollViewHeight
        DetailPaymentPurchaseViewController.scrollViewHeight = 0
        self.view.layoutIfNeeded()
    }
    
    
}


    
