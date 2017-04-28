//
//  TransactionHistoryViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/24/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit
import QuickLook

class TransactionHistoryViewController: BaseViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var btnDownload: UIButton!
    
    //Array of data transaction
    var arrayData: [[String:Any]] = []
    
    //date
    var startDate: NSString! = ""
    var toDate: NSString! = ""
    
    static func initWithOwnNib() -> TransactionHistoryViewController {
        let obj:TransactionHistoryViewController = TransactionHistoryViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("TransactionHistoryTitle"))
        self.showBackButton()
        self.checkTransactionHistory()
        
        
    }
    
    //MARK: programmatically list of transaction history
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (startDate.length == 0) {
            
            self.btnDownload.isHidden = true
        }
        let padding:CGFloat = 25
        var yPadding:CGFloat = 25
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width
        var height:CGFloat = 0
        let paddingContent: CGFloat = 16
        var y: CGFloat  = 0
        let widthContent = width - (2 * paddingContent) - (2 * padding)
        let heightContent: CGFloat = 70
        
        if startDate.length != 0 {
            let periode = BaseLabel(frame: CGRect(x: padding, y: yPadding, width: width - 2 * padding, height: 20))
            periode.text = String(format: "Periode:  %@ - %@", startDate,toDate)
            yPadding += 30
            scrollView.addSubview(periode)
        }
        let viewContent = UIView()
        viewContent.backgroundColor = UIColor.white
        viewContent.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        viewContent.layer.borderWidth = 1;
        viewContent.layer.cornerRadius = 7;
        viewContent.clipsToBounds = true;
        
        for list in arrayData {
            
            let viewList = UIView(frame: CGRect(x: paddingContent, y: y, width: widthContent, height: heightContent))
            
            let lblDate = UILabel(frame: CGRect(x: 0, y: 16, width: 80, height: 20))
            lblDate.font = UIFont.systemFont(ofSize: 13)
            lblDate.text = (list["transactionTime"] as! NSDictionary).object(forKey: "text") as? String
            
            let lblType = UILabel(frame: CGRect(x: viewList.bounds.size.width - 30, y: 16, width: 30, height: 20))
            lblType.font = UIFont.systemFont(ofSize: 10)
            lblType.textColor = UIColor.init(hexString: color_base_white)
            lblType.textAlignment = .center
            lblType.layer.cornerRadius = 2.5
            lblType.clipsToBounds = true
            let type = (list["isCredit"] as! NSDictionary).object(forKey: "text") as? String
            
            let lblTotal = UILabel(frame: CGRect(x: viewList.bounds.size.width - 100, y: 40, width: 100, height: 20))
            lblTotal.font = UIFont.systemFont(ofSize: 13)
            lblTotal.textAlignment = .right
            let Total = (list["amount"] as! NSDictionary).object(forKey: "text") as? String
            
            
            if (type == "true") {
                lblType.text = "credit"
                lblType.backgroundColor = UIColor.init(hexString: color_cradit)
                lblTotal.text = String(format: "-IDR %@", Total!)
            } else {
                lblType.text = "debit"
                lblType.backgroundColor = UIColor.init(hexString: color_debit)
                lblTotal.text = String(format: "IDR %@", Total!)
            }
            
            let lblNameTransaction = UILabel(frame: CGRect(x: 0, y: 40, width: 200, height: 20))
            lblNameTransaction.font = UIFont.systemFont(ofSize: 13)
            lblNameTransaction.text = (list["transactionType"] as! NSDictionary).object(forKey: "text") as? String
            
            
            let line = CALayer()
            line.frame = CGRect(x: 0, y:heightContent - 1 , width: widthContent, height: 1)
            line.backgroundColor = UIColor.init(hexString: color_border).cgColor
            viewList.addSubview(lblDate)
            viewList.addSubview(lblType)
            viewList.addSubview(lblNameTransaction)
            viewList.addSubview(lblTotal)
            viewList.layer.addSublayer(line)
            viewContent.addSubview(viewList)
            y += 70
            height += heightContent
        }
        viewContent.frame = CGRect(x: padding, y: yPadding, width: width - 2 * padding, height: height)
        scrollView.addSubview(viewContent)
        scrollView.contentSize = CGSize(width: width, height: height + 2 * yPadding)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkTransactionHistory() {
        var message = ""
        if (!DIMOAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_ACCOUNT_HISTORY
        dict[SERVICE] = SERVICE_WALLET
        dict[INSTITUTION_ID] = ""
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = DIMOAPIManager.sharedInstance().encryptedMPin
        if startDate.length != 0 {
            dict["fromDate"] = startDate
            dict["toDate"] = toDate
        }
        
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[SOURCEPOCKETCODE] = DIMOAPIManager.sharedInstance().sourcePocketCode
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            let dictionary = NSDictionary(dictionary: dict!)
            DLog("\(dictionary)")
            let messageCode  = dictionary.value(forKeyPath: "message.code") as! String
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                if (messageCode == "39"){
                    if let result = responseDict.value(forKeyPath: "transactionDetails.transactionDetail") as! [[String : Any]]? {
                        self.arrayData = result
                    } else {
                        self.arrayData = [responseDict.value(forKeyPath: "transactionDetails.transactionDetail") as! Dictionary<String, Any>]
                    }
                } else {
                    
                    DIMOAlertView.showNormalTitle("Error", message: dictionary.value(forKeyPath: "message.text") as! String, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alert) in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        for vc in viewControllers {
                            if (vc.isKind(of: HomeViewController.self)) {
                                self.navigationController!.popToViewController(vc, animated: true);
                                return
                            }
                        }
                    }, cancelButtonTitle: "OK")
                    
                }
                
            }
            
        }
    }
    
    
    //MARK: Download PDF
    @IBAction func actionDownloadPDF(_ sender: Any) {
        self.downloadPDF()
    }
    
    //get pdf url for downloading
    func downloadPDF()  {
        var message = ""
        if (!DIMOAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_DownLoad_History_PDF
        dict[SERVICE] = SERVICE_WALLET
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = DIMOAPIManager.sharedInstance().encryptedMPin
        dict[FROM_DATE] = startDate
        dict[TO_DATE] = toDate
        dict[CHANNEL_ID] = CHANNEL_ID_VALUE
        dict[SOURCEPOCKETCODE] = DIMOAPIManager.sharedInstance().sourcePocketCode
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
                DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
                return
            }
            
            let dictionary = NSDictionary(dictionary: dict!)
            DLog("\(dictionary)")
            if (dictionary.allKeys.count == 0) {
                DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DispatchQueue.global().async {
                    let str = "\(DIMOAPIManager.downloadPDFURL()!)\(responseDict.object(forKeyPaths: "downloadURL.text")!)"
                    if let data: NSData = NSData(contentsOf: URL(string: str)!) {
                        DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
                        let fileManager = FileManager.default
                        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent("Mutasi.pdf")
                        let path = fileURL.path
                        //fileManager.removeItemAtPath(path)
                        DispatchQueue.main.async {
                            fileManager.createFile(atPath: path, contents: data as Data,attributes: nil)
                            self.previewPDFDownloaded(path: path)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Preview PDF with QLPreviewController
    static var currentPath : String = ""
    func previewPDFDownloaded(path : String){
        TransactionHistoryViewController.currentPath = path
        let previewController:QLPreviewController = QLPreviewController()
        previewController.currentPreviewItemIndex = 0
        previewController.dataSource = self
        previewController.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = ""
        self.navigationController!.present(previewController, animated: true, completion: {
        })
        
        
    }
    
    @available(iOS 4.0, *)
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    internal func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem
    {
        return NSURL.fileURL(withPath: TransactionHistoryViewController.currentPath) as QLPreviewItem
    }
}
