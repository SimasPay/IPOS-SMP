//
//  ChangeMpinViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/24/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ChangeMpinViewController: BaseViewController {

    
    @IBOutlet var lblOldMpin: BaseLabel!
    @IBOutlet var lblNewMpin: BaseLabel!
    @IBOutlet var lblConfirmMpin: BaseLabel!
    @IBOutlet weak var tfOldMpin: BaseTextField!
    @IBOutlet weak var tfNewMpin: BaseTextField!
    @IBOutlet weak var tfConfirmMpin: BaseTextField!
    @IBOutlet var btnSaveMpin: BaseButton!
    
    
    static func initWithOwnNib() -> ChangeMpinViewController {
        let obj:ChangeMpinViewController = ChangeMpinViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("ChangeMPINTitle"))
        self.showBackButton()
        
        btnSaveMpin.updateButtonType1()
        btnSaveMpin.setTitle(getString("ChangeMPINButtonSaveMpin"), for: .normal)
        
        lblOldMpin.font = UIFont.boldSystemFont(ofSize: 13)
        lblNewMpin.font = lblOldMpin.font
        lblConfirmMpin.font = lblOldMpin.font
        
        lblOldMpin.text = getString("ChangeMPINLebelOldMpin")
        lblNewMpin.text = getString("ChangeMPINLebelNewMpin")
        lblConfirmMpin.text = getString("ChangeMPINLebelConfirmNewMpin")
        
        tfNewMpin.addInset()
        tfOldMpin.addInset()
        tfConfirmMpin.addInset()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action button
    @IBAction func actionBtnSave(_ sender: AnyObject) {
        let vc = StatusTransferViewController.initWithOwnNib()
        let data = [
            "title" : "Terima kasih",
            "content" : [],
            "footer" : [:]
        ] as [String : Any]

        vc.data = data as NSDictionary!
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
