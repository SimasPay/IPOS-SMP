//
//  ContactUSViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ContactUSViewController: BaseViewController {
    @IBOutlet var viewMainFrame: UIView!

    @IBOutlet var lblTitleTlp: BaseLabel!
    @IBOutlet var lblTitleEmail: BaseLabel!
    @IBOutlet var lblTitleWeb: BaseLabel!
    
    @IBOutlet var lblFirstTlp: BaseLabel!
    @IBOutlet var lblSecondTlp: BaseLabel!
    @IBOutlet var lblEmail: BaseLabel!
    @IBOutlet var lblWeb: BaseLabel!
     var contactUsInfo = NSDictionary()
    
    
    static func initWithOwnNib() -> ContactUSViewController {
        let obj:ContactUSViewController = ContactUSViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitle(getString("ContactUsTitle"))
        self.showBackButton()
        
        self.viewMainFrame.layer.cornerRadius = 5.0;
        self.viewMainFrame.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewMainFrame.layer.borderWidth = 0.5
        self.viewMainFrame.clipsToBounds = true;
        
        
        self.lblTitleTlp.text = "Bank Sinarmas Care"
        self.lblTitleTlp.font = UIFont .boldSystemFont(ofSize: 13)
        self.lblTitleEmail.text = "E-mail"
        self.lblTitleEmail.font = self.lblTitleTlp.font
        self.lblTitleWeb.text = "Website"
        self.lblTitleWeb.font = self.lblTitleTlp.font
        
        self.lblFirstTlp.font = UIFont.boldSystemFont(ofSize: 16)
        self.lblSecondTlp.font = self.lblFirstTlp.font
        self.lblEmail.font = self.lblFirstTlp.font
        self.lblWeb.font = self.lblFirstTlp.font
        
        DLog( "\(contactUsInfo)")
        let contactUsDic = contactUsInfo.value(forKey: "contactus") as! NSDictionary
        
        self.lblFirstTlp.text = contactUsDic.value(forKey: "mobilenumber_1") as? String
        self.lblSecondTlp.text = contactUsDic.value(forKey: "mobilenumber_2") as? String
        self.lblEmail.text = contactUsDic.value(forKey: "emailid") as? String
        self.lblWeb.text = contactUsDic.value(forKey: "website") as? String

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.lblEmail.addUnderline()
        self.lblWeb.addUnderline()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
