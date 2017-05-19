//
//  SuccesRegisterController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 5/18/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

class SuccesRegisterController: BaseViewController {
    
    @IBOutlet var btnOk: BaseButton!
    
    static func initWithOwnNib() -> SuccesRegisterController {
        let obj:SuccesRegisterController = SuccesRegisterController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnOk.updateButtonType1()
        self.btnOk.setTitle("OK", for: .normal)
    }
    
    //MARK: Programmatically UI
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func actionOk(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
        
    }
    
}

