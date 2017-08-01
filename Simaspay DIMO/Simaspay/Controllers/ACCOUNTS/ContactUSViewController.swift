//
//  ContactUSViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit


class ContactUSViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    var contactUsInfo = NSDictionary()
    var heightForCell = 40 as CGFloat
    let padding : CGFloat = 20
    
    static func initWithOwnNib() -> ContactUSViewController {
        let obj:ContactUSViewController = ContactUSViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitle(getString("ContactUsTitle"), subMenu: false)
        self.showBackButton(subMenu: false)
        
        tableView.backgroundColor = UIColor.white
        tableView.layer.cornerRadius = 5
        // tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        tableView.clipsToBounds = true;
        tableView.isScrollEnabled = false;
        scrollView.backgroundColor = UIColor.init(hexString: color_background)
        let timer = SimasAPIManager.staticTimer()
        timer?.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 3
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
       return heightForCell - 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForCell
    }
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = ContactUsCell(style: .default, reuseIdentifier: "contactus")
        temp.selectionStyle = .gray
        
        let lblcontent = UILabel(frame: CGRect(x: padding + 5, y: 5, width: tableView.frame.size.width - (padding * 2), height: heightForCell))
        lblcontent.font = UIFont.boldSystemFont(ofSize: 16)
        // let contactInfoSting = contactUsInfo.value(forKey: "contactus") as! NSDictionary
        let size = 20 as CGFloat
        let imgIcon = UIImageView(frame: CGRect(x: lblcontent.frame.size.width , y: ((heightForCell - size) / 2) + 5 , width: size, height: size))
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                lblcontent.text = contactUsInfo.value(forKey: "mobilenumber_1") as! String?
            } else {
                lblcontent.text = contactUsInfo.value(forKey: "mobilenumber_2") as! String?
            }
            imgIcon.image = UIImage.init(named: "ic_phone")
            temp.addSubview(imgIcon)
            temp.urlAction = "tel://\(NSString(string: (lblcontent.text?.replacingOccurrences(of: " ", with: ""))!))"
        } else if indexPath.section == 1 {
            let imgIconMail = UIImageView(frame: CGRect(x: lblcontent.frame.size.width , y: ((heightForCell - size) / 2) + 5 , width: size, height: size - 3))
            imgIconMail.image = UIImage.init(named: "ic_mail")
            temp.addSubview(imgIconMail)
            lblcontent.text = contactUsInfo.value(forKey: "emailid") as! String?
            temp.urlAction = "mailto://\(NSString(string: lblcontent.text!))"
        } else {
            imgIcon.image = UIImage.init(named: "ic_web")
            temp.addSubview(imgIcon)
            lblcontent.text = contactUsInfo.value(forKey: "website") as! String?
            temp.urlAction = "http://\(NSString(string: lblcontent.text!))"
        }
        
        if indexPath.section < 2 {
            temp.addUnderline(color: UIColor.init(hexString: color_border), coordinateX: padding)
        }
        
        temp.contentView.insertSubview(lblcontent, at: 0)
        
        return temp
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerLabel = UILabel(frame: CGRect(x: padding, y: 15, width: tableView.frame.size.width, height: heightForCell - 10))
       headerLabel.font = UIFont.systemFont(ofSize: 16)
        if section == 0 {
            headerLabel.text = "Bank Sinarmas Care"
        } else if section == 1{
            headerLabel.text = "E-mail"
        } else {
            headerLabel.text = "Website"
        }
        
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
}

//MARK: Table view cell
class ContactUsCell: UITableViewCell {
    var urlAction : String = ""
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            DLog("selected : \(urlAction)")
            if let url = NSURL(string: urlAction) {
                var string = urlAction
                var strOkBtn = "Call"
                string = string.replacingOccurrences(of: "://", with: " : ")
                if (!string.contains("tel://")) {
                    strOkBtn = "OK"
                }
                
                SimasAlertView.showPrompt(withMessage: string, okTitle: strOkBtn, complete: { (index, alertview) in
                    if index != 0 {
                        UIApplication.shared.openURL(url as URL)
                    }
                })
            }
            
        }
    }
}
