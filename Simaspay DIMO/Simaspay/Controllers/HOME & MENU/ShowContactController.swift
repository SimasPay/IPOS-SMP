//
//  ShowContactController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 6/7/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import Foundation

class ShowContactController: BaseViewController {
    
    @IBOutlet weak var btnContactUs: BaseButton!
    @IBOutlet weak var btnActivation: BaseButton!
    @IBOutlet weak var btnLogin: BaseButton!
    
    static func initWithOwnNib() -> ShowContactController {
        let obj:ShowContactController = ShowContactController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
