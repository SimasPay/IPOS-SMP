//
//  HomeViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit
enum AccountType: Int {
    case accountTypeRegular = 0
    case accountTypeLakuPandai
    case accountTypeEMoneyKYC
    case accountTypeEMoneyNonKYC
}

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    var accountType : AccountType!
    var arrayMenu: NSArray!
    
    @IBOutlet var lblTypeHome: BaseLabel!
    @IBOutlet var lblUsername: BaseLabel!
    @IBOutlet var lblNoAccount: BaseLabel!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    static func initWithOwnNib() -> HomeViewController {
        let obj:HomeViewController = HomeViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    static func initWithAccountType(_ type: AccountType) -> HomeViewController {
        let vc = HomeViewController.initWithOwnNib()
        vc.accountType = type
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblTypeHome.font = UIFont.systemFont(ofSize: 11)
        lblTypeHome.textColor = UIColor.init(hexString: color_greyish_brown)
        lblTypeHome.text = "E-money"
        
        
        lblUsername.font = UIFont.boldSystemFont(ofSize: 18)
        lblUsername.textColor = lblTypeHome.textColor
        lblUsername.textAlignment = .center
        lblUsername.text = "Harriett Jordan"
    
        lblNoAccount.textColor = lblTypeHome.textColor
        lblNoAccount.font = lblTypeHome.font
        lblNoAccount.textAlignment = .center
        lblNoAccount.text = "08881234567"
        
        imgUser.layer.cornerRadius = 28
        imgUser.backgroundColor = UIColor.black
        imgUser.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        arrayMenu = [
            [
                "title" : "Daftar Transaksi",
                "icon" : "icon_Transaction",
                "action" : TransactionHistoryViewController.initWithOwnNib(),
                "disable" : false
            ],
            [
                "title" : "Transfer",
                "icon" : "icon_Transfer",
                "action" : ListTransferViewController.initWithOwnNib(),
                "disable" : self.accountType == AccountType.accountTypeEMoneyNonKYC
                            ? true : false
                
            ],
            [
                "title" : "Pembelian",
                "icon" : "icon_Payment",
                "action" : PaymentPurchaseViewController.initWithOwnNib(isPurchased: true),
                "disable" : false
            ],
            [
                "title" : "Pembayaran",
                "icon" : "icon_Purchase",
                "action" : PaymentPurchaseViewController.initWithOwnNib(isPurchased: false),
                "disable" : false
            ],
            [
                "title" : "Pay by QR",
                "icon" : "icon_Paybyqr",
                "action" : TransactionHistoryViewController.initWithOwnNib(),
                "disable" : false
            ],
            [
                "title" : "Promo Pay by QR",
                "icon" : "icon_Promo",
                "action" : TransactionHistoryViewController.initWithOwnNib(),
                "disable" : false
            ],
            [
                "title" : "Tarik Tunai",
                "icon" : "icon_drawal",
                "action" : TransactionHistoryViewController.initWithOwnNib(),
                "disable" : self.accountType == AccountType.accountTypeEMoneyNonKYC ? true : false
            ],
            [
                "title" : "Ganti mPIN",
                "icon" : "icon_Changempin",
                "action" : ChangeMpinViewController.initWithOwnNib(),
                "disable" : false
            ]



        ]
        
//        setupMenu()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayMenu.count
        ;
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        if (self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"disable") as! Bool {
            cell.alpha = 0.5
        } else {
            cell.alpha = 1
        }
        cell.backgroundColor = UIColor.white
        cell.updateIconRoundedWithShadow()

        
        let imgIcon = UIImageView(frame: CGRect(x: cell.frame.size.width/2 - 25 , y: cell.frame.size.height/2 - 35 , width: 50, height: 50))
        imgIcon.image = UIImage.init(named: "\(((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"icon") as! NSString) as String)")
        
        let lblIcon = BaseLabel(frame: CGRect(x: 0, y: imgIcon.frame.origin.y  + imgIcon.frame.size.width + 4 , width: cell.frame.size.width, height: 10))
        lblIcon.textAlignment = .center
        lblIcon.textColor = UIColor.black
        lblIcon.font = UIFont.systemFont(ofSize: 10)
        lblIcon.text = ((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"title") as! NSString) as String
        
        
        cell.addSubview(lblIcon)
        cell.addSubview(imgIcon)
            
        
        return cell
    }
 
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let sizeRect = UIScreen.main.applicationFrame
        let width    = ((sizeRect.size.width - 16 * 4) / 3)
        return CGSize(width: width, height: width)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if !((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"disable")  as! Bool) {
            DLog("\(((self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"title") as! NSString) as String)")
            let vc = (self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"action")
            self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
        } else {
            
        }
    }
  
    
  

    
    func setupMenu() {
        var column = 1
        var row = 1
        let size = 85
        let padding = 16
        let lblHeight = 21
        
        var width = size * 3 + padding * 2
        let height = size + padding + lblHeight
        if (arrayMenu.count >= 4) {
            row = 2;
            if (arrayMenu.count == 4) {
                column = 2;
                width = size * 2 + padding
            } else {
                column = 3;
            }
        } else {
            column = arrayMenu.count
            if (arrayMenu.count == 2) {
                width = size * 2 + padding
            }
        }
        
        
        let container = UIView()
        var y = 0
        for i in 0  ..< row  {
            for j in 0 ..< column {
                let index = i * column + j
                if (index < arrayMenu.count) {
                    let dict = arrayMenu[index]
                    var x = j * (size + padding)
                    y = i * (height + padding)
                    
                    if (arrayMenu.count == 5 && i == 1) {
                        // for 5 items
                        x += (size + padding) / 2
                    }
                    
                    let temp = UIView(frame: CGRect(x: x, y: y, width: size, height: height))
                    temp.backgroundColor = UIColor.black
                    
                    container.addSubview(temp)
                }
            }
        }
        y += height
        container.frame = CGRect(x: 0, y: 0, width: width, height: y)
        container.backgroundColor = UIColor.yellow
        container.center = view.center
        view.addSubview(container)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
