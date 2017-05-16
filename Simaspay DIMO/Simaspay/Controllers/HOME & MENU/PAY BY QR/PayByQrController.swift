//
//  PayByQrController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/9/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

class PayByQrController: BaseViewController, UITextFieldDelegate {
    
    var dictOfData : NSDictionary!
    
    static func initWithOwnNib(isPurchased : Bool) -> PayByQrController {
        
        let obj:PayByQrController = PayByQrController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Pay by QR")
        self.showBackButton()
        DLog("\(self.dictOfData)")
    }
    @IBAction func actionOke(_ sender: Any) {
        
        DIMOPay.startSDK(self, with: self as! DIMOPayDelegate, invoiceId: "1234", andCallBackURL: "")
        
//        DIMOPay.notifyTransaction(PaymentStatusSuccess, withMessage: "Pembayaran berhasil", isDefaultLayout: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
    }
}

