//
//  PaymentPurchaseViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/19/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

//MARK: Payment lavel
enum PaymentLevel : Int {
    case PaymentLevelProductCategory
    case PaymentLevelProvider
    case PaymentLevelProduct
}

class PaymentPurchaseViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var paymentLevel : PaymentLevel!
    var isPurchase = false
    
    var data:NSArray!
    
    static func initWithOwnNib(isPurchased : Bool) -> PaymentPurchaseViewController {
        let obj:PaymentPurchaseViewController = PaymentPurchaseViewController.init(nibName: String(describing: self), bundle: nil)
        obj.isPurchase = isPurchased
        obj.paymentLevel = PaymentLevel.PaymentLevelProductCategory
        return obj
    }
    
    static func initWithOwnNib(isPurchased : Bool, type : PaymentLevel) -> PaymentPurchaseViewController {
        let obj = self.initWithOwnNib(isPurchased: isPurchased)
        obj.paymentLevel = type
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(self.isPurchase ? "Pembelian" : "Pembayaran")
        
        self.showBackButton()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.rowHeight = 56
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (data == nil) {
            self.loadProductCategories()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data != nil ? self.data.count : 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        cell.accessoryType = .disclosureIndicator;
        var string = ""
        switch self.paymentLevel.rawValue {
        case PaymentLevel.PaymentLevelProductCategory.rawValue:
            string = (self.data[indexPath.row] as! NSDictionary).object(forKey: "productCategory") as! String
            break;
        case PaymentLevel.PaymentLevelProvider.rawValue:
            string = (self.data[indexPath.row] as! NSDictionary).object(forKey: "providerName") as! String
            break;
        case PaymentLevel.PaymentLevelProduct.rawValue:
            string = (self.data[indexPath.row] as! NSDictionary).object(forKey: "productName") as! String
            break;
        default:
            break;
        }
        cell.textLabel?.text = string
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var dict:NSArray!
        if (self.paymentLevel == PaymentLevel.PaymentLevelProduct) {
            // input VC
            var vc = DetailPaymentPurchaseViewController()
            if isPurchase {
                vc = DetailPaymentPurchaseViewController.initWithOwnNib(isPurchased: true)
            } else {
                vc = DetailPaymentPurchaseViewController.initWithOwnNib(isPurchased: false)
            }
            vc.dictOfData = self.data[indexPath.row] as! NSDictionary
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            var vc: PaymentPurchaseViewController
            switch self.paymentLevel.rawValue {
            case PaymentLevel.PaymentLevelProductCategory.rawValue:
                vc = PaymentPurchaseViewController.initWithOwnNib(isPurchased: self.isPurchase, type: .PaymentLevelProvider)
                dict = (self.data[indexPath.row] as! NSDictionary).object(forKey: "providers") as! NSArray
                break;
            case PaymentLevel.PaymentLevelProvider.rawValue:
                vc = PaymentPurchaseViewController.initWithOwnNib(isPurchased: self.isPurchase, type: .PaymentLevelProduct)
                dict = (self.data[indexPath.row] as! NSDictionary).object(forKey: "products") as! NSArray
                DLog("\(dict)")
                break;
            default:
                vc = PaymentPurchaseViewController.initWithOwnNib(isPurchased: self.isPurchase, type: .PaymentLevelProvider)
                dict = (self.data[indexPath.row] as! NSDictionary).object(forKey: "providers") as! NSArray
                
                break;
            }
            vc.data = dict
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: get product categories
    func loadProductCategories() {
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = self.isPurchase ? CATEGORY_PURCHASE : CATEGORY_PAYMENTS
        dict[VERSION] = "0"
        
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        DIMOAPIManager .callAPIPOST(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            let responseDict = dict != nil ? NSDictionary(dictionary: dict!) : [:]
            //            DLog("\(responseDict)")
            if (responseDict.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                // success
                let key = self.isPurchase ? "purchaseData" : "paymentData"
                self.data = responseDict.object(forKey: key) as! NSArray!
                //                DLog("\(self.data)")
                self.tableView.reloadData()
            }
        }
        
    }

    
}
