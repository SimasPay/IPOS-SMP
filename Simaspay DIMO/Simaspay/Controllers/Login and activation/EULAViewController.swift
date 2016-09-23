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
        lblTitle.font = UIFont.boldSystemFontOfSize(20)
        
        btnAgree.updateButtonType1()
        btnAgree.setTitle(getString("EulaButtonAgree"), forState: .Normal)
        btnDisagree.updateButtonType1()
        btnDisagree.backgroundColor = UIColor.init(hexString:color_btn_gray2)
        btnDisagree.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnDisagree.setTitle(getString("EulaButtonDisagree"), forState: .Normal)
        viewFrame.backgroundColor = UIColor.whiteColor()
        viewFrame.updateViewRoundedWithShadow()
        
        let padding:CGFloat = 12.0
        let textView = UITextView()
        textView.frame = CGRectMake(padding, 0 , viewFrame.bounds.width - (2 * padding) , viewFrame.bounds.height)
        textView.text = getString("EulaContent")
        textView.editable = false
        viewFrame.addSubview(textView)
        
        
        
        
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
