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
        view.insertSubview(ivBackground, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        showBackgroundImage()
        
        // tap to dismiss
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showTitle(_ stringTitle : String) {
        if (lblTitle == nil) {
            lblTitle = BaseLabel();
            lblTitle.frame = CGRect(x: 0, y: 20, width:DIMOUtility.screenSize().width, height: 44)
            lblTitle.textAlignment = .center
        }
        lblTitle.text = stringTitle;
        view.addSubview(lblTitle)
    }
    
    func showBackButton() {
        if (btnBack == nil) {
            btnBack = BaseButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
            btnBack.addTarget(self, action: #selector(BaseViewController.btnBackAction), for: UIControlEvents.touchUpInside)
            btnBack.setImage(UIImage(named: "btnBack"), for: UIControlState())
        }
        view.addSubview(btnBack)
    }
    
    func btnBackAction() {
        navigationController?.popViewController(animated: true)
    }

    func animatedFadeIn() {
        let transition:CATransition = CATransition()
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        navigationController!.view.layer.add(transition, forKey: kCATransition)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent;
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
