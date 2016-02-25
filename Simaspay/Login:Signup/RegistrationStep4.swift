//
//  RegistrationStep4.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 28/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep4: UIViewController{
    

    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        okButton.layer.cornerRadius = 5;
        okButton.layer.masksToBounds = true;
        
        
    }
    @IBAction func okButtonClicked(sender: AnyObject) {
        
       /* var menuViewArray = []
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        
        let optionDict1 = ["title":"Transfer","image":"btn-transfer","SimasPayMainMenuOptionType":"SIMASPAY_TRANSFER"]
        let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","SimasPayMainMenuOptionType":"SIMASPAY_PEMBELIAN"]
        let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","SimasPayMainMenuOptionType":"SIMASPAY_PEMBAYARAN"]
        let optionDict4 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","SimasPayMainMenuOptionType":"SIMASPAY_BAYAR_PAKAI_QR"]
        let optionDict5 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
        
        menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5]
        mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_REGULAR_BANK_CUSTOMER
        
        mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)*/
        
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
}
