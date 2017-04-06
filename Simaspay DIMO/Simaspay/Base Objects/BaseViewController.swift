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
    var arrayTextFields : NSMutableArray!
    var toolbar : UIToolbar!
    static var lastObjectForKeyboardDetector : UIView!
    static var keyboardSize : CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        showBackgroundImage()
        
        if (toolbar == nil) {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            numberToolbar.barStyle = UIBarStyle.default
            numberToolbar.items = [
                UIBarButtonItem(title: " Prev ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.btnPrevAction)),
                UIBarButtonItem(title: " Next ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.btnNextAction)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.btnDoneAction))]
            numberToolbar.sizeToFit()
            toolbar = numberToolbar
        }
        
        arrayTextFields = []
        getAllFields(obj: self.view)
        if (arrayTextFields.count > 0) {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        BaseViewController.lastObjectForKeyboardDetector = nil
    }

    //MARK: Show background image
    func showBackgroundImage() {
        if (ivBackground == nil) {
            ivBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: DIMOUtility.screenSize().width, height: DIMOUtility.screenSize().height))
            ivBackground.image = UIImage(named: "background-image")
        }
        view.insertSubview(ivBackground, at: 0)
    }
    
    //MARK: Show Title ViewController
    func showTitle(_ stringTitle : String, subMenu: Bool = true) {
        if (lblTitle == nil) {
            lblTitle = BaseLabel();
            lblTitle.frame = CGRect(x: 0, y: 20, width:DIMOUtility.screenSize().width, height: 44)
            lblTitle.textAlignment = .center
        }
        if (subMenu){
            lblTitle.textColor = UIColor.white
        }
        lblTitle.text = stringTitle
        view.addSubview(lblTitle)
    }
    
   //MARK: Show back Button
    func showBackButton(subMenu: Bool = true) {
        if (btnBack == nil) {
            if subMenu {
                btnBack = BaseButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
                btnBack.setImage(UIImage(named: "go_back_arrow"), for: UIControlState())
                btnBack.imageEdgeInsets = UIEdgeInsetsMake(14,14,14,14)
            } else {
                btnBack = BaseButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
                btnBack.setImage(UIImage(named: "btnBack"), for: UIControlState())
            }
            btnBack.addTarget(self, action: #selector(BaseViewController.btnBackAction), for: UIControlEvents.touchUpInside)
        }
        view.addSubview(btnBack)
    }
    
    //MARK: Action back Button
    func btnBackAction() {
        if let vc = navigationController?.popViewController(animated: true) {
            DLog("\(vc)")
        }
    }
    
    //MARK: Action for next prev button textfield
    func btnPrevAction() {
        var last : UITextField!
        for item in arrayTextFields {
            if (item as! UITextField).isFirstResponder && last != nil {
                (last as UITextField).becomeFirstResponder()
                break
            }
            last = item as! UITextField
        }
    }
    
    func btnNextAction() {
        var isFirstResponder = false
        for item in arrayTextFields {
            if isFirstResponder {
                (item as! UITextField).becomeFirstResponder()
                break
            }
            if (item as! UITextField).isFirstResponder {
                isFirstResponder = true
            }
        }
    }
    
    func btnDoneAction() {
        dismissKeyboard()
        view.endEditing(true)
        for item in arrayTextFields {
            (item as! UITextField).resignFirstResponder()
        }
    }
    
    func getAllFields(obj : UIView) {
        for item in obj.subviews {
            if (item.subviews.count > 0) {
                getAllFields(obj: item)
            } else {
                if item.isKind(of: UITextField.self) {
                    let tf = item as! UITextField
                    if tf.isEnabled {
                        arrayTextFields.add(item)
                        (item as! UITextField).inputAccessoryView = toolbar
                        (item as! UITextField).autocorrectionType = .no
                    }
                }
            }
        }
    }
    
    
    //MARK: Setting keyboard show and hide
    func keyboardWillShow(notification: NSNotification) {
        if (BaseViewController.keyboardSize == nil) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                BaseViewController.keyboardSize = keyboardSize.size
            }
        }
        
        if BaseViewController.lastObjectForKeyboardDetector != nil {
            updateUIWhenKeyboardShow()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func updateUIWhenKeyboardShow() {
        if let keyboardSize = BaseViewController.keyboardSize {
            let lastView = BaseViewController.lastObjectForKeyboardDetector.frame.origin.y + BaseViewController.lastObjectForKeyboardDetector.frame.size.height + 20
            let diff = UIScreen.main.bounds.size.height - lastView
            if diff < (keyboardSize.height) {
                self.view.frame.origin.y = -((keyboardSize.height) - diff)
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    //MARK: Status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent;
    }

  
}
