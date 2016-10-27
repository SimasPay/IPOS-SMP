//
//  StatusTransferViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/4/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class StatusTransferViewController: BaseViewController {
    
    
    

    @IBOutlet var viewContentStatus: UIView!
    @IBOutlet var btnOK: BaseButton!
    @IBOutlet var lblStatus: BaseLabel!
    @IBOutlet var lblIdStatus: BaseLabel!
    @IBOutlet var viewMainFrame: UIView!
    
    @IBOutlet var constraintViewContent: NSLayoutConstraint!
     var data: NSDictionary!
    
    static func initWithOwnNib() -> StatusTransferViewController {
        let obj:StatusTransferViewController = StatusTransferViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Status")
        
        self.viewMainFrame.layer.cornerRadius = 5.0;
        self.viewMainFrame.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewMainFrame.layer.borderWidth = 0.5
        self.viewMainFrame.clipsToBounds = true;
        self.lblStatus.font = UIFont.boldSystemFont(ofSize: 16)
        self.lblIdStatus.font = UIFont.boldSystemFont(ofSize: 13)
        self.lblStatus.text = "Transfer Berhasil!"
        self.lblIdStatus.text = "ID Transaksi: 123958"
        
        btnOK.updateButtonType1()
        btnOK.setTitle("OK", for: .normal)
        
        data = [
            "title" : "pastikan data berikut bla bla bla",
            "content" : [
                "Nama product" : "tagihan",
                "Nomor" : "0812",
                "Jumlah" : "rp 123.333",
                "Diskon" : "rp 5000",
                "Nama product12" : "tagihan",
                "Nomor12" : "0812",
                "Jumlah12" : "rp 123.333",
                "Diskon12" : "rp 5000",
                "Nama pro4duct112" : "tagihan",
                "Nomor1231" : "0812",
                "Jumlah13221" : "rp 123.333",
                "Diskon12221" : "rp 5000",
                "Nama pro1112332d1uct12" : "tagihan",
                "Nomor1221" : "0812",
                "Jumlah121213" : "rp 123.333",
                "Diskon231112" : "rp 5000",
                "Nama23 pro132duct12" : "tagihan",
                "Nom23or11322" : "0812",
                "Jum23lah412" : "rp 123.333",
                "D123isk2on12" : "rp 5000",
                "12Nama 2product12" : "tagihan",
                "N123om5or12" : "0812",
                "J4umlah512" : "rp 123.333",
                "Di4124skon12" : "rp 5000"
                
                
            ],
            "footer" :[
                "total pendebitan" : "Rp 123.123",
                "total debit" : "Rp 123.123"
            ]
        ]

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let padding:CGFloat = 16
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width - 2 * 25
        let heightContent:CGFloat = 15
        let heightTitleContent:CGFloat = 15
        let margin:CGFloat = 10
        var y:CGFloat = 16
        
        
        let lblTitle = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightTitleContent))
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.text = data.value(forKey: "title") as? String
        viewContentStatus.addSubview(lblTitle)
        y += heightTitleContent + 10
        
        
        let contentDic = data.value(forKey: "content") as! NSDictionary
        for list in contentDic {
            let key = list.key as! String
            let Value = list.value as! String
            
            let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblKey.font = UIFont.boldSystemFont(ofSize: 13)
            lblKey.text = key
            viewContentStatus.addSubview(lblKey)
            y += heightContent
            
            let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblValue.font = UIFont.systemFont(ofSize: 13)
            lblValue.text = Value
            viewContentStatus.addSubview(lblValue)
            y += heightContent + margin
        }
        
        let line = CALayer()
        line.frame = CGRect(x: padding, y: y, width: width - 2 * padding, height: 1)
        line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
        viewContentStatus.layer.addSublayer(line)
        
        y += margin
        
        let contentFooterDic = data.value(forKey: "footer") as! NSDictionary
        for list in contentFooterDic {
            let key = list.key as! String
            let Value = list.value as! String
            
            let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblKey.font = UIFont.boldSystemFont(ofSize: 13)
            lblKey.text = key
            viewContentStatus.addSubview(lblKey)
            y += heightContent
            
            let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblValue.font = UIFont.systemFont(ofSize: 13)
            lblValue.text = Value
            viewContentStatus.addSubview(lblValue)
            y += heightContent + margin
        }
        self.constraintViewContent.constant = y
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonStatus()  {
        let vc = ConfirmationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
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
