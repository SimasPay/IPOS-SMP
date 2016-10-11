//
//  StatusTransferViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/4/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class StatusTransferViewController: BaseViewController {
    
    
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewContentStatus: UIView!
    @IBOutlet var btnOK: BaseButton!
    @IBOutlet var lblStatus: BaseLabel!
    @IBOutlet var lblIdStatus: BaseLabel!
    
    static func initWithOwnNib() -> StatusTransferViewController {
        let obj:StatusTransferViewController = StatusTransferViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Status")
        
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        self.viewContentStatus.layer.cornerRadius = 5.0;
        self.viewContentStatus.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewContentStatus.layer.borderWidth = 0.5
        self.viewContentStatus.clipsToBounds = true;
        self.lblStatus.font = UIFont.boldSystemFont(ofSize: 16)
        self.lblIdStatus.font = UIFont.boldSystemFont(ofSize: 13)
        self.lblStatus.text = "Transfer Berhasil!"
        self.lblIdStatus.text = "ID Transaksi: 123958"
        
        btnOK.updateButtonType1()
        btnOK.setTitle("OK", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonStatus()  {
        let vc = ConfirmationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
