//
//  TransactionHistoryViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/24/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class TransactionHistoryViewController: BaseViewController {

    @IBOutlet var scrollView: UIScrollView!
    static func initWithOwnNib() -> TransactionHistoryViewController {
        let obj:TransactionHistoryViewController = TransactionHistoryViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Transaksi")
        self.showBackButton()
        
        
        var arrayData: [[String:Any]] = []
        
        arrayData = [["date":"06/04/2015","Type":"C","name":"Transfer","total":"Rp 500.000"],["date":"06/04/2015","Type":"D","name":"Bill Payme","total":"Rp 35.000"],["date":"06/04/2015","Type":"D","name":"Admin Fee","total":"Rp 10.000"],["date":"06/04/2015","Type":"C","name":"Transfer","total":"Rp 500.000"],["date":"06/04/2015","Type":"D","name":"Bill Payme","total":"Rp 35.000"],["date":"06/04/2015","Type":"D","name":"Admin Fee","total":"Rp 10.000"],["date":"06/04/2015","Type":"C","name":"Transfer","total":"Rp 500.000"],["date":"06/04/2015","Type":"D","name":"Bill Payme","total":"Rp 35.000"],["date":"06/04/2015","Type":"D","name":"Admin Fee","total":"Rp 10.000"],["date":"06/04/2015","Type":"C","name":"Transfer","total":"Rp 500.000"],["date":"06/04/2015","Type":"D","name":"Bill Payme","total":"Rp 35.000"],["date":"06/04/2015","Type":"D","name":"Admin Fee","total":"Rp 10.000"]]
        
        let padding:CGFloat = 25
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width
        var height:CGFloat = 0
        let paddingContent: CGFloat = 16
        var y: CGFloat  = 0
        let widthContent = width - (2 * paddingContent) - (2 * padding)
        let heightContent: CGFloat = 67
        var viewContent = UIView()
        viewContent.backgroundColor = UIColor.white
        viewContent.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        viewContent.layer.borderWidth = 1;
        viewContent.layer.cornerRadius = 7;
        viewContent.clipsToBounds = true;
        
        for list in arrayData {
            
            let viewList = UIView(frame: CGRect(x: paddingContent, y: y, width: widthContent, height: heightContent))
            
            let lblDate = UILabel(frame: CGRect(x: 0, y: 16, width: 80, height: 20))
            lblDate.font = UIFont.systemFont(ofSize: 13)
            lblDate.text = list["date"] as! String?
            
            let lblType = UILabel(frame: CGRect(x: viewList.bounds.size.width - 30, y: 16, width: 30, height: 20))
            lblType.font = UIFont.systemFont(ofSize: 10)
            lblType.textColor = UIColor.init(hexString: color_base_white)
            lblType.textAlignment = .center
            lblType.layer.cornerRadius = 2.5
            lblType.clipsToBounds = true
            let type = list["Type"] as! String?
            
            if (type!.isEqual("C")) {
                lblType.text = "credit"
                lblType.backgroundColor = UIColor.init(hexString: color_cradit)
                
            } else {
                lblType.text = "debit"
                lblType.backgroundColor = UIColor.init(hexString: color_debit)
            }
            
            let lblNameTransaction = UILabel(frame: CGRect(x: 0, y: 40, width: 80, height: 20))
            lblNameTransaction.font = UIFont.systemFont(ofSize: 13)
            lblNameTransaction.text = list["name"] as! String?
            
            let lblTotal = UILabel(frame: CGRect(x: viewList.bounds.size.width - 100, y: 40, width: 100, height: 20))
            lblTotal.font = UIFont.systemFont(ofSize: 13)
            lblTotal.textAlignment = .right
            lblTotal.text = list["total"] as! String?
            
            
            
            
            let line = CALayer()
            line.frame = CGRect(x: 0, y:heightContent - 1 , width: widthContent, height: 1)
            line.backgroundColor = UIColor.init(hexString: color_border).cgColor
            viewList.addSubview(lblDate)
            viewList.addSubview(lblType)
            viewList.addSubview(lblNameTransaction)
            viewList.addSubview(lblTotal)
            viewList.layer.addSublayer(line)
            viewContent.addSubview(viewList)
            y += 67
            height += heightContent
        }
        viewContent.frame = CGRect(x: padding, y: padding, width: width - 2 * padding, height: height)
        scrollView.addSubview(viewContent)
        
        scrollView.contentSize = CGSize(width: width, height: height + 2 * padding)
        
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
