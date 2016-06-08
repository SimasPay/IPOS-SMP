//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class CheckBalanceViewController: UIViewController
{
    var cashinScrollview: UIScrollView!
    var transactionTime : NSString!
    var transactionDate : NSString!
    var balanceAmount : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Info Saldo"
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: 0x404041)]
        
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        cashinScrollview = UIScrollView()
        cashinScrollview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(cashinScrollview)
        
        
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["cashinScrollview"] = cashinScrollview
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        // Transanction Time Format   070316145959
        
    /*    let sourceTransactonDate = self.transactionDate;
        var formattedDate  = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDateTime = dateFormatter.dateFromString(sourceTransactonDate as String)
        dateFormatter.dateFormat = "dd/MM/yy"
        formattedDate = dateFormatter.stringFromDate(formattedDateTime!) */
        
        
        
        let contentView = UIView()
        cashinScrollview.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        initialScrollViews["contentView"] = contentView
        
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(==cashinScrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let dateLabel = UILabel(frame: CGRectMake(0,0, self.view.frame.width, 40))
        dateLabel.text = "Tanggal: \(self.transactionDate)"
        dateLabel.font = UIFont(name:"HelveticaNeue-Light", size:15)
        dateLabel.textColor = UIColor.blackColor()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .Left
        contentView.addSubview(dateLabel)
        initialScrollViews["dateLabel"] = dateLabel
        
        let string = dateLabel.text! as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        let firstAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 14.0)!]
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString("Tanggal:"))
        dateLabel.attributedText = attributedString
        
        let timeLabel = UILabel(frame: CGRectMake(0,0, self.view.frame.width, 40))
        timeLabel.text = "Jam: \(self.transactionTime)"
        timeLabel.font = UIFont(name:"HelveticaNeue-Light", size:15)
        timeLabel.textColor = UIColor.blackColor()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .Right
        contentView.addSubview(timeLabel)
        initialScrollViews["timeLabel"] = timeLabel
        
        let string1 = timeLabel.text! as NSString
        let attributedString1 = NSMutableAttributedString(string: string1 as String)
        let firstAttributes1 = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 14.0)!]
        attributedString1.addAttributes(firstAttributes1, range: string1.rangeOfString("Jam:"))
        timeLabel.attributedText = attributedString1
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(25)-[dateLabel]-0-[timeLabel]-\(25)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(30)-[dateLabel]", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(30)-[timeLabel]", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))

        let balanceContentView = UIView()
        balanceContentView.backgroundColor = UIColor.whiteColor()
        balanceContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(balanceContentView)
        initialScrollViews["balanceContentView"] = balanceContentView
        
        balanceContentView.layer.cornerRadius = 6
        balanceContentView.layer.borderWidth = 0.5
        balanceContentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(25)-[balanceContentView]-\(25)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[dateLabel]-20-[balanceContentView(90)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let balanceContentTitle = UILabel(frame: CGRectMake(0,0, self.view.frame.width, 21))
        balanceContentTitle.text = "Saldo Anda saat ini adalah"
        balanceContentTitle.font = UIFont(name:"HelveticaNeue", size:15)
        balanceContentTitle.textColor = UIColor.blackColor()
        balanceContentTitle.translatesAutoresizingMaskIntoConstraints = false
        balanceContentTitle.textAlignment = .Center
        balanceContentView.addSubview(balanceContentTitle)
        initialScrollViews["balanceContentTitle"] = balanceContentTitle
        
        let balanceAmountLabel = UILabel(frame: CGRectMake(0,0, self.view.frame.width, 21))
        balanceAmountLabel.text = "Rp \(balanceAmount)"
        balanceAmountLabel.font = UIFont(name:"HelveticaNeue", size:30)
        balanceAmountLabel.textColor = UIColor.blackColor()
        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceAmountLabel.textAlignment = .Center
        balanceContentView.addSubview(balanceAmountLabel)
        initialScrollViews["balanceAmountLabel"] = balanceAmountLabel
        
     
        balanceContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(0)-[balanceContentTitle]-\(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        balanceContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(0)-[balanceAmountLabel]-\(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        balanceContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[balanceContentTitle(21)][balanceAmountLabel(40)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
    }
    
    
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hide Viewcontroller Navigationcontroller
        //SimaspayUtility.clearNavigationBarcolor(self.navigationController!)  DBDBDB
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
        let backButtonItem = UIBarButtonItem(customView: SimaspayUtility.getSimasPayBackButton(self))
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
   
}