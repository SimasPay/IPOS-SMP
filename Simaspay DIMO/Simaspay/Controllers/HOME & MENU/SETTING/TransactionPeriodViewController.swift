//
//  TransactionPeriodViewController.swift
//  Simaspay
//
//  Created by Dimo on 1/13/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

class TransactionPeriodViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var tfFirstDate: BaseTextField!
    @IBOutlet weak var tfSecondDate: BaseTextField!

    @IBOutlet weak var lblInfo: BaseLabel!
    @IBOutlet weak var radioBtnThisMonth: BaseButton!
    @IBOutlet weak var radioBtnLastMonth: BaseButton!
    @IBOutlet weak var radioBtnTwoMonthAgo: BaseButton!
    @IBOutlet weak var radioBtnCustomPeriod: BaseButton!
    @IBOutlet weak var btnNext: BaseButton!
    @IBOutlet weak var lblCustomPeriod: BaseLabel!
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var fromDate: NSString!
    var toDate: NSString!
    
    static func initWithOwnNib() -> TransactionPeriodViewController {
        let obj:TransactionPeriodViewController = TransactionPeriodViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("Periode Transaksi"))
        self.showBackButton()
        
        lblInfo.textAlignment = .center
        lblInfo.numberOfLines = 2
        lblInfo.text = "Silakan pilih periode transaksi yang ingin Anda lihat"
        lblCustomPeriod.text = "Hingga"
        radioBtnThisMonth.updateToRadioButtonWith(_titleButton: "Bulan ini")
        radioBtnLastMonth.updateToRadioButtonWith(_titleButton: "Bulan lalu")
        radioBtnTwoMonthAgo.updateToRadioButtonWith(_titleButton: "2 bulan lalu")
        radioBtnCustomPeriod.updateToRadioButtonWith(_titleButton: "Periode dari")
        radioBtnThisMonth.isSelected = true
        
        btnNext.updateButtonType1()
        btnNext.setTitle("Lanjut", for: .normal)
        
        tfFirstDate.delegate = self
        tfSecondDate.delegate = self
        
        tfFirstDate.text = "DD-MM-YYYY"
        tfSecondDate.text = "DD-MM-YYYY"
        
        tfFirstDate.addInset()
        tfSecondDate.addInset()
        tfFirstDate.rightViewMode =  UITextFieldViewMode.always
        tfSecondDate.rightViewMode =  UITextFieldViewMode.always
        tfFirstDate.updateTextFieldWithRightImageNamed("icon_Calendar.png")
        tfSecondDate.updateTextFieldWithRightImageNamed("icon_Calendar.png")
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.tfFirstDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        datePicker2.datePickerMode = .date
        datePicker2.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.tfSecondDate.inputView = datePicker2
        datePicker2.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "ddMMyyyy"
        if sender == datePicker {
            tfFirstDate.text = formatter.string(from: sender.date)
        } else {
            tfSecondDate.text = formatter.string(from: sender.date)
        }
        
    }
    @IBAction func actionRadioPeriod(_ sender: Any) {
        radioBtnThisMonth.isSelected = false
        radioBtnLastMonth.isSelected = false
        radioBtnTwoMonthAgo.isSelected = false
        radioBtnCustomPeriod.isSelected = false
        radioBtnThisMonth.isSelected = false
        let current = sender as! UIButton
        current.isSelected = true
        
        
        tfFirstDate.isUserInteractionEnabled = false
        tfSecondDate.isUserInteractionEnabled = false
        if radioBtnThisMonth.isSelected {
            self.getDateWithPreviousMonth(numberOfMonth: 0)
        } else if radioBtnLastMonth.isSelected {
            self.getDateWithPreviousMonth(numberOfMonth: 1)
        } else if radioBtnTwoMonthAgo.isSelected {
            self.getDateWithPreviousMonth(numberOfMonth: 2)
        } else if radioBtnCustomPeriod.isSelected {
            
            tfFirstDate.isUserInteractionEnabled = true
            tfSecondDate.isUserInteractionEnabled = true
            fromDate = tfFirstDate.text as NSString!
            toDate = tfSecondDate.text as NSString!
        }

        
    }
    
    func getDateWithPreviousMonth(numberOfMonth: Int) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        var year =  components.year! as Int
        var month = components.month! as Int
        let day = components.day! as Int
        
        var endDate = ""
        var fromDate = ""
        if numberOfMonth == 0 {
            endDate = String(format: "%@%@%@%@", String(day), String(month < 10 ? "0" : ""),String(month),String(year))
            fromDate = endDate.replacingOccurrences(of: String(day), with: "01", options: .literal, range: nil)
        } else {
            // month
            month -= numberOfMonth
            if month <= 0 {
                month = 12 + month
                year -= 1
            }
            
            // to month
            var toMonth = month + 1
            var toYear = year
            if (toMonth > 12) {
                toMonth = 1
                toYear += 1
            }
            
            //currentDate = String(format: "30%@%@",String(month),String(year))
            let additionalFromDate =  month < 10 ? "0" : ""
            let additionalEndDate =  toMonth < 10 ? "0" : ""
            fromDate =  String(format: "01%@%@%@", additionalFromDate, String(month),String(year))
            endDate = String(format: "01%@%@%@", additionalEndDate, String(toMonth),String(toYear))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddmmyyyy"
            let endDateTamp = dateFormatter.date(from: endDate)
            
            // condition for - 1 day endDate
            // date from string
            // date - 1 day
            // string from date.
        }
        
     
        DLog("\(fromDate) & \(endDate)")
        
        
   
      
    }
    @IBAction func actionBtnNext(_ sender: Any) {
       
    self.checkTransactionHistory()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfFirstDate{
            BaseViewController.lastObjectForKeyboardDetector = self.tfSecondDate
        } else if textField == self.tfSecondDate{
            BaseViewController.lastObjectForKeyboardDetector = self.btnNext
        }
        updateUIWhenKeyboardShow()
        return true
    }

    
    func checkTransactionHistory() {
        var message = ""
        if (!DIMOAPIManager.isInternetConnectionExist()){
            message = getString("LoginMessageNotConnectServer")
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: String("AlertCloseButtonText"))
            return
        }
        DLog("\(UserDefault.objectFromUserDefaults(forKey: SOURCEPOCKETCODE))")
        let dict = NSMutableDictionary()
        dict[TXNNAME] = TXN_ACCOUNT_HISTORY
        dict[SERVICE] = SERVICE_WALLET
        dict[INSTITUTION_ID] = ""
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(UserDefault.objectFromUserDefaults(forKey: MPIN) as! String)
        dict["fromDate"] = fromDate
        dict["toDate"] = toDate
        dict[CHANNEL_ID] = "7"
        dict[SOURCEPOCKETCODE] = UserDefault.objectFromUserDefaults(forKey: SOURCEPOCKETCODE)
        

        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DIMOAPIManager .callAPI(withParameters: param) { (dict, err) in
            
            if (err != nil) {
                let error = err as! NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    DIMOAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                return
            }
            let dictionary = NSDictionary(dictionary: dict!)
            let messageCode  = dictionary.value(forKeyPath: "message.code") as! String
            if (dictionary.allKeys.count == 0) {
                DIMOAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: String("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                if (messageCode == "39"){
//                    DLog("\(responseDict)")
                    let vc = TransactionHistoryViewController.initWithOwnNib()
                    vc.arrayData = responseDict.value(forKeyPath: "transactionDetails.transactionDetail") as! [[String : Any]]
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    DIMOAlertView.showAlert(withTitle: "", message: dictionary.value(forKeyPath: "message.text") as! String, cancelButtonTitle: String("AlertCloseButtonText"))
                }
                
            }
            
            
        }
    }
    

}
