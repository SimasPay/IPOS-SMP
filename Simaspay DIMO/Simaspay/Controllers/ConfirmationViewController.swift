//
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/4/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController {
    @IBOutlet var viewContentConfirmation: UIView!
    @IBOutlet var btnTrue: BaseButton!
    @IBOutlet var btnFalse: BaseButton!
    @IBOutlet var constraintViewContent: NSLayoutConstraint!

    var data: NSDictionary!
    
    static func initWithOwnNib() -> ConfirmationViewController {
        let obj:ConfirmationViewController = ConfirmationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Konfirmasi")
        self.showBackButton()
        self.view.backgroundColor = UIColor.init(hexString: color_background)

        
        self.viewContentConfirmation.layer.cornerRadius = 5.0;
        self.viewContentConfirmation.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewContentConfirmation.layer.borderWidth = 0.5
        self.viewContentConfirmation.clipsToBounds = true;
        
        
        self.btnTrue.updateButtonType1()
        self.btnTrue.setTitle("Benar", for: .normal)
        self.btnFalse.updateButtonType3()
        self.btnFalse.setTitle("Salah", for: .normal)
        btnFalse.addTarget(self, action: #selector(ConfirmationViewController.buttonStatus) , for: .touchUpInside)
        
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
        viewContentConfirmation.addSubview(lblTitle)
        y += heightTitleContent + 10
        
        
        let contentDic = data.value(forKey: "content") as! NSDictionary
        for list in contentDic {
            let key = list.key as! String
            let Value = list.value as! String
            
            let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblKey.font = UIFont.boldSystemFont(ofSize: 13)
            lblKey.text = key
            viewContentConfirmation.addSubview(lblKey)
            y += heightContent
            
            let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblValue.font = UIFont.systemFont(ofSize: 13)
            lblValue.text = Value
            viewContentConfirmation.addSubview(lblValue)
            y += heightContent + margin
        }
        
        let line = CALayer()
        line.frame = CGRect(x: padding, y: y, width: width - 2 * padding, height: 1)
        line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
        viewContentConfirmation.layer.addSublayer(line)
        
        y += margin
        
        let contentFooterDic = data.value(forKey: "footer") as! NSDictionary
        for list in contentFooterDic {
            let key = list.key as! String
            let Value = list.value as! String
            
            let lblKey = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblKey.font = UIFont.boldSystemFont(ofSize: 13)
            lblKey.text = key
            viewContentConfirmation.addSubview(lblKey)
            y += heightContent
            
            let lblValue = BaseLabel.init(frame: CGRect(x: padding, y: y, width: width - 2 * padding, height: heightContent))
            lblValue.font = UIFont.systemFont(ofSize: 13)
            lblValue.text = Value
            viewContentConfirmation.addSubview(lblValue)
            y += heightContent + margin
        }
        let height = y + margin
        self.constraintViewContent.constant = height
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonStatus()  {
        let vc = StatusTransferViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
    }
    
}
