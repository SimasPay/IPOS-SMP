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
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = "Syarat dan Ketentuan"
        lblTitle.font = UIFont.boldSystemFontOfSize(19)
        
        btnAgree.updateButtonType1()
        btnAgree.setTitle(getString("EulaButtonAgree"), forState: .Normal)
        btnDisagree.updateButtonType3()
        btnDisagree.setTitle(getString("EulaButtonDisagree"), forState: .Normal)
        
        
        viewFrame.backgroundColor = UIColor.whiteColor()
        viewFrame.updateViewRoundedWithShadow()
        let padding:CGFloat = 12.0
        let textView = UITextView()
        textView.frame = CGRectMake(padding, 0 , viewFrame.bounds.width - (2 * padding) , viewFrame.bounds.height)
        textView.text = getString("EulaContent")
        textView.editable = false
        viewFrame.addSubview(textView)
        
        btnAgree.addTarget(self, action:,#selector(EULAViewController.buttonClick) , forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
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
