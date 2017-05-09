//
//  TransferOtherBankListViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/18/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class TransferOtherBankListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet var tfSearch: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var bankList:NSMutableArray = []
    var filtered:NSMutableArray = []
    
    var data:NSMutableArray = []
    static func initWithOwnNib() -> TransferOtherBankListViewController {
        let obj:TransferOtherBankListViewController = TransferOtherBankListViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Pilih Bank")
        self.showBackButton()
        
        tfSearch.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getBankList()
        
        
    }
    
    //MARK: Search bar filter function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = NSMutableArray(array: data)
        filtered.filter(using: NSPredicate(format: "%K CONTAINS[c] %@", "name", searchText))
        if filtered.count == 0 {
            filtered = data
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: get other bank list
    func getBankList() {
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_BANK_CODES
        dict[VERSION] = "0"
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        SimasAPIManager .callAPIPOST(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    SimasAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            
            self.bankList = (responseDict.value(forKey: "bankData") as! NSArray).mutableCopy() as! NSMutableArray
            
            self.data = self.bankList
            self.filtered = self.bankList
            
            // DLog("\(self.bankList)")
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview list other bank transfer
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        cell.accessoryType = .disclosureIndicator;
        cell.textLabel?.text = (filtered[indexPath.row] as! Dictionary)["name"]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
        let bankName = filtered[indexPath.row] as! NSDictionary
        let vc = TransferBankViewController.initWithOwnNib(type: TransferType.TransferTypeOtherBank)
        vc.bankName = bankName
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
