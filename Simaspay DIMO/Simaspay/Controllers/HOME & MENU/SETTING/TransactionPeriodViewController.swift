//
//  TransactionPeriodViewController.swift
//  Simaspay
//
//  Created by Dimo on 1/13/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

class TransactionPeriodViewController: BaseViewController, UITextFieldDelegate {
    
    

    @IBOutlet weak var lblInfo: BaseLabel!
    @IBOutlet weak var lblCustomPeriod: BaseLabel!
    
    //radio button
    @IBOutlet weak var radioBtnThisMonth: BaseButton!
    @IBOutlet weak var radioBtnLastMonth: BaseButton!
    @IBOutlet weak var radioBtnTwoMonthAgo: BaseButton!
    @IBOutlet weak var radioBtnCustomPeriod: BaseButton!
    
    @IBOutlet weak var btnNext: BaseButton!
    @IBOutlet weak var tfFirstDate: BaseTextField!
    @IBOutlet weak var tfSecondDate: BaseTextField!
    
    //datePicker for tfFirstDate
    var datePicker = UIDatePicker()
    
    //datePicker for tfsecondDAte
    var datePicker2 = UIDatePicker()
    
    var startDate: NSString!
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
        
        //Radio button title
        radioBtnThisMonth.updateToRadioButtonWith(_titleButton: "Bulan ini")
        radioBtnLastMonth.updateToRadioButtonWith(_titleButton: "Bulan lalu")
        radioBtnTwoMonthAgo.updateToRadioButtonWith(_titleButton: "2 bulan lalu")
        radioBtnCustomPeriod.updateToRadioButtonWith(_titleButton: "Periode dari")
        radioBtnThisMonth.isSelected = true
        
        btnNext.updateButtonType1()
        btnNext.setTitle("Lanjut", for: .normal)
        
        tfFirstDate.delegate = self
        tfSecondDate.delegate = self
        
        tfFirstDate.placeholder = "DD-MM-YYYY"
        tfSecondDate.placeholder = "DD-MM-YYYY"
        
        tfFirstDate.isUserInteractionEnabled = false
        tfSecondDate.isUserInteractionEnabled = false
        
        tfFirstDate.addInset()
        tfSecondDate.addInset()
        
        //Right Image in textfield
        tfFirstDate.rightViewMode =  UITextFieldViewMode.always
        tfSecondDate.rightViewMode =  UITextFieldViewMode.always
        tfFirstDate.updateTextFieldWithRightImageNamed("icon_Calendar.png")
        tfSecondDate.updateTextFieldWithRightImageNamed("icon_Calendar.png")
        
        //Datepicker first textfield
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.tfFirstDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
        //Datepicker first textfield
        datePicker2.datePickerMode = .date
        datePicker2.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.tfSecondDate.inputView = datePicker2
        datePicker2.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
        //Defult selection previous month
        self.getDateWithPreviousMonth(numberOfMonth: 0)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: keyboard Show set last object above keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfFirstDate{
            BaseViewController.lastObjectForKeyboardDetector = self.tfSecondDate
        } else if textField == self.tfSecondDate{
            BaseViewController.lastObjectForKeyboardDetector = self.btnNext
        }
        updateUIWhenKeyboardShow()
        return true
    }

    //MARK: Radio button action
    @IBAction func actionRadioPeriod(_ sender: Any) {
        radioBtnThisMonth.isSelected = false
        radioBtnLastMonth.isSelected = false
        radioBtnTwoMonthAgo.isSelected = false
        radioBtnCustomPeriod.isSelected = false
        radioBtnThisMonth.isSelected = false
        let current = sender as! UIButton
        current.isSelected = true
        
        tfFirstDate.text = ""
        tfSecondDate.text = ""
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
            startDate = tfFirstDate.text as NSString!
            toDate = tfSecondDate.text as NSString!
        }

        
    }
    
    //MARK: date formatter from date picker
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

    //MARK: get range date, if int: 0 (this month) else if int:1 (last month) else if int 2 (two month ago)
    func getDateWithPreviousMonth(numberOfMonth: Int) {
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        
        var year =  components.year! as Int
        var month = components.month! as Int
        var day = components.day! as Int
        
        var endDate = ""
        var fromDate = ""
        if numberOfMonth == 0 {
            endDate = String(format: "%@%@%@%@", String(day), String(month < 10 ? "0" : ""),String(month),String(year))
            fromDate = endDate
           fromDate = String(format: "01%@", endDate.substring(from: endDate.index(endDate.startIndex, offsetBy: 2)))
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
            dateFormatter.dateFormat = "ddMMyyyy"
            let endDateTamp = dateFormatter.date(from: endDate)
            let endDateTampString = calendar.date(byAdding: .day, value: -1, to: endDateTamp!)
            components = calendar.dateComponents([.year, .month, .day], from: endDateTampString!)
            
            year =  components.year! as Int
            month = components.month! as Int
            day = components.day! as Int
            endDate = String(format: "%@%@%@%@", String(day), String(month < 10 ? "0" : ""),String(month),String(year))
            
        }
        startDate = fromDate as NSString!
        toDate = endDate as NSString!
       
        DLog("\(fromDate) & \(endDate)")
      
    }
    
    //MARK: Action buttpn next
    @IBAction func actionBtnNext(_ sender: Any) {
        if radioBtnCustomPeriod.isSelected {
            var message = "";
            if (!tfFirstDate.isValid()) {
                message = "Masukkan periode waktu yang diinginkan"
            } else if (!tfSecondDate.isValid()) {
                message = "Masukkan periode waktu yang diinginkan"
            }
            
            if (message.characters.count > 0) {
                SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
                return
            }

        }
        let vc = TransactionHistoryViewController.initWithOwnNib()
        vc.startDate = startDate
        vc.toDate = toDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
       

}
