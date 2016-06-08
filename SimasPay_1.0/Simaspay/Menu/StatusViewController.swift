//
//  StatusViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

//
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 09/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class StatusViewController: UIViewController
{
    
    var confirmationScrollview: UIScrollView!
    
    var statusTitle : NSString!
    var transactionID : NSString!
    var simasPayOptionType:SimasPayOptionType!
    var confirmationTitlesArray: Array<AnyObject>!
    var confirmationValuesArray: Array<AnyObject>!
    
    var isFromChangePIN:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Status"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        confirmationScrollview = UIScrollView()
        confirmationScrollview.backgroundColor = UIColor.clearColor()
        confirmationScrollview.translatesAutoresizingMaskIntoConstraints=false
        confirmationScrollview.scrollEnabled = true
        self.view.addSubview(confirmationScrollview)
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["confirmationScrollview"] = confirmationScrollview
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[confirmationScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[confirmationScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        

        let confirmationView = UIView()
        confirmationView.backgroundColor = UIColor.whiteColor()
        confirmationView.translatesAutoresizingMaskIntoConstraints=false
        confirmationView.layer.cornerRadius = 5
        initialScrollViews["confirmationView"] = confirmationView
        confirmationScrollview.addSubview(confirmationView)
        
        
        //SimaspayUtility.setSimasPayUIviewStyle(confirmationView)
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("OK", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmationScrollview.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: #selector(StatusViewController.popToMainViewController(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        let width = self.view.frame.width-40
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[confirmationView(\(width))]-20-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
        
        
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(60)-[step1FormAcceptBtn]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
       
        confirmationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[confirmationView]-20-[step1FormAcceptBtn(50)]-\(30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let topMargin = 15
        let leftRightMargin = 20

        let image = UIImage(named: "img-greencheck-small")
        let successImageView = UIImageView()
        successImageView.image = image
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        confirmationView.addSubview(successImageView)
        initialScrollViews["successImageView"] = successImageView
    
        let titleLabel = UILabel()
        titleLabel.text = "\(statusTitle)"
        titleLabel.font = UIFont(name:"HelveticaNeue", size:16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.Center
        confirmationView.addSubview(titleLabel)
        initialScrollViews["titleLabel"] = titleLabel
        
        
        let leftRMargin = (self.view.frame.width-40-50)/2
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(leftRMargin))-[successImageView(50)]-(\(leftRMargin))-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[titleLabel]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
    
        let dottedLineView = SimasPayDottedLine()
        dottedLineView.translatesAutoresizingMaskIntoConstraints = false
        confirmationView.addSubview(dottedLineView)
        initialScrollViews["dottedLineView"] = dottedLineView

        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[dottedLineView]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        var vertical_constraints = "V:|-"
        
        if (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANKSINARMAS || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_LAKU_PANDAI  || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_UANGKU || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TARIK_TUNAI || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN)
        {
            
            let transactionIDLabel = UILabel()
            transactionIDLabel.text = "ID Transaksi: \(self.transactionID)"
            transactionIDLabel.font = UIFont(name:"HelveticaNeue", size:14)
            transactionIDLabel.translatesAutoresizingMaskIntoConstraints = false
            transactionIDLabel.textAlignment = NSTextAlignment.Center
            confirmationView.addSubview(transactionIDLabel)
            initialScrollViews["transactionIDLabel"] = transactionIDLabel
            
            let string = transactionIDLabel.text! as NSString
            let attributedString = NSMutableAttributedString(string: string as String)
            let firstAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 13.0)!]
            attributedString.addAttributes(firstAttributes, range: string.rangeOfString("ID Transaksi:"))
            transactionIDLabel.attributedText = attributedString
            
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[transactionIDLabel]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
            
            vertical_constraints += "\(topMargin)-[successImageView(50)]-20-[titleLabel(21)]-5-[transactionIDLabel(21)]-20-[dottedLineView(2)]-20-"
            
        }else if(self.isFromChangePIN == true){
            vertical_constraints += "\(topMargin)-[successImageView(50)]-20-[titleLabel(21)]-20-"
        }else{
            vertical_constraints += "\(topMargin)-[successImageView(50)]-20-[titleLabel(21)]-20-[dottedLineView(2)]-20-"
        }
        
        
        for i in 1...confirmationTitlesArray.count {
            
            let confirmationTitleLabel = UILabel()
            confirmationTitleLabel.text = "\(confirmationTitlesArray[i-1])"
            confirmationTitleLabel.font = UIFont(name:"Helvetica", size:12.5)
            confirmationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmationView.addSubview(confirmationTitleLabel)
            initialScrollViews["confirmationTitleLabel\(i)"] = confirmationTitleLabel
            
            let confirmationValueLabel = UILabel()
            confirmationValueLabel.text = "\(confirmationValuesArray[i-1])"
            confirmationValueLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
            confirmationValueLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmationView.addSubview(confirmationValueLabel)
            initialScrollViews["confirmationValueLabel\(i)"] = confirmationValueLabel

            vertical_constraints  += "[confirmationTitleLabel\(i)(21)][confirmationValueLabel\(i)(21)]-10-"
            
            if( i == confirmationTitlesArray.count-1 &&  (self.simasPayOptionType == SimasPayOptionType.SIMASPAY_TRANSFER_BANK_LAIN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBELIAN || self.simasPayOptionType == SimasPayOptionType.SIMASPAY_PEMBAYARAN))
                {
                    let dottedLineView = SimasPayDottedLine()
                    dottedLineView.translatesAutoresizingMaskIntoConstraints = false
                    confirmationView.addSubview(dottedLineView)
                    initialScrollViews["dottedLineView2"] = dottedLineView
                    
                    confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[dottedLineView2]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
                    
                    vertical_constraints  += "[dottedLineView2(2)]-10-"
                }
 
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[confirmationTitleLabel\(i)]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
            
            confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftRightMargin)-[confirmationValueLabel\(i)]-\(leftRightMargin)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: initialScrollViews))
            
        }

        vertical_constraints += "|"
        confirmationView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        UINavigationBar.appearance().tintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    

    @IBAction func popToMainViewController(sender: AnyObject) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for viewController:UIViewController in viewControllers{
                if(viewController.isKindOfClass(SubMenuViewController) == true) {
                    self.navigationController?.navigationBarHidden = true
                    self.navigationController?.popToViewController(viewController as! SubMenuViewController, animated: true)
                    break;
                }
        }
        
        for viewController:UIViewController in viewControllers{
                if(viewController.isKindOfClass(MainMenuViewController) == true) {
                    self.navigationController?.navigationBarHidden = true
                    self.navigationController?.popToViewController(viewController as! MainMenuViewController, animated: true)
                    break;
                }
        }
        
    }
}