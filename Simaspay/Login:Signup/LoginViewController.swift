//
//  ViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginFieldsView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activationButton: UIButton!
    @IBOutlet weak var mobilenumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var contactUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.cornerRadius = 5;
        loginButton.layer.masksToBounds = true;
        
        activationButton.layer.cornerRadius = 5;
        activationButton.layer.masksToBounds = true;

        
        SimaspayUtility.setMobileNumberTextFieldImage(mobilenumberField)
        SimaspayUtility.setMPINTextFieldImage(passwordField)
        
        SimaspayUtility.setSimasPayUIviewStyle(loginFieldsView)
        SimaspayUtility.simasPayUnderlineButtonTextLabel(contactUsButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide Viewcontroller Navigationcontroller
        //SimaspayUtility.clearNavigationBarcolor(self.navigationController!)
        //self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.navigationController?.navigationBarHidden = true

    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        
        self.dismissKeyboard()
        
        // SIMASPAY_REGULAR_BANK_CUSTOMER  OR SIMASPAY_AGENT_REGULAR
        
        /*let optionDict1 = ["title":"Transfer","image":"btn-transfer","":""]
        let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","":""]
        let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","":""]
        let optionDict4 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","":""]
        let optionDict5 = ["title":"Rekening","image":"btn-rekening","":""]
        let menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5]*/

        
        // SIMASPAY_LAKU_PANDAI
        
       /*
        let optionDict6 = ["title":"Rekening","image":"btn-rekening","":""]
        let menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6]
        */
        
        //SIMASPAY_AGENT_ACCOUNT
      /*  let optionDict1 = ["title":"Setor Tunai","image":"btn-setortunai","":""]
        let optionDict2 = ["title":"Buka Rekening","image":"btn-bukarekening","":""]
        let optionDict3 = ["title":"Tutup Rekening","image":"btn-tutuprekening","":""]
        let optionDict4 = ["title":"Transaksi","image":"ic-transaksi","":""]
        let optionDict5 = ["title":"Rekening","image":"btn-rekening","":""]
        let optionDict6 = ["title":"Referral","image":"btn-rekening","":""]
        
        let menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6]
        
        
        //Customer Login Flow
       
       let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        mainMenuViewController.menuViewArray = menuViewArray
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)
        
        */
        
        
        //Agent Login Flow
        
        let agentOptionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AgentOptionViewController") as! AgentOptionViewController
        self.navigationController!.pushViewController(agentOptionViewController, animated: true)
        
        
        
    }


}

