//
//  EULAViewController.swift
//  Simaspay
//
//  Created by Kendy Susantho on 9/22/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class EULAViewController: BaseViewController {

    @IBOutlet var labelTitle: BaseLabel!
    @IBOutlet var btnDisagree: BaseButton!
    @IBOutlet var btnAgree: BaseButton!
    @IBOutlet var viewFrame: UIView!
 
    static func initWithOwnNib() -> EULAViewController {
        let obj:EULAViewController = EULAViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = "Syarat dan Ketentuan"
        lblTitle.font = UIFont.boldSystemFont(ofSize: 19)
        
        btnAgree.updateButtonType1()
        btnAgree.setTitle(getString("EulaButtonAgree"), for: UIControlState())
        btnDisagree.updateButtonType3()
        btnDisagree.setTitle(getString("EulaButtonDisagree"), for: UIControlState())
        
        
        viewFrame.backgroundColor = UIColor.white
        viewFrame.updateViewRoundedWithShadow()
        let padding:CGFloat = 12.0
        let textView = UITextView()
        textView.frame = CGRect(x: padding, y: 0 , width: viewFrame.bounds.width - (2 * padding) , height: viewFrame.bounds.height)
        textView.text = getString("EulaContent")
        textView.isEditable = false
        viewFrame.addSubview(textView)
        
        btnAgree.addTarget(self, action: #selector(EULAViewController.buttonClick) , for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func buttonClick()  {
        let vc = ActivationViewController.initWithOwnNib()
        self.navigationController?.pushViewController(vc, animated: false)
        self.animatedFadeIn()
//        self.navigationController?.popViewControllerAnimated(false)
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
