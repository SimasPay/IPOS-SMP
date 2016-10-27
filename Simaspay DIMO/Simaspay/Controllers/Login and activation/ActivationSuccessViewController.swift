//
//  ActivationSuccessViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationSuccessViewController: BaseViewController {

    @IBOutlet var btnOK: BaseButton!
    @IBOutlet var lblInfoSuccess: BaseLabel!
    
    static func initWithOwnNib() -> ActivationSuccessViewController {
        let obj:ActivationSuccessViewController = ActivationSuccessViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoString = getString("ActivationLabelInfoSuccess")
        lblInfoSuccess.text = infoString as String
        lblInfoSuccess.textAlignment = .center
        lblInfoSuccess.numberOfLines = 4
        
        let range = (infoString as NSString).range(of: "Aktivasi Berhasil!")
        let attributedString = NSMutableAttributedString(string:infoString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)], range: range)
        self.lblInfoSuccess.attributedText = attributedString
        
        btnOK.updateButtonType1()
        btnOK.setTitle(getString("ActivationButtonOk"), for: UIControlState())
//        btnOK.addTarget(self, action: #selector(ActivationSuccessViewController.buttonTransfer) , for: .touchUpInside)
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
    



}
