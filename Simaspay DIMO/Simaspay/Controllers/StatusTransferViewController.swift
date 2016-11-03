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
    @IBOutlet weak var lineStatus: UIView!
    @IBOutlet weak var constraintViewMainFrameHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintViewContentHeight: NSLayoutConstraint!
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

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let padding:CGFloat = 16
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width - 2 * 25
        let heightContent:CGFloat = 15
        let margin:CGFloat = 10
        var y:CGFloat = 16
        
        
        let arrayContent = data.value(forKey: "content") as! [[String:String]]
        if arrayContent.count == 0 {
            lblIdStatus.isHidden = true
            lineStatus.isHidden =  true
            constraintViewContentHeight.constant = 0
            constraintViewMainFrameHeight.constant = 120 
            return
        }
        
        for content in arrayContent {
            for list in content {
            let key = list.key
            let Value = list.value 
            
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
        }
        
        if let contentFooterDica = data.value(forKey: "footer") {
            let contentFooterDic = contentFooterDica as! NSDictionary
            if contentFooterDic.allKeys.count != 0 {
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
          }
        }
        self.constraintViewContentHeight.constant = y
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
       @IBAction func actionOkButton(_ sender: AnyObject) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: HomeViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            }
        }
        
        self.navigationController!.popToRootViewController(animated: true)
    }

}
