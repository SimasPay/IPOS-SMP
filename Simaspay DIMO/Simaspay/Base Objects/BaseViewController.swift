//
//  BaseViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/21/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var lblTitle: BaseLabel!
    var btnBack: BaseButton!
    var ivBackground : UIImageView!
    
    func showBackgroundImage() {
        if (ivBackground == nil) {
            ivBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: DIMOUtility.screenSize().width, height: DIMOUtility.screenSize().height))
            ivBackground.image = UIImage(named: "background-image")
        }
        view.insertSubview(ivBackground, atIndex: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackgroundImage()
        // Do any additional setup after loading the view.
    }
    
    func showTitle(stringTitle : String) {
        if (lblTitle == nil) {
            lblTitle = BaseLabel();
            lblTitle.frame = CGRect(x: 0, y: 20, width:DIMOUtility.screenSize().width, height: 44)
            lblTitle.textAlignment = .Center
        }
        lblTitle.text = stringTitle;
        view.addSubview(lblTitle)
    }
    
    func showBackButton() {
        if (btnBack == nil) {
            btnBack = BaseButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
            btnBack.addTarget(self, action: #selector(BaseViewController.btnBackAction), forControlEvents: UIControlEvents.TouchUpInside)
            btnBack.setImage(UIImage(named: "btnBack"), forState: UIControlState.Normal)
        }
        view.addSubview(btnBack)
    }
    
    func btnBackAction() {
        navigationController?.popViewControllerAnimated(true)
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
