//
//  TransferBankViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/3/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class TransferBankViewController: BaseViewController {
    @IBOutlet var lblBankName: BaseLabel!
    @IBOutlet var lblAccountNumber: BaseLabel!
    @IBOutlet var lblAmount: BaseLabel!
    @IBOutlet var lblMPin: BaseLabel!
    @IBOutlet var viewBackground: UIView!
   
    @IBOutlet var constraintCenterYView: NSLayoutConstraint!
    
    @IBOutlet var btnNext: BaseButton!
    
    
    static func initWithOwnNib() -> TransferBankViewController {
        let obj:TransferBankViewController = TransferBankViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("Transfer"))
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        
        self.lblBankName.font = UIFont .boldSystemFont(ofSize: 13)
        self.lblBankName.text = getString("TransferLebelBankName")
        
        self.lblAccountNumber.font = self.lblBankName.font
        self.lblAccountNumber.text = getString("TransferLebelAccountNumber")
        
        self.lblAmount.font = self.lblBankName.font
        self.lblAmount.text = getString("TransferLebelAmount")
        
        self.lblMPin.font = self.lblBankName.font
        self.lblMPin.text = getString("TransferLebelMPIN")
        
        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        btnNext.addTarget(self, action: #selector(TransferBankViewController.buttonConfirmation) , for: .touchUpInside)
        
        if UIScreen.main.bounds.height == 480{
            self.constraintCenterYView.constant = -160;
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonConfirmation()  {
        let vc = ConfirmationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
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
