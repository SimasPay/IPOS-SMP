//
//  PaymentPurchaseViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/19/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class PaymentPurchaseViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var billersListArray : NSArray!
    static var isPurchase = false
    
    var data:NSDictionary!
    
    static func initWithOwnNib() -> PaymentPurchaseViewController {
        let obj:PaymentPurchaseViewController = PaymentPurchaseViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Payment")
        self.showBackButton()
        if (data == nil) {
            self.loadProductCategories()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadProductCategories() {
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
//        dict[CATEGORY] = PaymentPurchaseViewController.isPurchase ? CATEGORY_PURCHASE : payment
        dict[CATEGORY] = CATEGORY_PAYMENTS
        dict[VERSION] = "0"
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        DIMOAPIManager .callAPIPOST(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            DLog("\(responseDict)")
        }
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        cell.accessoryType = .disclosureIndicator;
        cell.textLabel?.text = "coba"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }

    
}
