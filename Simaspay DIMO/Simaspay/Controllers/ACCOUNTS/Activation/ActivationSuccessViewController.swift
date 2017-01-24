//
//  ActivationSuccessViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/23/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ActivationSuccessViewController: BaseViewController {
    
    @IBOutlet weak var lblTitleMessage: BaseLabel!
    @IBOutlet var lblInfoSuccess: BaseLabel!
    @IBOutlet var btnOK: BaseButton!
    
    var messageInfo: String!
    var TitleInfo: String!
    
    
    static func initWithMessageInfo(message: String, title: String) -> ActivationSuccessViewController {
        let obj:ActivationSuccessViewController = ActivationSuccessViewController.init(nibName: String(describing: self), bundle: nil)
        obj.messageInfo = message
        obj.TitleInfo = title
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        lblInfoSuccess.textAlignment = .center
        lblInfoSuccess.numberOfLines  = 3
        lblInfoSuccess.text = messageInfo as String
        
        lblTitleMessage.textAlignment = .center
        lblTitleMessage.text = TitleInfo
        
        btnOK.updateButtonType1()
        btnOK.setTitle(getString("ActivationButtonOk"), for: UIControlState())
        btnOK.addTarget(self, action: #selector(ActivationSuccessViewController.buttonClick) , for: .touchUpInside)
    }
    
    //MARK: action button OK
    func buttonClick()  {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            if (vc.isKind(of: LoginRegisterViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            }
        }
        self.navigationController!.popToRootViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
