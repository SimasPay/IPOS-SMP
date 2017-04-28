//
//  SuccesTransferController.swift
//  Simaspay
//
//  Created by Dimo on 4/17/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

class SuccesTransferController: BaseViewController {

    @IBOutlet weak var viewNavigation: UIView!
    
    @IBOutlet weak var succesTransaction: BaseLabel!
    @IBOutlet weak var scrollViewArea: UIScrollView!
    @IBOutlet weak var transactionId: BaseLabel!
    @IBOutlet var btnOk: BaseButton!
    @IBOutlet var viewContentConfirmation: UIView!
    @IBOutlet var constraintViewContent: NSLayoutConstraint!
    
    //Dictionary for show data registration
    var data: NSDictionary!
    var idTran: String = ""
    //Value to set background navigation
    var useNavigation: Bool = true
    
    
    static func initWithOwnNib() -> SuccesTransferController {
        let obj:SuccesTransferController = SuccesTransferController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!useNavigation) {
            self.viewNavigation.backgroundColor = UIColor.clear
        }
        self.showTitle("Status")
        
        self.view.backgroundColor = UIColor.init(hexString: color_background)
        self.succesTransaction.font = UIFont.boldSystemFont(ofSize: 15)
        self.transactionId.font = UIFont.systemFont(ofSize: 13)
        
        let myString:NSString = "ID Transaksi: " + idTran as NSString
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: myString as String)
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:13))
    
        
        transactionId.attributedText = myMutableString
        
        DLog("\(data)")
        
        self.scrollViewArea.layer.cornerRadius = 5.0;
        self.scrollViewArea.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.scrollViewArea.layer.borderWidth = 0.5
        self.scrollViewArea.clipsToBounds = true;
        
        self.btnOk.updateButtonType1()
        self.btnOk.setTitle("OK", for: .normal)
    }
    
    //MARK: Programmatically UI
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let padding:CGFloat = 16
        let sizeRect = UIScreen.main.applicationFrame
        let width    = sizeRect.size.width - 2 * 25
        let heightContent:CGFloat = 15
        let margin:CGFloat = 10
        var y:CGFloat = 16
        
        let arrayContent = data.value(forKey: "content")
        for content in arrayContent as! Array<[String : String]> {
            for list in content {
                let key = list.key
                let Value = list.value
               
                if (key != "-") {
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
               
            }
        }
        
        if let contentFooterDica = data.value(forKey: "footer") {
            let contentFooterDic = contentFooterDica as! NSDictionary
            if contentFooterDic.allKeys.count != 0 {
                let line = CALayer()
                line.frame = CGRect(x: 0, y: y, width: width - 2 * padding, height: 1)
                line.backgroundColor = UIColor.init(hexString: color_line_gray).cgColor
                viewContentConfirmation.layer.addSublayer(line)
                
                y += margin
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
            }
        }
        let height = y + margin
        self.constraintViewContent.constant = height
    }
    
    
    @IBAction func actionOk(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if(vc.isKind(of: HomeViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            } else if (vc.isKind(of: RegisterEMoneyViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            }
        }
//            self.navigationController?.popToRootViewController(animated: true)
//            return

    }
    
}
