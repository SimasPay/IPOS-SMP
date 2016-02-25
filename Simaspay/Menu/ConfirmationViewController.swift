//
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit



class ConfirmationViewController: UIViewController
{
    
    var confirmationScrollview: UIScrollView!
    var simasPayOptionType:SimasPayOptionType!
    var confirmationTitlesArray: Array<AnyObject>!
    var confirmationValuesArray: Array<AnyObject>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Konfirmasi"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
    
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        confirmationScrollview = UIScrollView()
        confirmationScrollview.backgroundColor = UIColor.clearColor()
        confirmationScrollview.translatesAutoresizingMaskIntoConstraints=false
        confirmationScrollview.scrollEnabled = true
        self.view.addSubview(confirmationScrollview)
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["confirmationScrollview"] = confirmationScrollview

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[confirmationScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[confirmationScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        
        let confirmationView = UIView()
        confirmationView.backgroundColor = UIColor.whiteColor()
        confirmationView.translatesAutoresizingMaskIntoConstraints=false
        confirmationView.layer.cornerRadius = 5
        initialScrollViews["confirmationView"] = confirmationView
        confirmationScrollview.addSubview(confirmationView)
        
        
        //SimaspayUtility.setSimasPayUIviewStyle(confirmationView)
        let buttonMargin = (self.view.frame.size.width-200)/2
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Benar", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmationScrollview.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: "senfOTPClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        
        let cancelButton:UIButton = UIButton()
        cancelButton.backgroundColor = UIColor(netHex:0xDBDBDB)
        cancelButton.setTitle("Salah", forState: UIControlState.Normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.titleLabel?.font = UIFont(name:"HelveticaNeue", size:20)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        confirmationScrollview.addSubview(cancelButton)
        cancelButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["cancelButton"] = cancelButton
        cancelButton.layer.cornerRadius = 5
        
        let width = self.view.frame.width-40
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[confirmationView(\(width))]-20-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
        
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step1FormAcceptBtn]-(\(buttonMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[cancelButton]-(\(buttonMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[confirmationView]-20-[step1FormAcceptBtn(50)]-\(15)-[cancelButton(50)]-\(30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let topMargin = 15
        let leftRightMargin = 20
        
        
        
        
        let titleLabel = UILabel()
        titleLabel.text = "Pastikan data berikut sudah benar"
        titleLabel.font = UIFont(name:"HelveticaNeue", size:13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.Center
        confirmationView.addSubview(titleLabel)
        initialScrollViews["titleLabel"] = titleLabel
        
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[titleLabel]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        
        var vertical_constraints = "V:|-\(topMargin)-[titleLabel(21)]-20-"
        
        for i in 1...confirmationTitlesArray.count {
            
            let confirmationTitleLabel = UILabel()
            confirmationTitleLabel.text = "\(confirmationTitlesArray[i-1])"
            confirmationTitleLabel.font = UIFont(name:"Helvetica", size:12.5)
            confirmationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmationView.addSubview(confirmationTitleLabel)
            initialScrollViews["confirmationTitleLabel\(i)"] = confirmationTitleLabel
            
            let confirmationValueLabel = UILabel()
            confirmationValueLabel.text = "\(confirmationValuesArray[i-1])"
            confirmationValueLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
            confirmationValueLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmationView.addSubview(confirmationValueLabel)
            initialScrollViews["confirmationValueLabel\(i)"] = confirmationValueLabel
            
            vertical_constraints  += "[confirmationTitleLabel\(i)(21)][confirmationValueLabel\(i)(21)]-10-"
            
            if( i == confirmationTitlesArray.count-1 &&  self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN)
            {
                let dottedLineView = SimasPayDottedLine()
                dottedLineView.translatesAutoresizingMaskIntoConstraints = false
                confirmationView.addSubview(dottedLineView)
                initialScrollViews["dottedLineView"] = dottedLineView
                
                confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[dottedLineView]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
                
                vertical_constraints  += "[dottedLineView(2)]-10-"
            }
            
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[confirmationTitleLabel\(i)]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
            
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[confirmationValueLabel\(i)]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
        }
        
        vertical_constraints += "|"
        
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))

    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().barTintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        UINavigationBar.appearance().tintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        self.navigationController?.navigationBarHidden = false
        
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 15, 25)
        backButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "btn-back"), forState: UIControlState.Normal)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
        
    }


    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    
    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        
        textField.placeholder = "6 digit kode OTP"
        tField = textField
    }
    
    
    @available(iOS 8.0, *)
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    
    
    @IBAction func senfOTPClicked(sender: AnyObject) {
        
        
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_SETOR_TUNAI || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TUTUP_REKENING || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REFERRAL || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_AGENT_REGISTRATION)
        {
            self.gotoStausViewController()
        }else{
            
            
            let alertTitle = "Masukkan Kode OTP"
            let message = "Kode OTP dan link telah dikirimkan ke \n nomor 08881234567. Masukkan kode \n tersebut atau akses link yang tersedia."
            
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
                alertController.addTextFieldWithConfigurationHandler(configurationTextField)
                alertController.addAction(UIAlertAction(title: "Batal", style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                    print("Done !!")
                    print("Item : \(self.tField.text)")
                    self.gotoStausViewController()
                }))
                self.presentViewController(alertController, animated: true, completion: {
                    print("completion block")
                })
                
            } else {
                // Fallback on earlier versions
                let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = message
                alert.addButtonWithTitle("OK")
                alert.addButtonWithTitle("Batal")
                alert.show()
            };
            
        }
        
    }
    
    
    func gotoStausViewController()
    {
        //var confirmationTitlesArray : [NSString] = NSArray() as! [NSString]
        //var confirmationValuesArray : [NSString] = NSArray() as! [NSString]
        
        let confirmationViewController = StatusViewController()
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_SETOR_TUNAI)
        {
            
            confirmationViewController.statusTitle = "Setor Tunai Berhasil"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TUTUP_REKENING)
        {
            confirmationViewController.statusTitle = "Rekening Berhasil Ditutup"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REFERRAL)
        {
            
            confirmationViewController.statusTitle = "Referral Berhasil"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_REFERRAL)
        {
    
            confirmationViewController.statusTitle = "Referral Berhasil"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_AGENT_REGISTRATION)
        {
            confirmationViewController.statusTitle = "Data Terkirim!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TARIK_TUNAI)
        {
            
            confirmationViewController.statusTitle = "Tarik Tunai Berhasil"
        }
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            
            confirmationViewController.statusTitle = "Pembayaran Berhasil!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN)
        {
            
            confirmationViewController.statusTitle = "Pembelian Berhasil!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANKSINARMAS)
        {
            
            confirmationViewController.statusTitle = "Transfer Berhasil!"
        }
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN)
        {
            confirmationViewController.confirmationTitlesArray = ["Nama Pemilik Rekening","Bank Tujuan","Nomor Rekening Tujuan","Jumlah"]
            confirmationViewController.confirmationValuesArray = ["ANDI GUNAWAN","Bank Sinarmas","1122334455","Rp 2.500.000"]
        
        }else{
            
            confirmationViewController.confirmationTitlesArray = self.confirmationTitlesArray
            confirmationViewController.confirmationValuesArray = self.confirmationValuesArray
        }
        
        confirmationViewController.simasPayOptionType = self.simasPayOptionType
        confirmationViewController.confirmationValuesArray = self.confirmationValuesArray
        self.navigationController!.pushViewController(confirmationViewController, animated: true)
    }
}