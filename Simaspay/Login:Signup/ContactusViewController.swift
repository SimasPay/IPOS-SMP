//
//  ContactusViewController.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 29/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate {
    
    var contactUsDictonary:NSDictionary!
    
    var emaild:String!
    var mobilenumber1:String!
    var mobilenumber2:String!
    var website:String!
    
    @IBOutlet weak var contactusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Hubungi Kami"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        if let font = UIFont(name: "HelveticaNeue", size: 19) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        
    
        
        let backButtonItem = UIBarButtonItem(customView: SimaspayUtility.getSimasPayBackButton(self))
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        contactusTableView.layer.borderWidth = 1.0
        contactusTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        contactusTableView.layer.cornerRadius = 5
        contactusTableView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        contactusTableView.layer.shadowOpacity = 0.5
        contactusTableView.layer.shadowOffset = CGSizeZero
        contactusTableView.layer.shadowRadius = 1;
        
        self.emaild = self.contactUsDictonary.valueForKey("emailid") as? String
        self.mobilenumber1 = self.contactUsDictonary.valueForKey("mobilenumber_1") as? String
        self.mobilenumber2 = self.contactUsDictonary.valueForKey("mobilenumber_2") as? String
        self.website = self.contactUsDictonary.valueForKey("website") as? String
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        // Hide Viewcontroller Navigationcontroller
        SimaspayUtility.clearNavigationBarcolor(self.navigationController!)
        self.navigationController?.navigationBarHidden = false
        
    }
    
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {return 44}
        if indexPath.row == 1 ||  indexPath.row == 2
        {return 54}
        if indexPath.row == 3 || indexPath.row == 4
        {return 100}
        return 0
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell:ContactusCustomCell = ContactusCustomCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myContactusCell")
        
        // first create UIImageView
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRectMake(20, 40, 25, 25))
        
        
        if indexPath.row == 0
        {
            imageView.image = UIImage(named:"ic-phone")
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("image1Tapped:"))
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            
            cell.textLabel!.text = "Bank Sinarmas Care"
            //cell.detailTextLabel!.text = "1500 153"
            // then set it as cellAccessoryType
            //cell.accessoryView = imageView
            
            cell.textLabel!.font = UIFont(name:"HelveticaNeue-Medium", size:13)
           // cell.detailTextLabel!.font = UIFont(name:"HelveticaNeue", size:16)
            
           // cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0);
            let indent_large_enought_to_hidden:CGFloat = 10000
            cell.separatorInset = UIEdgeInsetsMake(0, indent_large_enought_to_hidden, 0, 0) // indent large engough for separator(including cell' content) to hidden separator
            cell.indentationWidth = indent_large_enought_to_hidden * -1 // adjust the cell's content to show normally
            cell.indentationLevel = 1
        }
        
        if indexPath.row == 1
        {
            imageView.image = UIImage(named:"ic-phone")
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("image1Tapped:"))
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            cell.textLabel!.text = self.mobilenumber1
            cell.accessoryView = imageView
            cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:16)
        }
        
        if indexPath.row == 2
        {
            imageView.image = UIImage(named:"ic-phone")
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("image2Tapped:"))
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            cell.textLabel!.text = self.mobilenumber2
            cell.accessoryView = imageView
            cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:16)
        }
        
        if indexPath.row == 3
        {
            cell.textLabel!.text = "E-mail"
            cell.detailTextLabel!.text = self.emaild
            cell.textLabel!.font = UIFont(name:"HelveticaNeue-Medium", size:13)
            cell.detailTextLabel!.font = UIFont(name:"HelveticaNeue", size:16.5)
        }
        
        if indexPath.row == 4
        {
            cell.textLabel!.text = "Website"
            cell.detailTextLabel!.text = self.website
            cell.textLabel!.font = UIFont(name:"HelveticaNeue-Medium", size:13)
            cell.detailTextLabel!.font = UIFont(name:"HelveticaNeue", size:16.5)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == 3
        {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        
        if indexPath.row == 4
        {
            UIApplication.sharedApplication().openURL(NSURL(string: self.website)!)
        }
    }
    
    func image1Tapped(img: UIImageView)
    {
        
        var mobileNumber1String =  self.mobilenumber1
        mobileNumber1String = mobileNumber1String.stringByReplacingOccurrencesOfString(" ", withString: "")
        if #available(iOS 8.0, *) {
            let alertView = UIAlertController(title: self.mobilenumber1, message: "", preferredStyle: .Alert)
            
            alertView.addAction(UIAlertAction(title: "Call", style: .Default, handler: { (alertAction) -> Void in
                // Your action
                if let url = NSURL(string: "tel://\(mobileNumber1String)") {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
            
            
        } else {
            // Fallback on earlier versions
            
            let alertView = UIAlertView(
                title:self.mobilenumber1,
                message:"",
                delegate:self,
                cancelButtonTitle:"Call",
                otherButtonTitles:"Cancel")
            
            alertView.show()
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("Button click: \(buttonIndex)")
        
        // Your action
        if let url = NSURL(string: "tel://\(alertView.title.stringByReplacingOccurrencesOfString(" " , withString: ""))") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    func image2Tapped(img: UIImageView)
    {
        var mobileNumber2String =  self.mobilenumber2
        mobileNumber2String = mobileNumber2String.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if #available(iOS 8.0, *) {
            let alertView = UIAlertController(title: self.mobilenumber2, message: "", preferredStyle: .Alert)
            
            alertView.addAction(UIAlertAction(title: "Call", style: .Default, handler: { (alertAction) -> Void in
                // Your action
                if let url = NSURL(string: "tel://\(mobileNumber2String)") {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
            
            
        } else {
            // Fallback on earlier versions
            
            let alertView = UIAlertView(
                title:self.mobilenumber2,
                message:"",
                delegate:self,
                cancelButtonTitle:"Call",
                otherButtonTitles:"Cancel")
            
            alertView.show()
        }
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate Method

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([self.emaild])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
        // MARK: Redirect to Website
    
    
}