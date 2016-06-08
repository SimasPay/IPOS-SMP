//
//  AgentOptionViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 04/01/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class AgentOptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate
{
    @IBOutlet weak var logOutButton: UIButton!
    
    
    @IBOutlet weak var agentOptionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        agentOptionTableView.layer.borderWidth = 1.0
        agentOptionTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        agentOptionTableView.layer.cornerRadius = 5
        
        
    }
    
    
    // MARK: UITableViewDelegate UITableViewDataSource Method
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return 64
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "agentOptionCell")
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        cell.accessoryType = .DisclosureIndicator
        
        cell.textLabel!.font = UIFont(name:"Helvetica Neue", size:15)
        cell.textLabel!.textColor = UIColor.darkTextColor()
        cell.detailTextLabel!.textColor = UIColor.grayColor()
        
        
        
        if indexPath.row == 0
        {
            let loginData = SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_LOGIN_DATA) as! NSDictionary
            let bankAccountText  = loginData.valueForKeyPath("response.bankAccountNumber.text") as! String
            
            cell.textLabel!.text = "Akun Bank"
            cell.detailTextLabel!.text = bankAccountText
        }
        
        if indexPath.row == 1
        {
            cell.textLabel!.text = "Akun Agent"
            cell.detailTextLabel!.text = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN) as? String
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == 0
        { 
            
            self.showRegularCustomerFlow()
            
            SimasPayPlistUtility.saveDataToPlist("2", key: SOURCEPOCKETCODE)
            SimasPayPlistUtility.saveDataToPlist("2", key: DESTPOCKETCODE)
        }

        if indexPath.row == 1
        {
            SimasPayPlistUtility.saveDataToPlist("1", key: SOURCEPOCKETCODE)
            SimasPayPlistUtility.saveDataToPlist("2", key: DESTPOCKETCODE)
            
            
            let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
            let optionDict1 = ["title":"Setor Tunai","image":"btn-setortunai","SimasPayMainMenuOptionType":"SIMASPAY_SETOR_TUNAI"]
            let optionDict2 = ["title":"Buka Rekening","image":"btn-bukarekening","SimasPayMainMenuOptionType":"SIMASPAY_BUKA_REKENING"]
            let optionDict3 = ["title":"Tutup Rekening","image":"btn-tutuprekening","SimasPayMainMenuOptionType":"SIMASPAY_TUTUP_REKENING"]
            let optionDict4 = ["title":"Transaksi","image":"ic-transaksi","SimasPayMainMenuOptionType":"SIMASPAY_TRANSAKSI"]
            let optionDict5 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
            let optionDict6 = ["title":"Referral","image":"btnReferral","SimasPayMainMenuOptionType":"SIMASPAY_REFERRAL"]
            
            var menuViewArray = []
            menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6]
            mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_AGENT_ACCOUNT
            //Customer Login Flow
            mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
            self.navigationController!.pushViewController(mainMenuViewController, animated: true)
        }
    }
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        
        for  viewController in (self.navigationController?.viewControllers)!        {
            if viewController.isKindOfClass(LoginViewController)
            {
                //SimasPayPlistUtility.saveDataToPlist("NO", key: IS_LOGIN)
                self.navigationController?.popToViewController(viewController , animated: false)
            }
        }
    }
    

    func showRegularCustomerFlow ()
    {
        var menuViewArray = []
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        let optionDict1 = ["title":"Transfer","image":"btn-transfer","SimasPayMainMenuOptionType":"SIMASPAY_TRANSFER"]
        let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","SimasPayMainMenuOptionType":"SIMASPAY_PEMBELIAN"]
        let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","SimasPayMainMenuOptionType":"SIMASPAY_PEMBAYARAN"]
        let optionDict4 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","SimasPayMainMenuOptionType":"SIMASPAY_BAYAR_PAKAI_QR"]
        let optionDict5 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
        
        menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5]
        mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_AGENT_REGULAR
        mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)
    }
}