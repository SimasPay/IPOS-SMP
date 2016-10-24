//
//  BalanceInfoViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/24/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class BalanceInfoViewController: BaseViewController {

    
    @IBOutlet var lblDate: BaseLabel!
    @IBOutlet var lblTime: BaseLabel!
    @IBOutlet var viewContent: UIView!
    @IBOutlet var lblBalanceInfo: BaseLabel!
    
    static func initWithOwnNib() -> BalanceInfoViewController {
        let obj:BalanceInfoViewController = BalanceInfoViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitle("Info Saldo")
        self.showBackButton()
        
      
        let currentDate = NSDate()
        
        //Get current Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.string(from: currentDate as Date)
        DLog("\(date)")
        
        //get current time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let time = timeFormatter.string(from: currentDate as Date)
        DLog("\(time)")
        
        //attribute
        lblDate.font = UIFont.boldSystemFont(ofSize: 13)
        let dateString = String(format: "Tanggal : %@", date)
        lblDate.text = dateString as String
        let rangeDate = (dateString as NSString).range(of: date)
        let attributedDateString = NSMutableAttributedString(string:dateString)
        attributedDateString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], range: rangeDate)
        self.lblDate.attributedText = attributedDateString
        
        lblTime.font = lblDate.font
        lblTime.textAlignment = .right
        let timeString = String(format: "Jam: %@", time)
        lblTime.text = timeString as String
        let range = (timeString as NSString).range(of: time)
        let attributedString = NSMutableAttributedString(string:timeString)
        attributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], range: range)
        self.lblTime.attributedText = attributedString
        
        
        let balance = "5000000"
        lblBalanceInfo.font = UIFont.systemFont(ofSize: 13)
        lblBalanceInfo.textAlignment = .center
        lblBalanceInfo.numberOfLines = 2
        let balanceInfoString = String(format: "Saldo Anda saat ini adalah: \n %@", balance)
        lblBalanceInfo.text = balanceInfoString as String
        let rangebalanceInfo = (balanceInfoString as NSString).range(of: balance)
        let attributedbalanceInfoString = NSMutableAttributedString(string:balanceInfoString)
        attributedbalanceInfoString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 24)], range: rangebalanceInfo)
        self.lblBalanceInfo.attributedText = attributedbalanceInfoString
        
        

        viewContent.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        viewContent.layer.borderWidth = 1;
        viewContent.layer.cornerRadius = 7;
        viewContent.clipsToBounds = true;
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
