//
//  ConfirmationViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/4/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController {
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewContentConfirmation: UIView!
    @IBOutlet var btnTrue: BaseButton!
    @IBOutlet var btnFalse: BaseButton!

    static func initWithOwnNib() -> ConfirmationViewController {
        let obj:ConfirmationViewController = ConfirmationViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Konfirmasi")
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)

        
        self.viewContentConfirmation.layer.cornerRadius = 5.0;
        self.viewContentConfirmation.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        self.viewContentConfirmation.layer.borderWidth = 0.5
        self.viewContentConfirmation.clipsToBounds = true;
        
        
        self.btnTrue.updateButtonType1()
        self.btnTrue.setTitle("Benar", for: .normal)
        self.btnFalse.updateButtonType3()
        self.btnFalse.setTitle("Salah", for: .normal)
        btnFalse.addTarget(self, action: #selector(ConfirmationViewController.buttonStatus) , for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonStatus()  {
        let vc = StatusTransferViewController.initWithOwnNib()
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
