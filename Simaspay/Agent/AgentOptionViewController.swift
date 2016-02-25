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
            cell.textLabel!.text = "Akun Reguler"
            cell.detailTextLabel!.text = "1122334488"
        }
        
        if indexPath.row == 1
        {
            cell.textLabel!.text = "Akun Agen"
            cell.detailTextLabel!.text = "0881991122"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var menuViewArray = []
        
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        
        if indexPath.row == 0
        {
            
            // 1
            if #available(iOS 8.0, *) {
                let optionMenu = UIAlertController(title: nil, message: "Select Account Type", preferredStyle: .ActionSheet)
                // 2
                let deleteAction = UIAlertAction(title: "Customer Reguler", style: .Default, handler: {
                    
                    action -> Void in
                    
                    self.showRegularCustomerFlow()
                    
                })
                let saveAction = UIAlertAction(title: "Customer Laku Pandai", style: .Default, handler: {
                    
                    action -> Void in
                    
                    self.showLakuPandaiCustomerFlow()
                    
                })
                
                //
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                    
                    (alert: UIAlertAction!) -> Void in
                })
            
                // 4
                optionMenu.addAction(deleteAction)
                optionMenu.addAction(saveAction)
                optionMenu.addAction(cancelAction)
                
                // 5
                self.presentViewController(optionMenu, animated: true, completion: nil)
                
            } else {
                // Fallback on earlier versions
                
                let actionSheet = UIActionSheet(title: "Select Account Type", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "", otherButtonTitles: "Customer Reguler", "Customer Laku Pandai")
                actionSheet.showInView(self.view)
            }
            
            
            
            
            
        }

        if indexPath.row == 1
        {
            let optionDict1 = ["title":"Setor Tunai","image":"btn-setortunai","SimasPayMainMenuOptionType":"SIMASPAY_SETOR_TUNAI"]
            let optionDict2 = ["title":"Buka Rekening","image":"btn-bukarekening","SimasPayMainMenuOptionType":"SIMASPAY_BUKA_REKENING"]
            let optionDict3 = ["title":"Tutup Rekening","image":"btn-tutuprekening","SimasPayMainMenuOptionType":"SIMASPAY_TUTUP_REKENING"]
            let optionDict4 = ["title":"Transaksi","image":"ic-transaksi","SimasPayMainMenuOptionType":"SIMASPAY_TRANSAKSI"]
            let optionDict5 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
            let optionDict6 = ["title":"Referral","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REFERRAL"]
            
            menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6]
            mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_AGENT_ACCOUNT
        }
        
        //Customer Login Flow
        
        mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)
    }
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        
        for  viewController in (self.navigationController?.viewControllers)!        {
            if viewController.isKindOfClass(LoginViewController)
            {
                self.navigationController?.popToViewController(viewController , animated: true)
            }
        }
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("Done");
            break;
        case 1:
            NSLog("Cancel");
            break;
        case 2:
            self.showRegularCustomerFlow()
            break;
        case 3:
            self.showLakuPandaiCustomerFlow()
            NSLog("No");
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
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
    
    func showLakuPandaiCustomerFlow()
    {
        var menuViewArray = []
        
        let mainMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        let optionDict1 = ["title":"Transfer","image":"btn-transfer","SimasPayMainMenuOptionType":"SIMASPAY_TRANSFER"]
        let optionDict2 = ["title":"Pembelian","image":"btn-pembelian","SimasPayMainMenuOptionType":"SIMASPAY_PEMBELIAN"]
        let optionDict3 = ["title":"Pembayaran","image":"btn-pembayaran","SimasPayMainMenuOptionType":"SIMASPAY_PEMBAYARAN"]
        let optionDict4 = ["title":"Tarik Tunai","image":"btn-tariktunai","SimasPayMainMenuOptionType":"SIMASPAY_TARIK_TUNAI"]
        let optionDict5 = ["title":"Bayar Pakai QR","image":"btn-bayarpakaiqr","SimasPayMainMenuOptionType":"SIMASPAY_BAYAR_PAKAI_QR"]
        let optionDict6 = ["title":"Rekening","image":"btn-rekening","SimasPayMainMenuOptionType":"SIMASPAY_REKENING"]
        
        menuViewArray = [optionDict1,optionDict2,optionDict3,optionDict4,optionDict5,optionDict6]
        mainMenuViewController.simasPayUserType =  SimasPayUserType.SIMASPAY_AGENT_LAKU_PANDAI
        mainMenuViewController.menuViewArray = menuViewArray as Array<AnyObject>
        self.navigationController!.pushViewController(mainMenuViewController, animated: true)
    }
}