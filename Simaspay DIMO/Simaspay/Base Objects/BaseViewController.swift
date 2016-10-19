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
    static var lastObjectForKeyboardDetector : UIView!
    static var arrayTextFields : NSMutableArray!
    static var toolbar : UIToolbar!
    static var keyboardSize : CGSize!
    
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
        
        BaseViewController.arrayTextFields = []
        getAllFields(obj: self.view)
        if (BaseViewController.arrayTextFields.count > 0) {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        }
        // Do any additional setup after loading the view.
    }
    
    func btnPrevAction() {
        var last : UITextField!
        for item in BaseViewController.arrayTextFields {
            if (item as! UITextField).isFirstResponder && last != nil {
                (last as UITextField).becomeFirstResponder()
                break
            }
            last = item as! UITextField
        }
    }
    
    func btnNextAction() {
        var isFirstResponder = false
        for item in BaseViewController.arrayTextFields {
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
        for item in BaseViewController.arrayTextFields {
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
                        BaseViewController.arrayTextFields.add(item)
                        (item as! UITextField).inputAccessoryView = BaseViewController.toolbar
                        (item as! UITextField).autocorrectionType = .no
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        BaseViewController.arrayTextFields = []
        getAllFields(obj: self.view)
        if (BaseViewController.toolbar == nil) {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            numberToolbar.barStyle = UIBarStyle.default
            numberToolbar.items = [
                UIBarButtonItem(title: " Prev ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.btnPrevAction)),
                UIBarButtonItem(title: " Next ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.btnNextAction)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.btnDoneAction))]
            numberToolbar.sizeToFit()
            BaseViewController.toolbar = numberToolbar
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        BaseViewController.arrayTextFields = []
        BaseViewController.lastObjectForKeyboardDetector = nil
    }
    
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
        if let vc = navigationController?.popViewController(animated: true) {
            DLog("\(vc)")
        }
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
