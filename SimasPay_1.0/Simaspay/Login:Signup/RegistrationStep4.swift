//
//  RegistrationStep4.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 28/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class RegistrationStep4: UIViewController{
    

    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        okButton.layer.cornerRadius = 5;
        okButton.layer.masksToBounds = true;
        
        
    }
    @IBAction func okButtonClicked(sender: AnyObject) {
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
}
