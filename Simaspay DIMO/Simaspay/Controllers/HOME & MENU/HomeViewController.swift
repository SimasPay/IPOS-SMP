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
    case accountTypeEMoney
    
    case accountTypeAccount = 10
    case accountTypeTransfer
    case accountTypePayment
    case accountTypePurchase
}

class HomeViewController: BaseViewController {
    var accountType : AccountType!
    var arrayMenu: NSArray!
    
    static func initWithOwnNib() -> HomeViewController {
        let obj:HomeViewController = HomeViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    static func initWithAccountType(_ type: AccountType) -> HomeViewController {
        let vc = HomeViewController.initWithOwnNib()
        vc.accountType = type
        return vc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        arrayMenu = [
            [
                "title" : "title button 1",
                "icon" : "icon_1",
                "action" : HomeViewController.initWithAccountType(AccountType.accountTypeAccount)
            ],
            [
                "title" : "title button 2",
                "icon" : "icon_2",
                "action" : HomeViewController.initWithAccountType(AccountType.accountTypeTransfer)
            ],
            [
                "title" : "title button 2",
                "icon" : "icon_2",
                "action" : HomeViewController.initWithAccountType(AccountType.accountTypeTransfer)
            ],
            [
                "title" : "title button 2",
                "icon" : "icon_2",
                "action" : HomeViewController.initWithAccountType(AccountType.accountTypeTransfer)
            ],
            [
                "title" : "title button 2",
                "icon" : "icon_2",
                "action" : HomeViewController.initWithAccountType(AccountType.accountTypeTransfer)
            ]
        ]
        
        setupMenu()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
