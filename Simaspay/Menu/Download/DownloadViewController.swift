//
//  CashinViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 10/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class DownloadViewController: UIViewController
{
    var cashinScrollview: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Mutasi"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        cashinScrollview = UIScrollView()
        cashinScrollview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(cashinScrollview)
        
        
        
        var initialScrollViews = [String: UIView]()
        initialScrollViews["cashinScrollview"] = cashinScrollview
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[cashinScrollview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        
        let contentView = UIView()
        cashinScrollview.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        initialScrollViews["contentView"] = contentView
        
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(==cashinScrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        cashinScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let topMargin = 20
        let nextFieldMArgin = 25
        let nextFieldLabelMargin = 37
        let checkBoxWH = 27
        
        
        let titleLabel = UILabel(frame: CGRectMake(0,0, self.view.frame.width, 40))
        titleLabel.text = "Silakan pilih periode transaksi \n yang ingin Anda lihat"
        titleLabel.font = UIFont(name:"HelveticaNeue", size:15)
        titleLabel.textColor = UIColor.downloadViewTitleColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(titleLabel)
        initialScrollViews["titleLabel"] = titleLabel
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(30)-[titleLabel]-\(30)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: initialScrollViews))
        
        
        let optionCheckBox1:UIButton = self.getOptionCheckBox()
        optionCheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        contentView.addSubview(optionCheckBox1)
        initialScrollViews["optionCheckBox1"] = optionCheckBox1
        
        let optionLabel1 = self.getOptionLabel()
        optionLabel1.text = "Bulan ini"
        contentView.addSubview(optionLabel1)
        initialScrollViews["optionLabel1"] = optionLabel1
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox1(\(checkBoxWH))]-10-[optionLabel1]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        
        let optionCheckBox2:UIButton = self.getOptionCheckBox()
        optionCheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        contentView.addSubview(optionCheckBox2)
        initialScrollViews["optionCheckBox2"] = optionCheckBox2
        
        let optionLabel2 = self.getOptionLabel()
        optionLabel2.text = "Bulan lalu"
        contentView.addSubview(optionLabel2)
        initialScrollViews["optionLabel2"] = optionLabel2
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox2(\(checkBoxWH))]-10-[optionLabel2]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        let optionCheckBox3:UIButton = self.getOptionCheckBox()
        optionCheckBox3.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        contentView.addSubview(optionCheckBox3)
        initialScrollViews["optionCheckBox3"] = optionCheckBox3
        
        let optionLabel3 = self.getOptionLabel()
        optionLabel3.text = "2 bulan lalu"
        contentView.addSubview(optionLabel3)
        initialScrollViews["optionLabel3"] = optionLabel3
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox3(\(checkBoxWH))]-10-[optionLabel3]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))

        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(topMargin)-[titleLabel(42)]-50-[optionCheckBox1(\(checkBoxWH))]-\(nextFieldMArgin)-[optionCheckBox2(\(checkBoxWH))]-\(nextFieldMArgin)-[optionCheckBox3(\(checkBoxWH))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(topMargin)-[titleLabel(42)]-53-[optionLabel1]-\(nextFieldLabelMargin)-[optionLabel2]-\(nextFieldLabelMargin)-[optionLabel3]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        let optionCheckBox4:UIButton = self.getOptionCheckBox()
        optionCheckBox4.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        contentView.addSubview(optionCheckBox4)
        initialScrollViews["optionCheckBox4"] = optionCheckBox4
        
        
        let option4Label1 = self.getOptionLabel()
        option4Label1.text = "Periode dari"
        contentView.addSubview(option4Label1)
        initialScrollViews["option4Label1"] = option4Label1
        
        
        let option4TextField1 = self.getCustomTextField()
        contentView.addSubview(option4TextField1)
        initialScrollViews["option4TextField1"] = option4TextField1
        
        let mobilenumberImageView = UIImageView()
        mobilenumberImageView.frame = CGRect(x: 9, y: (option4TextField1.frame.height-20)/2, width: 20, height: 20)
        let phoneImage = UIImage(named: "ic-calendar")
        mobilenumberImageView.image = phoneImage
        
        let mobileNumberView = UIView(frame: CGRectMake(0, 0, 20+18, option4TextField1.frame.height))
        mobileNumberView.addSubview(mobilenumberImageView)
        option4TextField1.rightView = mobileNumberView
        option4TextField1.rightViewMode = UITextFieldViewMode.Always
        
        let mobileNumberView11 = UIView(frame: CGRectMake(0, 0, 10, option4TextField1.frame.height))
        option4TextField1.leftView = mobileNumberView11;
        option4TextField1.leftViewMode = UITextFieldViewMode.Always
        
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox4(\(checkBoxWH))]-10-[option4Label1]-[option4TextField1]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[optionCheckBox3]-\(nextFieldMArgin)-[optionCheckBox4(\(checkBoxWH))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[optionLabel3]-\(nextFieldLabelMargin-2)-[option4Label1]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[optionLabel3]-\(nextFieldLabelMargin-10)-[option4TextField1(35)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let option4Label2 = self.getOptionLabel()
        option4Label2.text = "Hingga"
        contentView.addSubview(option4Label2)
        initialScrollViews["option4Label2"] = option4Label2
        
        let option4TextField2 = self.getCustomTextField()
        contentView.addSubview(option4TextField2)
        initialScrollViews["option4TextField2"] = option4TextField2
        
        let mobilenumberImageView2 = UIImageView()
        mobilenumberImageView2.frame = CGRect(x: 9, y: (option4TextField2.frame.height-20)/2, width: 20, height: 20)
        let phoneImage2 = UIImage(named: "ic-calendar")
        mobilenumberImageView2.image = phoneImage2
    
        let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 20+18, option4TextField2.frame.height))
        mobileNumberView2.addSubview(mobilenumberImageView2);
        option4TextField2.rightView = mobileNumberView2
        option4TextField2.rightViewMode = UITextFieldViewMode.Always
        
        let mobileNumberView12 = UIView(frame: CGRectMake(0, 0, 10, option4TextField2.frame.height))
        option4TextField2.leftView = mobileNumberView12;
        option4TextField2.leftViewMode = UITextFieldViewMode.Always
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[optionCheckBox4(\(checkBoxWH))]-10-[option4Label2(==option4Label1)]-[option4TextField2]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[option4TextField1]-\(12)-[option4Label2]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[option4TextField1]-\(5)-[option4TextField2(35)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
        let step1FormAcceptBtn:UIButton = UIButton()
        step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
        step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
        step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
        step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        contentView.addSubview(step1FormAcceptBtn)
        step1FormAcceptBtn.addTarget(self, action: "cashInAcceptClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        initialScrollViews["step1FormAcceptBtn"] = step1FormAcceptBtn
        step1FormAcceptBtn.layer.cornerRadius = 5
        
        let buttonMargin = (self.view.frame.size.width-200)/2
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(buttonMargin)-[step1FormAcceptBtn]-\(buttonMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[option4TextField2]-50-[step1FormAcceptBtn(50)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        

        
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
        
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 15, 25)
        backButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "btn-back"), forState: UIControlState.Normal)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    @IBAction func cashInAcceptClicked(sender: UIButton)
    {

        let confirmationViewController = TransactionHistoryViewController()
        self.navigationController!.pushViewController(confirmationViewController, animated: true)
    }
    
    func getOptionLabel()->UILabel
    {
        let optionLabel1 = UILabel()
        optionLabel1.textColor = UIColor.blackColor()
        optionLabel1.font =  UIFont(name:"HelveticaNeue", size:14)
        optionLabel1.translatesAutoresizingMaskIntoConstraints = false
        optionLabel1.textAlignment = NSTextAlignment.Left
        
        return optionLabel1
    }
    
    func getOptionCheckBox()->UIButton
    {
        let optionCheckBox1:UIButton = UIButton()
        optionCheckBox1.backgroundColor = UIColor.clearColor()
        optionCheckBox1.translatesAutoresizingMaskIntoConstraints = false
        return optionCheckBox1
    }
    
    func getCustomTextField()->UITextField
    {
        let checkBoxTextField1 = UITextField(frame: CGRect.zero)
        checkBoxTextField1.backgroundColor = UIColor.whiteColor()
        checkBoxTextField1.enabled = true
        checkBoxTextField1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
        checkBoxTextField1.translatesAutoresizingMaskIntoConstraints = false
        checkBoxTextField1.borderStyle = .None
        checkBoxTextField1.layer.cornerRadius = 5
        checkBoxTextField1.text = "DD-MM-YYYY"
        
        return checkBoxTextField1
    }
}