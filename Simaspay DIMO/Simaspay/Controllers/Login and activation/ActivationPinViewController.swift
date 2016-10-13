//
//  ActivationPinViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationPinViewController: BaseViewController {
    
    @IBOutlet var lblInfoUser: BaseLabel!
    
    @IBOutlet var tfMpin: BaseTextField!
    @IBOutlet var tfConfirmMpin: BaseTextField!
    
    @IBOutlet var viewTextField: UIView!
    @IBOutlet var btnSaveMpin: BaseButton!
    
    static func initWithOwnNib() -> ActivationPinViewController {
        let obj:ActivationPinViewController = ActivationPinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = "Bayu !"
        let infoString = String(format: String("ActivationLabelInfoInputMpin"), name)
        lblInfoUser.text = infoString as String
        lblInfoUser.textAlignment = .center
        lblInfoUser.numberOfLines = 3
        
        let range = (infoString as NSString).range(of: name)
        let attributedString = NSMutableAttributedString(string:infoString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)], range: range)
        self.lblInfoUser.attributedText = attributedString
        
        
        viewTextField.backgroundColor = UIColor.white
        viewTextField.updateViewRoundedWithShadow()
        tfMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfMpin.placeholder = getString("ActivationPlaceholderMpin")
        tfMpin.addUnderline()
        tfConfirmMpin.updateTextFieldWithImageNamed("icon_Mpin")
        tfConfirmMpin.placeholder = getString("ActivationPlaceholderConfirmMpin")
        
        btnSaveMpin.updateButtonType1()
        btnSaveMpin.setTitle(getString("ActivationButtonSaveMpin"), for: UIControlState())
        btnSaveMpin.addTarget(self, action: #selector(EULAViewController.buttonClick) , for: .touchUpInside)

        BaseViewController.lastObjectForKeyboardDetector = self.btnSaveMpin
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tfMpin.addUnderline()
    }


    func buttonClick()  {
        let vc = ActivationSuccessViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
