//
//  RegistrationStep3.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 28/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep3: UIViewController{
    
    @IBOutlet weak var pinFieldsView: UIView!
    @IBOutlet weak var mPINTextField: UITextField!
    @IBOutlet weak var confirmasimPINTextField: UITextField!
    @IBOutlet weak var subTitleTextLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SimaspayUtility.setMPINTextFieldImage(mPINTextField)
        SimaspayUtility.setMPINTextFieldImage(confirmasimPINTextField)
        
        SimaspayUtility.setSimasPayUIviewStyle(pinFieldsView)
        
        okButton.layer.cornerRadius = 5;
        okButton.layer.masksToBounds = true;
        
        let string = subTitleTextLabel.text! as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        // 2  [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
        let firstAttributes = [NSForegroundColorAttributeName: UIColor(netHex:0x494949),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16.0)!]
        // 3
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString("Bayu Santoso"))
        // 4
        subTitleTextLabel.attributedText = attributedString
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
    }
}