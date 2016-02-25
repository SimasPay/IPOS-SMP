//
//  AgentRegistrationViewC.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 19/01/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation

import UIKit

class AgentRegistrationViewC: UIViewController,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{

    
     var regiterStep1ImageView: UIImageView!
     var regiterStep2ImageView: UIImageView!
     var regiterStep3ImageView: UIImageView!

    var agentRegistrationStep1Scrollview : UIScrollView!
    var agentRegistrationStep2Scrollview :  UIScrollView!
    var agentRegistrationStep3Scrollview :  UIScrollView!
    
    var agentRegistrationScrollview: UIScrollView!
    
    var step2ContentView : UIView!
    var step2ContentView2 : UIView!
    
    var step2Field9Label2:UILabel!
    
    var step2FormAcceptBtn:UIButton!
    
    var isStep1Activated:Bool = false
    var isStep2Activated:Bool = false
    var isStep3Activated:Bool = false
    
    var regiterStep1Button: UIButton!
    var regiterStep2Button: UIButton!
    var regiterStep3Button: UIButton!
    
    
    var step2Field9CheckBox1:UIButton!
    var step2Field9CheckBox2:UIButton!
    
    var step3SelectProof1:SimaspayDottedBorderButton!
    var step3SelectProof2:SimaspayDottedBorderButton!
    var step3SelectProof3:SimaspayDottedBorderButton!
    var selectedProofButton:SimaspayDottedBorderButton!
    
    var pickerViewData:NSArray!
    
    var step1DatePickerTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Buka Rekening"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        let titleView  = UIView()
        titleView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        agentRegistrationScrollview = UIScrollView()
        agentRegistrationScrollview.backgroundColor = UIColor.clearColor()
        agentRegistrationScrollview.translatesAutoresizingMaskIntoConstraints=false
        agentRegistrationScrollview.scrollEnabled = false
        agentRegistrationScrollview.pagingEnabled = false
        self.view.addSubview(agentRegistrationScrollview)
        
    
        let initialScrollViews = ["titleView":titleView,"agentRegistrationScrollview":agentRegistrationScrollview]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[agentRegistrationScrollview]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[titleView(50)][agentRegistrationScrollview]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        regiterStep1Button = UIButton()
        regiterStep2Button = UIButton()
        regiterStep3Button = UIButton()
        
        regiterStep1Button.titleLabel?.font =  UIFont(name:"HelveticaNeue-Light", size:14)!
        regiterStep2Button.titleLabel?.font =  UIFont(name:"HelveticaNeue-Light", size:14)!
        regiterStep3Button.titleLabel?.font =  UIFont(name:"HelveticaNeue-Light", size:14)!
    
        regiterStep1Button.setTitle("Langkah 1", forState: .Normal)
        regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
        regiterStep2Button.setTitle("Langkah 2", forState: .Normal)
        regiterStep2Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
        regiterStep3Button.setTitle("Langkah 3", forState: .Normal)
        regiterStep3Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
        
        regiterStep1Button.addTarget(self, action: "step1AcceptButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        regiterStep2Button.addTarget(self, action: "step2AcceptButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        regiterStep3Button.addTarget(self, action: "step3AcceptButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        regiterStep1Button.enabled = false
        regiterStep2Button.enabled = false
        regiterStep3Button.enabled = false
        
        regiterStep1Button.translatesAutoresizingMaskIntoConstraints = false
        regiterStep2Button.translatesAutoresizingMaskIntoConstraints = false
        regiterStep3Button.translatesAutoresizingMaskIntoConstraints = false
        
        
        let arrowImage = UIImage(named: "ic-arrow-right")
        regiterStep1Button.setImage(arrowImage, forState: UIControlState.Normal)
        regiterStep2Button.setImage(arrowImage, forState: UIControlState.Normal)
        
        regiterStep1Button.imageEdgeInsets = UIEdgeInsetsMake(16,95,16,0)
        regiterStep1Button.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,0)
        
        regiterStep2Button.imageEdgeInsets = UIEdgeInsetsMake(16,95,16,0)
        regiterStep2Button.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,0)
        
        titleView.addSubview(regiterStep1Button)
        titleView.addSubview(regiterStep2Button)
        titleView.addSubview(regiterStep3Button)
        
        let initialTitleViews =
        ["titleView":titleView,"regiterStep1Button":regiterStep1Button,"regiterStep2Button":regiterStep2Button,"regiterStep3Button":regiterStep3Button]
        
        titleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[regiterStep1Button]-0-[regiterStep2Button(==regiterStep1Button)]-0-[regiterStep3Button(==regiterStep1Button)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialTitleViews))
        
        titleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[regiterStep1Button(50)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialTitleViews))
        
        titleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[regiterStep2Button(==regiterStep1Button)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialTitleViews))
        
        titleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[regiterStep3Button(==regiterStep1Button)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialTitleViews))
        
        
        
        agentRegistrationStep1Scrollview = UIScrollView()
        agentRegistrationStep1Scrollview.translatesAutoresizingMaskIntoConstraints=false
        agentRegistrationScrollview.addSubview(agentRegistrationStep1Scrollview)
        
        agentRegistrationStep2Scrollview = UIScrollView()
        agentRegistrationStep2Scrollview.translatesAutoresizingMaskIntoConstraints=false
        agentRegistrationScrollview.addSubview(agentRegistrationStep2Scrollview)
        
        agentRegistrationStep3Scrollview = UIScrollView()
        agentRegistrationStep3Scrollview.translatesAutoresizingMaskIntoConstraints=false
        agentRegistrationScrollview.addSubview(agentRegistrationStep3Scrollview)
        
        
        let initialScrollView1 = ["agentRegistrationScrollview":agentRegistrationScrollview,"view1":agentRegistrationStep1Scrollview,"view2":agentRegistrationStep2Scrollview,"view3":agentRegistrationStep3Scrollview]
        
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view1(==agentRegistrationScrollview)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view1(==agentRegistrationScrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view1][view2(==view1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view2(==view1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view2][view3(==view2)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view3(==view1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
    
        self.addAgentRegistrationStep1()
        self.addAgentRegistrationStep2()
        self.addAgentRegistrationStep3()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hide Viewcontroller Navigationcontroller
        //SimaspayUtility.clearNavigationBarcolor(self.navigationController!)  DBDBDB
        UINavigationBar.appearance().barTintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        UINavigationBar.appearance().tintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)

        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        self.navigationController?.navigationBarHidden = false
        
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 15, 25)
        backButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "btn-back"), forState: UIControlState.Normal)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: Agent Registration Step 1 Method
    
    func addAgentRegistrationStep1()
    {
        
        regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
        regiterStep2Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
        regiterStep3Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
        

            
            let topMargin = 20
            let labelFieldMArgin = 10
            let nextFieldMArgin = 20
            let textFieldHeight = 38
            let errorLabelWidth = 50
            let extraEndSpace = 30
            
            let step1ContentView = UIView()
            agentRegistrationStep1Scrollview.addSubview(step1ContentView)
            step1ContentView.translatesAutoresizingMaskIntoConstraints = false
            
            let initialViews = ["agentRegistrationStep1Scrollview":agentRegistrationStep1Scrollview,"step1ContentView":step1ContentView]
            agentRegistrationStep1Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step1ContentView(==agentRegistrationStep1Scrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
            agentRegistrationStep1Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[step1ContentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
            
            
            var viewsDict = [String: UIView]()
            viewsDict["super"] = step1ContentView
            
            var vertical_constraints = "V:|-\(topMargin)-"
            var vertical_constraints1 = "V:"
            var vertical_constraints2 = "V:"
            
            viewsDict["step1ContentView"] = step1ContentView
            
            let fieldNamesArray : [NSString] = ["Nama Lengkap*","Tangal Lahir*","Nomor KTP*","KTP Berlaku Hingga*","Nomor HP*"]
            
            for i in 1...5 {
                let step1Label = UILabel()
                step1Label.text = "\(fieldNamesArray[i-1])"
                step1Label.font = UIFont(name:"HelveticaNeue-Medium", size:12.5)
                step1Label.translatesAutoresizingMaskIntoConstraints = false
                step1ContentView.addSubview(step1Label)
                
                let step1ErrorLabel = UILabel()
                step1ErrorLabel.text = "wajib diisi"
                step1ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step1ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step1ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                step1ErrorLabel.hidden = true
                step1ErrorLabel.tag = 10+i
                step1ContentView.addSubview(step1ErrorLabel)
                
                let step1TextField = UITextField(frame: CGRect.zero)
                if(i==1)
                { step1TextField.placeholder = "Sesuai KTP"
                   step1TextField.keyboardType = .NamePhonePad
                }
                else if(i==3)
                {  step1TextField.placeholder = "16 digit angka"
                    step1TextField.keyboardType = .NumberPad
                }
                else if(i==5)
                {
                    step1TextField.keyboardType = .NumberPad
                }
                
                step1TextField.backgroundColor = UIColor.whiteColor()
                step1TextField.enabled = true
                step1TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step1TextField.translatesAutoresizingMaskIntoConstraints = false
                step1TextField.borderStyle = .None
                step1TextField.layer.cornerRadius = 5
                step1TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step1ContentView.addSubview(step1TextField)
                step1TextField.tag = 20+i
                
                let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step1TextField.frame.height))
                step1TextField.leftView = mobileNumberView;
                step1TextField.leftViewMode = UITextFieldViewMode.Always
                
                //step1TextField.layer.borderWidth = 1
                //step1TextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
                
                
                viewsDict["step1Label_\(i)"] = step1Label
                viewsDict["step1ErrorLabel_\(i)"] = step1ErrorLabel
                viewsDict["step1TextField_\(i)"] = step1TextField
                
                
                step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1Label_\(i)]-0-[step1ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                
                
                if(i == 5)
                {
                    step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "-\(nextFieldMArgin)-[step1Label_\(i)]-\(labelFieldMArgin)-[step1TextField_\(i)(\(textFieldHeight))]"
                    
                }
                
                if(i==2)
                {
                    step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)(135)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                }
                
                if (i == 2 || i == 4)
                {
                    //step1TextField.enabled = false
                    step1TextField.text = "DD-MM-YYYY"
                    
                    let mobilenumberImageView = UIImageView();
                    mobilenumberImageView.frame = CGRect(x: 9, y: (step1TextField.frame.height-20)/2, width: 20, height: 20)
                    let phoneImage = UIImage(named: "ic-calendar");
                    mobilenumberImageView.image = phoneImage;
                    
                    let mobileNumberView = UIView(frame: CGRectMake(0, 0, 20+18, step1TextField.frame.height))
                    mobileNumberView.addSubview(mobilenumberImageView);
                    step1TextField.rightView = mobileNumberView;
                    step1TextField.rightViewMode = UITextFieldViewMode.Always
                    
                    step1TextField.addTarget(self, action: "textFieldEditing:", forControlEvents: .EditingDidEnd)
                    
                    
                    
                }
                if ( i == 4)
                {
                    let step1Field4CheckBox1:UIButton = UIButton()
                    step1Field4CheckBox1.backgroundColor = UIColor.clearColor()
                    step1Field4CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
                    step1Field4CheckBox1.translatesAutoresizingMaskIntoConstraints = false
                    step1ContentView.addSubview(step1Field4CheckBox1)
                    viewsDict["step1Field4CheckBox1"] = step1Field4CheckBox1
                    
                    let step1Field4CheckBox2:UIButton = UIButton()
                    step1Field4CheckBox2.backgroundColor = UIColor.clearColor()
                    step1Field4CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
                    step1Field4CheckBox2.translatesAutoresizingMaskIntoConstraints = false
                    step1ContentView.addSubview(step1Field4CheckBox2)
                    viewsDict["step1Field4CheckBox2"] = step1Field4CheckBox2
                    
                    let step1Field4Label4 = UILabel()
                    step1Field4Label4.text = "Seumur Hidup"
                    step1Field4Label4.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step1Field4Label4.translatesAutoresizingMaskIntoConstraints = false
                    step1Field4Label4.textAlignment = NSTextAlignment.Left
                    step1ContentView.addSubview(step1Field4Label4)
                    viewsDict["step1Field4Label4"] = step1Field4Label4
                    
                    step1TextField.enabled = false
                    step1TextField.text = "DD-MM-YYYY"
                    
                    
                    
                    step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1Field4CheckBox1(22)]-10-[step1TextField_\(i)(135)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1Field4CheckBox2(22)]-10-[step1Field4Label4(150)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step1Label_\(i)]-\(18)-[step1Field4CheckBox1(22)]-\(23)-[step1Field4CheckBox2(22)]"
                    vertical_constraints1 += "[step1Label_\(i)]-\(10)-[step1TextField_\(i)(\(textFieldHeight))]"
                    vertical_constraints2 += "[step1TextField_\(i)(\(textFieldHeight))]-\(15)-[step1Field4Label4(21)]"
                }
                
                if(i == 1 || i == 2 || i == 3) {
                    
                    step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step1TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
                }
                
                
                if(i == 5 )
                {
                    let step1FormAcceptBtn:UIButton = UIButton()
                    step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
                    step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
                    step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
                    step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
                    step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    
                    step1FormAcceptBtn.addTarget(self, action: "step1AcceptButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    step1ContentView.addSubview(step1FormAcceptBtn)
                    viewsDict["step1FormAcceptBtn"] = step1FormAcceptBtn
                    
                    step1FormAcceptBtn.layer.cornerRadius = 5
                    
                    //step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step1ContentView]-(<=1)-[step1FormAcceptBtn(160)]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsDict))
                    // vertical_constraints  += "-\(30)-[step1FormAcceptBtn(50)]"
                    
                    
                    
                    //step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[step1Field4Label4]-(<=1)-[step1FormAcceptBtn(50)]",options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: uploadViews))
                    
                    let buttonMargin = (self.view.frame.size.width-200)/2
                    step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step1FormAcceptBtn(200)]-(\(buttonMargin))-|",
                        options: NSLayoutFormatOptions.AlignAllCenterY,metrics: nil,
                        views: viewsDict))
                    
                    //step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1FormAcceptBtn(200)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    //step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[step1Field4Label4]-30-[step1FormAcceptBtn]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "-\(30)-[step1FormAcceptBtn(50)]"
                    
                }
                
            }
            
            vertical_constraints += "-\(extraEndSpace)-|"
            
            step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints1, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step1ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints2, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
}
    
    
    @IBAction func textFieldEditing(sender: UITextField) {
        
        self.step1DatePickerTextField = sender
        // 6
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: .ValueChanged)
        
    }
    
    // 7
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        self.step1DatePickerTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    // MARK: Agent Registration Step 2 Method
    
    func addAgentRegistrationStep2()
    {
        
            let topMargin = 20
            let labelFieldMArgin = 10
            let nextFieldMArgin = 20
            let textFieldHeight = 38
            let errorLabelWidth = 50
            let extraEndSpace = 30
            
            if step2ContentView == nil{
                
                
            }
            
            step2ContentView = UIView()
            agentRegistrationStep2Scrollview.addSubview(step2ContentView)
            step2ContentView.translatesAutoresizingMaskIntoConstraints = false
            
            
            step2ContentView2 = UIView()
            step2ContentView.addSubview(step2ContentView2)
            step2ContentView2.translatesAutoresizingMaskIntoConstraints = false
            
            let initialViews = ["agentRegistrationStep2Scrollview":agentRegistrationStep2Scrollview,"step2ContentView":step2ContentView]
            agentRegistrationStep2Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step2ContentView(==agentRegistrationStep2Scrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
            agentRegistrationStep2Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[step2ContentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
            
            
            var viewsDict = [String: UIView]()
            
            var vertical_constraints = "V:|-\(topMargin)-"
            var vertical_constraintsField81 = "V:"
            var vertical_constraintsField82 = "V:"
            
            var vertical_constraintsField91 = "V:"
            var vertical_constraintsField92 = "V:"
            
            viewsDict["step2ContentView"] = step2ContentView
            viewsDict["step2ContentView2"] = step2ContentView2
            
            let fieldNamesArray : [NSString] = ["Nama Lengkap Ibu Kandung*","Tempat Lahir*","Alamat Sesuai KTP*","Provinsi*","Kota/Kabupaten*","Kecamatan*","Desa/Kelurahan*","RT","Alamat Domisili"]
            
            // let fieldNamesArray : [NSString] = ["Nama Lengkap Ibu Kandung*","Tempat Lahir*","Alamat Sesuai KTP*","Provinsi*","Kota/Kabupaten*","Kecamatan*","Desa/Kelurahan*","Alamat Domisili","Provinsi*","Kota/Kabupaten*","Kecamatan*","Desa/Kelurahan*",""]
            
            //  RT   RW   Kode Pos*    Sesuai Identitas/Berbeda dengan Identitas   RT   RW   Kode Pos*
            
            for i in 1...9 {
                
                let step2Label = UILabel()
                step2Label.text = "\(fieldNamesArray[i-1])"
                step2Label.font = UIFont(name:"HelveticaNeue-Medium", size:12.5)
                step2Label.translatesAutoresizingMaskIntoConstraints = false
                step2ContentView.addSubview(step2Label)
                
                let step2ErrorLabel = UILabel()
                step2ErrorLabel.text = "wajib diisi"
                step2ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step2ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step2ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                step2ErrorLabel.hidden = true
                step2ErrorLabel.tag = 10+i
                step2ContentView.addSubview(step2ErrorLabel)
                
                viewsDict["step2Label_\(i)"] = step2Label
                viewsDict["step2ErrorLabel_\(i)"] = step2ErrorLabel
                
                //step1TextField.layer.borderWidth = 1
                //step1TextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
                
                
                /*if(i == 12)
                {
                vertical_constraints  += "-\(nextFieldMArgin)-[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(textFieldHeight))]"
                
                }else{
                vertical_constraints  += "[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
                } */
                
                
                if( i == 3)
                {
                    let step2TextField = UITextView(frame: CGRect.zero)
                    step2TextField.backgroundColor = UIColor(netHex: Constants.TextFieldDisableBackcolor)
                    step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step2TextField.translatesAutoresizingMaskIntoConstraints = false
                    step2TextField.layer.cornerRadius = 5
                    step2TextField.text = "Jl. Suryo No. 34"
                    step2TextField.editable = false
                    step2ContentView.addSubview(step2TextField)
                    step2TextField.tag = 20+i
                    viewsDict["step2TextField_\(i)"] = step2TextField
                    
                    step2TextField.contentInset = UIEdgeInsetsMake(0.0,8.0,0,0.0);

                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    
                    vertical_constraints  += "[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(100))]-\(nextFieldMArgin)-"
                    
                }else if ( i == 8)
                {
                    
                    
                    let step2Field8Label1 = UILabel()
                    step2Field8Label1.text = "RT"
                    step2Field8Label1.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                    step2Field8Label1.translatesAutoresizingMaskIntoConstraints = false
                    step2Field8Label1.textAlignment = NSTextAlignment.Left
                    step2ContentView.addSubview(step2Field8Label1)
                    viewsDict["step2Field8Label1"] = step2Field8Label1
                    
                    
                    let step2Field8Label2 = UILabel()
                    step2Field8Label2.text = "RW"
                    step2Field8Label2.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                    step2Field8Label2.translatesAutoresizingMaskIntoConstraints = false
                    step2Field8Label2.textAlignment = NSTextAlignment.Left
                    step2ContentView.addSubview(step2Field8Label2)
                    viewsDict["step2Field8Label2"] = step2Field8Label2
                    
                    let step2Field8Label3 = UILabel()
                    step2Field8Label3.text = "Kode Pos*"
                    step2Field8Label3.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                    step2Field8Label3.translatesAutoresizingMaskIntoConstraints = false
                    step2Field8Label3.textAlignment = NSTextAlignment.Left
                    step2ContentView.addSubview(step2Field8Label3)
                    viewsDict["step2Field8Label3"] = step2Field8Label3
                    
                    let step2Text8Field1 = UITextField(frame: CGRect.zero)
                    step2Text8Field1.backgroundColor = UIColor(netHex: 0xDBDBDB)
                    step2Text8Field1.enabled = false
                    step2Text8Field1.text = "004"
                    step2Text8Field1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step2Text8Field1.translatesAutoresizingMaskIntoConstraints = false
                    step2Text8Field1.borderStyle = .None
                    step2Text8Field1.layer.cornerRadius = 5
                    step2Text8Field1.clearButtonMode = UITextFieldViewMode.WhileEditing;
                    step2ContentView.addSubview(step2Text8Field1)
                    viewsDict["step2Text8Field1"] = step2Text8Field1
                    
                    let mobileNumberView1 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field1.frame.height))
                    step2Text8Field1.leftView = mobileNumberView1
                    step2Text8Field1.leftViewMode = UITextFieldViewMode.Always
                    
                    
                    let step2Text8Field2 = UITextField(frame: CGRect.zero)
                    step2Text8Field2.backgroundColor = UIColor(netHex: 0xDBDBDB)
                    step2Text8Field2.text = "015"
                    step2Text8Field2.enabled = false
                    step2Text8Field2.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step2Text8Field2.translatesAutoresizingMaskIntoConstraints = false
                    step2Text8Field2.borderStyle = .None
                    step2Text8Field2.layer.cornerRadius = 5
                    step2Text8Field2.clearButtonMode = UITextFieldViewMode.WhileEditing;
                    step2ContentView.addSubview(step2Text8Field2)
                    viewsDict["step2Text8Field2"] = step2Text8Field2
                    
                    let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field2.frame.height))
                    step2Text8Field2.leftView = mobileNumberView2
                    step2Text8Field2.leftViewMode = UITextFieldViewMode.Always
                    
                    let step2Text8Field3 = UITextField(frame: CGRect.zero)
                    step2Text8Field3.backgroundColor = UIColor(netHex: 0xDBDBDB)
                    step2Text8Field3.enabled = false
                    step2Text8Field3.text = "10234"
                    step2Text8Field3.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step2Text8Field3.translatesAutoresizingMaskIntoConstraints = false
                    step2Text8Field3.borderStyle = .None
                    step2Text8Field3.layer.cornerRadius = 5
                    step2Text8Field3.clearButtonMode = UITextFieldViewMode.WhileEditing;
                    step2ContentView.addSubview(step2Text8Field3)
                    viewsDict["step2Text8Field3"] = step2Text8Field3
                    
                    let mobileNumberView3 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field3.frame.height))
                    step2Text8Field3.leftView = mobileNumberView3
                    step2Text8Field3.leftViewMode = UITextFieldViewMode.Always
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field8Label1(50)]-20-[step2Field8Label2(==step2Field8Label1)]-25-[step2Field8Label3(90)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Text8Field1(50)]-20-[step2Text8Field2(==step2Text8Field1)]-20-[step2Text8Field3]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    
                    vertical_constraints               += "[step2Field8Label1]-\(labelFieldMArgin)-[step2Text8Field1(\(textFieldHeight))]-\(nextFieldMArgin)-"
                    
                    vertical_constraintsField81        += "[step2Field8Label2]-\(labelFieldMArgin)-[step2Text8Field2(\(textFieldHeight))]"
                    vertical_constraintsField82        += "[step2Field8Label3]-\(labelFieldMArgin)-[step2Text8Field3(\(textFieldHeight))]"
                    
                    
                }else if ( i == 9)
                {
                    
                    step2Field9CheckBox1 = UIButton()
                    step2Field9CheckBox1.backgroundColor = UIColor.clearColor()
                    step2Field9CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
                    step2Field9CheckBox1.translatesAutoresizingMaskIntoConstraints = false
                    step2Field9CheckBox1.tag = 100
                    step2ContentView.addSubview(step2Field9CheckBox1)
                    //step2Field9CheckBox1.addTarget(self, action: "sameAddressClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    viewsDict["step2Field9CheckBox1"] = step2Field9CheckBox1
                    
                    let step2Field9Label1 = UILabel()
                    step2Field9Label1.text = "Sesuai Identitas"
                    step2Field9Label1.font =  UIFont(name:"HelveticaNeue-Light", size:13)
                    step2Field9Label1.translatesAutoresizingMaskIntoConstraints = false
                    step2Field9Label1.textAlignment = NSTextAlignment.Left
                    step2ContentView.addSubview(step2Field9Label1)
                    viewsDict["step2Field9Label1"] = step2Field9Label1
                    
                    step2Field9CheckBox2 = UIButton()
                    step2Field9CheckBox2.backgroundColor = UIColor.clearColor()
                    step2Field9CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
                    step2Field9CheckBox2.translatesAutoresizingMaskIntoConstraints = false
                    step2Field9CheckBox2.tag = 200
                    step2ContentView.addSubview(step2Field9CheckBox2)
                    //step2Field9CheckBox2.addTarget(self, action: "otherAddressClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    viewsDict["step2Field9CheckBox2"] = step2Field9CheckBox2
                    
                    step2Field9Label2 = UILabel()
                    step2Field9Label2.text = "Berbeda dengan Identitas"
                    step2Field9Label2.font =  UIFont(name:"HelveticaNeue-Light", size:13)
                    step2Field9Label2.translatesAutoresizingMaskIntoConstraints = false
                    step2Field9Label2.textAlignment = NSTextAlignment.Left
                    step2ContentView.addSubview(step2Field9Label2)
                    viewsDict["step2Field9Label2"] = step2Field9Label2
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field9CheckBox1(22)]-10-[step2Field9Label1]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field9CheckBox2(22)]-10-[step2Field9Label2]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step2Label_\(i)]-\(18)-[step2Field9CheckBox1(22)]-\(18)-[step2Field9CheckBox2(22)]"
                    vertical_constraintsField91 += "[step2Label_\(i)]-\(21)-[step2Field9Label1]"
                    vertical_constraintsField92 += "[step2Field9Label1]-\(25)-[step2Field9Label2]"
                    
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step2ContentView2]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                }else{
                    
                    let step2TextField = UITextField(frame: CGRect.zero)
                    step2TextField.backgroundColor = UIColor(netHex: 0xDBDBDB)
                    step2TextField.enabled = false
                    step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step2TextField.translatesAutoresizingMaskIntoConstraints = false
                    step2TextField.borderStyle = .None
                    step2TextField.layer.cornerRadius = 5
                    step2TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                    step2ContentView.addSubview(step2TextField)
                    step2TextField.tag = 20+i
                    
                    let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step2TextField.frame.height))
                    step2TextField.leftView = mobileNumberView;
                    step2TextField.leftViewMode = UITextFieldViewMode.Always
                    viewsDict["step2TextField_\(i)"] = step2TextField
                    
                    if ( i == 1)
                    {
                        step2TextField.text = "Sutinah"
                    }
                    
                    if ( i == 2)
                    {
                        step2TextField.text = "Jakarta"
                    }
                    
                    if ( i == 4)
                    {
                        step2TextField.text = "DKI Jakarta"
                    }
                    
                    if ( i == 5)
                    {
                        step2TextField.text = "Jakarta Pusat"
                    }
                    
                    if ( i == 6)
                    {
                        step2TextField.text = "Tanah Abang"
                    }
                    
                    if ( i == 7)
                    {
                        step2TextField.text = "Kebon Melati"
                    }

                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
                }
                
                
                if(i == 9)
                {
                    step2FormAcceptBtn = UIButton()
                    step2FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
                    step2FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
                    step2FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
                    step2FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
                    step2FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    step2ContentView.addSubview(step2FormAcceptBtn)
                    step2FormAcceptBtn.addTarget(self, action: "step2AcceptButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
                    viewsDict["step2FormAcceptBtn"] = step2FormAcceptBtn
                    
                    step2FormAcceptBtn.layer.cornerRadius = 5
                    
                    let buttonMargin = (self.view.frame.size.width-200)/2
                    step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step2FormAcceptBtn(200)]-(\(buttonMargin))-|",
                        options: NSLayoutFormatOptions.AlignAllCenterY,metrics: nil,
                        views: viewsDict))
                    
                    vertical_constraints  += "-\(30)-[step2FormAcceptBtn(50)]"
                    
                }
                
            }
            
            vertical_constraints += "-\(extraEndSpace)-[step2ContentView2]|"
            
            step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField81, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField82, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField91, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField92, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))

    }
    
    @IBAction func sameAddressClicked(sender: UIButton)
    {
        step2Field9CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        step2Field9CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        /*if step2ContentView2 != nil
        {
            UIView.animateWithDuration(0.5, animations: {self.step2ContentView2.alpha = 0.0}, completion: {(value: Bool) in
                self.step2ContentView2.removeFromSuperview()
                for subview in self.step2ContentView.subviews {
                    subview.removeFromSuperview()
                }
            })
            
            self.addAgentRegistrationStep2()
        }*/
    }
    
    @IBAction func otherAddressClicked(sender: UIButton)
    {
        
        
        step2FormAcceptBtn.hidden = true
        step2Field9CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        step2Field9CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        
        let topMargin = 20
        let labelFieldMArgin = 10
        let nextFieldMArgin = 20
        let textFieldHeight = 38
        let errorLabelWidth = 50
        
        let initialViews = ["agentRegistrationStep2Scrollview":agentRegistrationStep2Scrollview,"step2ContentView2":step2ContentView2,"step2ContentView":step2ContentView,"step2Field9Label2":step2Field9Label2]
        
        agentRegistrationStep2Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step2ContentView2(==agentRegistrationStep2Scrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
        
        //agentRegistrationStep2Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[step2ContentView]-20-[step2ContentView2]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
        
        
        var viewsDict = [String: UIView]()
        
        var vertical_constraints = "V:|-\(topMargin)-"
        var vertical_constraintsField81 = "V:"
        var vertical_constraintsField82 = "V:"
        
        viewsDict["step2ContentView2"] = step2ContentView2
        
        let fieldNamesArray : [NSString] = ["Provinsi*","Kota/Kabupaten*","Kecamatan*","Desa/Kelurahan*"]
        //  RT   RW   Kode Pos*    Sesuai Identitas/Berbeda dengan Identitas   RT   RW   Kode Pos*
        
        for i in 1...4 {

         if( i == 1)
            {
                
                let step2TextField = UITextView(frame: CGRect.zero)
                step2TextField.text = "Jl./Gg./Perum./Komp./Ged. \n beserta nomor"
                step2TextField.backgroundColor = UIColor.whiteColor()
                step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2TextField.translatesAutoresizingMaskIntoConstraints = false
                step2TextField.layer.cornerRadius = 5
                step2ContentView2.addSubview(step2TextField)
                step2TextField.tag = 20+i
                viewsDict["step2TextField_\(0)"] = step2TextField
            
                step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField_\(0)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                
                
                vertical_constraints  += "[step2TextField_\(0)(\(100))]-\(nextFieldMArgin)-"
                
            }
            
            
            if ( i == 1 || i == 2 || i == 3 || i == 4){
                let step2Label = UILabel()
                step2Label.text = "\(fieldNamesArray[i-1])"
                step2Label.font = UIFont(name:"HelveticaNeue-Medium", size:12.5)
                step2Label.translatesAutoresizingMaskIntoConstraints = false
                step2ContentView2.addSubview(step2Label)
                
                let step2ErrorLabel = UILabel()
                step2ErrorLabel.text = "wajib diisi"
                step2ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step2ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step2ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                step2ErrorLabel.hidden = true
                step2ErrorLabel.tag = 10+i
                step2ContentView2.addSubview(step2ErrorLabel)
                
                viewsDict["step2Label_\(i)"] = step2Label
                viewsDict["step2ErrorLabel_\(i)"] = step2ErrorLabel
                
                
                let step2TextField = UITextField(frame: CGRect.zero)
                step2TextField.backgroundColor = UIColor.whiteColor()
                step2TextField.enabled = true
                step2TextField.placeholder = "Pilih"
                step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2TextField.translatesAutoresizingMaskIntoConstraints = false
                step2TextField.borderStyle = .None
                step2TextField.layer.cornerRadius = 5
                step2TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView2.addSubview(step2TextField)
                step2TextField.tag = 20+i
                
                let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step2TextField.frame.height))
                step2TextField.leftView = mobileNumberView;
                step2TextField.leftViewMode = UITextFieldViewMode.Always
                viewsDict["step2TextField_\(i)"] = step2TextField
                
                let dropDownImage = UIImage(named: "btn-dropdown")
                let dropDownButton = UIButton()
                dropDownButton.frame = CGRect(x: 9, y: (step2TextField.frame.height-10)/2, width: 16, height: 10)
                dropDownButton.setBackgroundImage(dropDownImage, forState: UIControlState.Normal)
                
                let dropDownView = UIView(frame: CGRectMake(0, 0, 15+18, step2TextField.frame.height))
                dropDownView.addSubview(dropDownButton)
                step2TextField.rightView = dropDownView
                step2TextField.rightViewMode = UITextFieldViewMode.Always
                
                step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                
                step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                
                vertical_constraints  += "[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
            }
            
            
            
            if ( i == 4)
            {
                
                
                let step2Field8Label1 = UILabel()
                step2Field8Label1.text = "RT"
                step2Field8Label1.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label1.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label1.textAlignment = NSTextAlignment.Left
                step2ContentView2.addSubview(step2Field8Label1)
                viewsDict["step2Field8Label1"] = step2Field8Label1
                
                
                let step2Field8Label2 = UILabel()
                step2Field8Label2.text = "RW"
                step2Field8Label2.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label2.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label2.textAlignment = NSTextAlignment.Left
                step2ContentView2.addSubview(step2Field8Label2)
                viewsDict["step2Field8Label2"] = step2Field8Label2
                
                let step2Field8Label3 = UILabel()
                step2Field8Label3.text = "Kode Pos*"
                step2Field8Label3.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label3.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label3.textAlignment = NSTextAlignment.Left
                step2ContentView2.addSubview(step2Field8Label3)
                viewsDict["step2Field8Label3"] = step2Field8Label3
                
                
                let step2ErrorLabel = UILabel()
                step2ErrorLabel.text = "wajib diisi"
                step2ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step2ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step2ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                step2ErrorLabel.hidden = true
                step2ErrorLabel.tag = 10+i
                step2ContentView2.addSubview(step2ErrorLabel)
                
                viewsDict["step2ErrorLabel_\(i)"] = step2ErrorLabel
                
                
                let step2Text8Field1 = UITextField(frame: CGRect.zero)
                step2Text8Field1.backgroundColor = UIColor.whiteColor()
                step2Text8Field1.enabled = true
                step2Text8Field1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field1.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field1.borderStyle = .None
                step2Text8Field1.layer.cornerRadius = 5
                step2Text8Field1.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView2.addSubview(step2Text8Field1)
                viewsDict["step2Text8Field1"] = step2Text8Field1
                
                let step2Text8Field2 = UITextField(frame: CGRect.zero)
                step2Text8Field2.backgroundColor = UIColor.whiteColor()
                step2Text8Field2.enabled = true
                step2Text8Field2.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field2.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field2.borderStyle = .None
                step2Text8Field2.layer.cornerRadius = 5
                step2Text8Field2.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView2.addSubview(step2Text8Field2)
                viewsDict["step2Text8Field2"] = step2Text8Field2
                
                let step2Text8Field3 = UITextField(frame: CGRect.zero)
                step2Text8Field3.backgroundColor = UIColor.whiteColor()
                step2Text8Field3.enabled = true
                step2Text8Field3.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field3.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field3.borderStyle = .None
                step2Text8Field3.layer.cornerRadius = 5
                step2Text8Field3.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView2.addSubview(step2Text8Field3)
                viewsDict["step2Text8Field3"] = step2Text8Field3
                
                step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field8Label1(50)]-20-[step2Field8Label2(==step2Field8Label1)]-25-[step2Field8Label3(90)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                
                step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Text8Field1(50)]-20-[step2Text8Field2(==step2Text8Field1)]-20-[step2Text8Field3]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                
                
                vertical_constraints               += "[step2Field8Label1]-\(labelFieldMArgin)-[step2Text8Field1(\(textFieldHeight))]-\(nextFieldMArgin)-"
                
                vertical_constraintsField81        += "[step2Field8Label2]-\(labelFieldMArgin)-[step2Text8Field2(\(textFieldHeight))]"
                vertical_constraintsField82        += "[step2Field8Label3]-\(labelFieldMArgin)-[step2Text8Field3(\(textFieldHeight))]"
                            
            }
            
            
            if(i == 4 )
            {
                
            let step2FormAcceptBtn:UIButton = UIButton()
            step2FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
            step2FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
            step2FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
            step2FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
            step2FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            step2ContentView2.addSubview(step2FormAcceptBtn)
            viewsDict["step2FormAcceptBtn"] = step2FormAcceptBtn
            
            step2FormAcceptBtn.layer.cornerRadius = 5
            
            
            step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(60)-[step2FormAcceptBtn(200)]-(60)-|",
            options: NSLayoutFormatOptions.AlignAllCenterY,metrics: nil,
            views: viewsDict))
            
            vertical_constraints  += "[step2FormAcceptBtn(50)]-30-"
            
            }
            
        }
        
        //vertical_constraints += "-\(extraEndSpace)-|"
        
        vertical_constraints += "|"
        
        step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField81, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        step2ContentView2.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField82, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
    }
    
    @IBAction func step2AcceptClicked(sender: UIButton)
    {
        
    }
    // MARK: Agent Registration Step 3 Method
    
    
    func addAgentRegistrationStep3()
    {
        
    
            let topMargin = 20
            let labelFieldMArgin = 10
            let nextFieldMArgin = 20
            let textFieldHeight = 38
            let errorLabelWidth = 50
            let extraEndSpace = 30
            
            let step3ContentView = UIView()
            agentRegistrationStep3Scrollview.addSubview(step3ContentView)
            step3ContentView.translatesAutoresizingMaskIntoConstraints = false
            
            let initialViews = ["agentRegistrationStep3Scrollview":agentRegistrationStep3Scrollview,"step3ContentView":step3ContentView]
            
            agentRegistrationStep3Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step3ContentView(==agentRegistrationStep3Scrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
            agentRegistrationStep3Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[step3ContentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
            
            
            var viewsDict = [String: UIView]()
            viewsDict["super"] = step3ContentView
            
            var vertical_constraints = "V:|-\(topMargin)-"
            var vertical_constraint61 = "V:"
            var vertical_constraint62 = "V:"
            
            viewsDict["step3ContentView"] = step3ContentView
            
            let fieldNamesArray : [NSString] = ["Pekerjaan*","Pendapatan per Bulan","Tujuan Pembukaan Rekening","Sumber Dana","E-mail","Lampiran*"]
            
            for i in 1...6 {
                let step1Label = UILabel()
                step1Label.text = "\(fieldNamesArray[i-1])"
                step1Label.font = UIFont(name:"HelveticaNeue-Medium", size:12.5)
                step1Label.translatesAutoresizingMaskIntoConstraints = false
                step3ContentView.addSubview(step1Label)
                
                let step1ErrorLabel = UILabel()
                step1ErrorLabel.text = "wajib diisi"
                step1ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step1ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step1ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                step1ErrorLabel.hidden = true
                step1ErrorLabel.tag = 10+i
                step3ContentView.addSubview(step1ErrorLabel)
                
                viewsDict["step1Label_\(i)"] = step1Label
                viewsDict["step1ErrorLabel_\(i)"] = step1ErrorLabel
                
                
                step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1Label_\(i)]-0-[step1ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDict))
                
                if(i != 6)
                {
                    
                    let step1TextField = UITextField(frame: CGRect.zero)
                    if(i==1)
                    {
                        step1TextField.text = "Lainnya"
                        
                        let dropDownImage = UIImage(named: "btn-dropdown")
                        let dropDownButton = UIButton()
                        dropDownButton.frame = CGRect(x: 9, y: (step1TextField.frame.height-10)/2, width: 16, height: 10)
                        dropDownButton.setBackgroundImage(dropDownImage, forState: UIControlState.Normal)
                        
                        let dropDownView = UIView(frame: CGRectMake(0, 0, 15+18, step1TextField.frame.height))
                        dropDownView.addSubview(dropDownButton)
                        step1TextField.rightView = dropDownView
                        step1TextField.rightViewMode = UITextFieldViewMode.Always
                        
                        step1TextField.delegate = self
                        step1TextField.addTarget(self, action: "pickerTextFieldEditing:", forControlEvents: .EditingDidBegin)
                    }
                    else if(i==2)
                    {
                        step1TextField.text = "Rp"
                    }
                    
                    step1TextField.backgroundColor = UIColor.whiteColor()
                    step1TextField.enabled = true
                    step1TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step1TextField.translatesAutoresizingMaskIntoConstraints = false
                    step1TextField.borderStyle = .None
                    step1TextField.layer.cornerRadius = 5
                    step1TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                    step3ContentView.addSubview(step1TextField)
                    step1TextField.tag = 20+i
                    
                    let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step1TextField.frame.height))
                    step1TextField.leftView = mobileNumberView;
                    step1TextField.leftViewMode = UITextFieldViewMode.Always
                    viewsDict["step1TextField_\(i)"] = step1TextField
                    
                    
                    step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step1TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
                }
                
                
                
                
                if(i==1)
                {
                    let step1TextField = UITextField(frame: CGRect.zero)
                    step1TextField.placeholder = "Sebutkan…"
                    step1TextField.backgroundColor = UIColor.whiteColor()
                    step1TextField.enabled = true
                    step1TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                    step1TextField.translatesAutoresizingMaskIntoConstraints = false
                    step1TextField.borderStyle = .None
                    step1TextField.layer.cornerRadius = 5
                    step1TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                    step3ContentView.addSubview(step1TextField)
                    step1TextField.tag = 20+i
                    
                    let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step1TextField.frame.height))
                    step1TextField.leftView = mobileNumberView;
                    step1TextField.leftViewMode = UITextFieldViewMode.Always
                    
                    viewsDict["step1TextField_11"] = step1TextField
                    
                    step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step1TextField_11]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step1TextField_\(i)]-\(labelFieldMArgin)-[step1TextField_11(\(textFieldHeight))]-\(nextFieldMArgin)-"
                }
                
                
                if(i==6)
                {
                    
                    /*var titleYposition:CGFloat = 145
                    if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
                        titleYposition = 30
                    }*/
                    
                    
                    let cameraImage = UIImage(named: "ic-camera")
                    let adImage = UIImage(named: "icAdd")
                    
                    step3SelectProof1 = SimaspayDottedBorderButton()
                    step3SelectProof1.backgroundColor = UIColor.clearColor()
                    step3SelectProof1.setTitle("Upload \n KTP*", forState: UIControlState.Normal)
                    step3SelectProof1.translatesAutoresizingMaskIntoConstraints = false
                    step3SelectProof1.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:10)
                    step3SelectProof1.setTitleColor(UIColor(netHex:0x8E8E93), forState: UIControlState.Normal)
                    step3SelectProof1.setImage(cameraImage, forState: UIControlState.Normal)
                    step3SelectProof1.titleLabel?.numberOfLines = 2
                    step3ContentView.addSubview(step3SelectProof1)
                    step3SelectProof1.layer.cornerRadius = 4
                    step3SelectProof1.titleEdgeInsets = UIEdgeInsetsMake(40,-30,0,17)
                    step3SelectProof1.imageEdgeInsets = UIEdgeInsetsMake(20,30,40,30)
                    step3SelectProof1.titleLabel?.textAlignment = NSTextAlignment.Center
                    viewsDict["step3SelectProof1"] = step3SelectProof1
                    
                    step3SelectProof1.addTarget(self, action: "onTapSubmitProof1:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    step3SelectProof2 = SimaspayDottedBorderButton()
                    step3SelectProof2.backgroundColor = UIColor.clearColor()
                    step3SelectProof2.setTitle("Upload \n Formulir*", forState: UIControlState.Normal)
                    step3SelectProof2.translatesAutoresizingMaskIntoConstraints = false
                    step3SelectProof2.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:10)
                    step3SelectProof2.setTitleColor(UIColor(netHex:0x8E8E93), forState: UIControlState.Normal)
                    step3SelectProof2.setImage(cameraImage, forState:UIControlState.Normal)
                    step3SelectProof2.titleLabel?.numberOfLines = 2
                    step3SelectProof2.layer.cornerRadius = 4
                    step3ContentView.addSubview(step3SelectProof2)
                    step3SelectProof2.titleEdgeInsets = UIEdgeInsetsMake(40,-30,0,17)
                    step3SelectProof2.imageEdgeInsets = UIEdgeInsetsMake(20,30,40,30)
                    step3SelectProof2.titleLabel?.textAlignment = NSTextAlignment.Center
                    viewsDict["step3SelectProof2"] = step3SelectProof2
                    step3SelectProof2.addTarget(self, action: "onTapSubmitProof1:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    step3SelectProof3 = SimaspayDottedBorderButton()
                    step3SelectProof3.backgroundColor = UIColor.clearColor()
                    step3SelectProof3.setTitle("Dokumen Lain \n (bila ada)", forState: UIControlState.Normal)
                    step3SelectProof3.translatesAutoresizingMaskIntoConstraints = false
                    step3SelectProof3.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:10)
                    step3SelectProof3.setTitleColor(UIColor(netHex:0x8E8E93), forState: UIControlState.Normal)
                    step3SelectProof3.setImage(adImage, forState: UIControlState.Normal)
                    step3SelectProof3.titleLabel?.numberOfLines = 2
                    step3SelectProof3.layer.cornerRadius = 4
                    step3ContentView.addSubview(step3SelectProof3)
                    step3SelectProof3.titleEdgeInsets = UIEdgeInsetsMake(40,-10,0,5)
                    step3SelectProof3.imageEdgeInsets = UIEdgeInsetsMake(20,50,40,50)
                    step3SelectProof3.titleLabel?.textAlignment = NSTextAlignment.Center
                    viewsDict["step3SelectProof3"] = step3SelectProof3
                    step3SelectProof3.addTarget(self, action: "onTapSubmitProof1:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step3SelectProof1]-10-[step3SelectProof2(==step3SelectProof1)]-10-[step3SelectProof3(==step3SelectProof1)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
                    
                    vertical_constraints  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step3SelectProof1(\(80))]-\(nextFieldMArgin)-"
                    
                    vertical_constraint61  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step3SelectProof2(==step3SelectProof1)]"
                    
                    vertical_constraint62  += "[step1Label_\(i)]-\(labelFieldMArgin)-[step3SelectProof3(==step3SelectProof1)]"
                    
                    let step1FormAcceptBtn:UIButton = UIButton()
                    step1FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
                    step1FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
                    step1FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
                    step1FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
                    step1FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    step1FormAcceptBtn.addTarget(self, action: "step3AcceptButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
                    step3ContentView.addSubview(step1FormAcceptBtn)
                    viewsDict["step1FormAcceptBtn"] = step1FormAcceptBtn
                    
                    step1FormAcceptBtn.layer.cornerRadius = 5
                    let buttonMargin = (self.view.frame.size.width-200)/2
                    step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step1FormAcceptBtn(200)]-(\(buttonMargin))-|",
                        options: NSLayoutFormatOptions.AlignAllCenterY,metrics: nil,
                        views: viewsDict))
                    
                    vertical_constraints  += "[step1FormAcceptBtn(50)]"
                    
                }
                
            }
            
            vertical_constraints += "-\(extraEndSpace)-|"
            
            step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraints, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraint61, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
            
            step3ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraint62, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
}
    
    
    @IBAction func pickerTextFieldEditing(sender: UITextField) {
        
        self.step1DatePickerTextField = sender
        // 6
        let datePickerView:UIPickerView = UIPickerView()
        datePickerView.delegate = self
        sender.inputView = datePickerView
        self.pickerViewData = ["Spring", "Summer", "Fall", "Winter"]
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerViewData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row] as? String
    }
    
    
    
    
    
    
    
    // MARK: Camera/Gallery Step 3 Method
    
    
    
    @IBAction func onTapSubmitProof1(button: SimaspayDottedBorderButton)
    {
        
        self.selectedProofButton = button
        // 1
        if #available(iOS 8.0, *) {
            let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .ActionSheet)
            let deleteAction = UIAlertAction(title: "Ambil Foto", style: .Default, handler: {
                action -> Void in
                self.cameraOptionSelected()
            })
            let saveAction = UIAlertAction(title: "Pilih dari Pustaka Foto ", style: .Default, handler: {
                action -> Void in
                
                self.galleryOptionSelected()
            })
            let cancelAction = UIAlertAction(title: "Batal", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })

            optionMenu.addAction(deleteAction)
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
        
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else {
            // Fallback on earlier versions
            
            let actionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Batal", destructiveButtonTitle: "", otherButtonTitles: "Ambil Foto", "Pilih dari Pustaka Foto")
            actionSheet.showInView(self.view)
        }
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("Done");
            break;
        case 1:
            NSLog("Cancel");
            break;
        case 2:
            self.galleryOptionSelected()
            break;
        case 3:
            self.cameraOptionSelected()
            NSLog("No");
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    
    func cameraOptionSelected ()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func galleryOptionSelected ()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.navigationBar.tintColor = UIColor.blackColor()
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.selectedProofButton.setBackgroundImage(pickedImage, forState: UIControlState.Normal)
            self.selectedProofButton.setTitle("", forState: UIControlState.Normal)
            self.selectedProofButton.setImage(UIImage(), forState: UIControlState.Normal)
            //imageView.contentMode = .ScaleAspectFit
            //imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Step1 Step2 Step3 Navigations
    
    func step1AcceptButtonClicked()
    {
        
        if(isStep1Activated)
        {
            agentRegistrationScrollview.setContentOffset(CGPoint(x:0,y: 0), animated: true)
            regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep2Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
            regiterStep3Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
            isStep1Activated = false
            regiterStep1Button.enabled = false
            regiterStep2Button.enabled = false
            regiterStep3Button.enabled = false
        }else{
            isStep1Activated = true
            agentRegistrationScrollview.setContentOffset(CGPoint(x:agentRegistrationStep1Scrollview.frame.size.width,y: 0), animated: true)
            regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep2Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep3Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
            regiterStep1Button.enabled = true
        }

    }
    
    func step2AcceptButtonClicked()
    {
        if(isStep2Activated)
        {
            agentRegistrationScrollview.setContentOffset(CGPoint(x:agentRegistrationStep1Scrollview.frame.size.width,y: 0), animated: true)
            regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep2Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep3Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
            isStep2Activated = false
            regiterStep2Button.enabled = false
            regiterStep3Button.enabled = false
            
        }else{
            isStep2Activated = true
            agentRegistrationScrollview.setContentOffset(CGPoint(x:agentRegistrationStep1Scrollview.frame.size.width*2,y: 0), animated: true)
            regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep2Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            regiterStep3Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
            
            regiterStep1Button.enabled = true
            regiterStep2Button.enabled = true
        }
    }
    
    func step3AcceptButtonClicked()
    {
        let address1 = "Jl. Suryo No. 34, RT/RW 04/15,Kebon Melati, Tanah Abang, Jakarta Pusat 10234"
        let address2 = "Jl. Kebahagiaan No. 94, RT/RW 01/03,Kebon Mawar, Cilegon, Banten 12304"
        
        let confirmationTitlesArray : [NSString] = ["Nama Lengkap","Tanggal Lahir","Nomor KTP","KTP Berlaku Hingga","Nomor HP","Nama Lengkap Ibu Kandung","Tempat Lahir","Alamat Sesuai KTP","Alamat Domisili","Pekerjaan","Pendapatan per Bulan","Tujuan Pembukaan Rekening","Sumber Dana","E-mail"]
        
        let confirmationValuesArray : [NSString] = ["BAYU SANTOSO","13-02-1989","3404120608850001","24-08-1985","08881234567","Sutinah","Jakarta","\(address1)","\(address2)","Wiraswasta","Rp 4.000.000","Menabung","Gaji","bayusantoso@gmail.com"]
        
        let confirmationViewController = ConfirmationViewController()
        confirmationViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_AGENT_REGISTRATION
        confirmationViewController.confirmationTitlesArray = confirmationTitlesArray
        confirmationViewController.confirmationValuesArray = confirmationValuesArray
        self.navigationController!.pushViewController(confirmationViewController, animated: true)
    }
    
    
}