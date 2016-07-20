//
//  AgentRegistrationViewC.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 19/01/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import AssetsLibrary

import UIKit


class AgentRegistrationViewC: UIViewController,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate
{
    
    
    var regiterStep1ImageView: UIImageView!
    var regiterStep2ImageView: UIImageView!
    var regiterStep3ImageView: UIImageView!
    
    var agentRegistrationStep1Scrollview : UIScrollView!
    var step1ContentView : UIView!
    
    var isKTPLifeValiditySelected:Bool = false
    
    var step1Field4CheckBox1:UIButton!
    var step1Field4CheckBox2:UIButton!
    
    var dateOfBirthPicker:UIDatePicker!
    
    
    var agentRegistrationStep2Scrollview :  UIScrollView!
    var step2ContentView : UIView!
    //var step2ContentView2 : UIView!
    
    var isDomesticIdentity:Bool = false
    
    var step2Field9Label2:UILabel!
    
    var step2FormAcceptBtn:UIButton!
    
    
    var agentRegistrationStep3Scrollview :  UIScrollView!
    var step3ContentView : UIView!
    
    
    var agentRegistrationScrollview: UIScrollView!
    
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
    
    var  isProof1Submitted:Bool = false
    var  isProof2Submitted:Bool = false
    var  isProof3Submitted:Bool = false
    
    
    
    var pickerViewData:NSArray!
    
    var workListViewData:NSArray!
    
    var provienceViewData:NSArray!
    var regionData:NSArray!
    var stateViewData:NSArray!
    var cityViewData:NSArray!
    
    var workSourceData = NSArray()as [AnyObject]
    var worklistDict : NSDictionary!
    
    var step1DatePickerTextField:UITextField!
    
    var step1FormDictonary:NSMutableDictionary!
    var step2FormDictonary:NSMutableDictionary!
    var step2OtherFormDictonary:NSMutableDictionary!
    var step3FormDictonary:NSMutableDictionary!
    

    var view_constraint_2:NSArray = [NSLayoutConstraint]();
    var view_constraint_2_81:NSArray = [NSLayoutConstraint]();
    var view_constraint_2_82:NSArray = [NSLayoutConstraint]();
    var view_constraint_2_91:NSArray = [NSLayoutConstraint]();
    var view_constraint_2_92:NSArray = [NSLayoutConstraint]();
    
    
    var viewsDictStep2 = [String: UIView]()
    

    var view_constraint_22:NSArray = [NSLayoutConstraint]();
    var view_constraint_22_811:NSArray = [NSLayoutConstraint]();
    var view_constraint_22_821:NSArray = [NSLayoutConstraint]();
    
    var ktpValidationData:NSDictionary!
    
    var vertical_constraintsStep2 = ""
    
    var tempVertical_constraintsStep2 = ""
    
    let domicilAddresPlaceholder = "Jl./Gg./Perum./Komp./Ged. \n beserta nomor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Buka Rekening"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        //self.automaticallyAdjustsScrollViewInsets = false
        
        
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
        
        regiterStep1Button.addTarget(self, action: #selector(AgentRegistrationViewC.step1AcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        regiterStep2Button.addTarget(self, action: #selector(AgentRegistrationViewC.step2AcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        regiterStep3Button.addTarget(self, action: #selector(AgentRegistrationViewC.step3AcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        
        let initialTitleViews = ["titleView":titleView,"regiterStep1Button":regiterStep1Button,"regiterStep2Button":regiterStep2Button,"regiterStep3Button":regiterStep3Button]
        
        titleView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[regiterStep1Button]-0-[regiterStep2Button(==regiterStep1Button)]-0-[regiterStep3Button(==regiterStep1Button)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialTitleViews))
        
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
        
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view1(==agentRegistrationScrollview)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view1(==agentRegistrationScrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view1]-0-[view2(==view1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view2(==view1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view2]-0-[view3(==view2)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        agentRegistrationScrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view3(==view1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollView1))
        
        addAgentRegistrationStep1()
        addAgentRegistrationStep2()
        addAgentRegistrationStep3()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AgentRegistrationViewC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        
        readWorkData()
   
        /*   //dateOfBirthPicker.addTarget(self, action:"updateTextField", forControlEvents: .ValueChanged)
        
        NSString *maxDateString = @"01-Jan-1997";
        
        // the date formatter used to convert string to date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // the specific format to use
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        // converting string to date
        NSDate *theMaximumDate = [dateFormatter dateFromString: maxDateString];
        
        // repeat the same logic for theMinimumDate if needed
        
        // here you can assign the max and min dates to your datePicker
        [dateOfBirthPicker setMaximumDate:theMaximumDate]; //the min age restriction
        //[dateOfBirthPicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
        
        // set the mode
        [dateOfBirthPicker setDatePickerMode:UIDatePickerModeDate];
        
        // update the textfield with the date everytime it changes with selector defined below
        [dateOfBirthPicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        
        // and finally set the datePicker as the input mode of your textfield
        [birthDateTextField setInputView:dateOfBirthPicker]; */
        
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
        
        
        
        let backButtonItem = UIBarButtonItem(customView: SimaspayUtility.getSimasPayBackButton(self))
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
        
        step1ContentView = UIView()
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
            step1ErrorLabel.tag = 100+i
            step1ContentView.addSubview(step1ErrorLabel)
            
            let step1TextField = UITextField(frame: CGRect.zero)
            if(i==1)
            {
                step1TextField.placeholder = "Sesuai KTP"
                step1TextField.keyboardType = .NamePhonePad
            }
            else if(i==3)
                
            {
                step1TextField.delegate = self
                step1TextField.placeholder = "16 digit angka"
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
            step1TextField.tag = 10+i
            
            let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step1TextField.frame.height))
            step1TextField.leftView = mobileNumberView;
            step1TextField.leftViewMode = UITextFieldViewMode.Always
            
            
            
            
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
                
                step1TextField.addTarget(self, action: #selector(AgentRegistrationViewC.step1TextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
                
                step1TextField.tintColor = UIColor.clearColor()

            }
            if ( i == 4)
            {
                step1Field4CheckBox1 = UIButton()
                step1Field4CheckBox1.backgroundColor = UIColor.clearColor()
                step1Field4CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
                step1Field4CheckBox1.translatesAutoresizingMaskIntoConstraints = false
                step1ContentView.addSubview(step1Field4CheckBox1)
                viewsDict["step1Field4CheckBox1"] = step1Field4CheckBox1
                
                step1Field4CheckBox1.addTarget(self, action: #selector(AgentRegistrationViewC.ktpValiditySelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                isKTPLifeValiditySelected = false
                
                step1Field4CheckBox2 = UIButton()
                step1Field4CheckBox2.backgroundColor = UIColor.clearColor()
                step1Field4CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
                step1Field4CheckBox2.translatesAutoresizingMaskIntoConstraints = false
                step1ContentView.addSubview(step1Field4CheckBox2)
                viewsDict["step1Field4CheckBox2"] = step1Field4CheckBox2
                
                step1Field4CheckBox2.addTarget(self, action: #selector(AgentRegistrationViewC.ktpIDCardSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                let step1Field4Label4 = UILabel()
                step1Field4Label4.text = "Seumur Hidup"
                step1Field4Label4.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step1Field4Label4.translatesAutoresizingMaskIntoConstraints = false
                step1Field4Label4.textAlignment = NSTextAlignment.Left
                step1ContentView.addSubview(step1Field4Label4)
                viewsDict["step1Field4Label4"] = step1Field4Label4
                
                step1TextField.text = "DD-MM-YYYY"
                step1TextField.addTarget(self, action: #selector(AgentRegistrationViewC.step1TextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
                
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
                
                step1FormAcceptBtn.addTarget(self, action: #selector(AgentRegistrationViewC.step1AcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
                
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
    
    @IBAction func ktpValiditySelected(sender: UIButton)
    {
        isKTPLifeValiditySelected = false
        step1Field4CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        step1Field4CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
    }
    
    @IBAction func ktpIDCardSelected(sender: UIButton)
    {
        isKTPLifeValiditySelected = true
        step1Field4CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        step1Field4CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        
        let currentTextField = step1ContentView.viewWithTag(14) as! UITextField
        self.disableRequiredMessage(currentTextField)
    }
    @IBAction func step1TextFieldEditing(sender: UITextField) {
        
        self.step1DatePickerTextField = sender
        
        // 6
        //let datePickerView:UIDatePicker = UIDatePicker()
        
        //datePickerView.datePickerMode = UIDatePickerMode.Date
        
        dateOfBirthPicker = UIDatePicker()
        dateOfBirthPicker.date = NSDate()
        // the date string for the minimum age required (change according to your needs)
        
        let currentDate: NSDate = NSDate()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        // let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(name: "UTC")!
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar
        
        components.year = -18
        let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        components.year = -150
        let maxDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        dateOfBirthPicker.minimumDate = minDate
        dateOfBirthPicker.maximumDate = maxDate
        dateOfBirthPicker.datePickerMode = .Date
        
        dateOfBirthPicker.addTarget(self, action: #selector(AgentRegistrationViewC.datePickerValueChanged(_:)), forControlEvents: .ValueChanged)
        sender.inputView = dateOfBirthPicker
    }
    
    // 7
    func datePickerValueChanged(sender:UIDatePicker) {
        self.step1DatePickerTextField.text = self.formatDate(sender.date)
    }
    
    // MARK: Agent Registration Step 2 Method
    
    func addAgentRegistrationStep2()
    {
        
        let topMargin = 20
        let labelFieldMArgin = 10
        let nextFieldMArgin = 20
        let textFieldHeight = 38
        let errorLabelWidth = 50
        //let extraEndSpace = 30
        
        
        vertical_constraintsStep2 = "V:|-\(20)-"
        
        var vertical_constraintsFieldStep2_81 = "V:"
        var vertical_constraintsFieldStep2_82 = "V:"
        var vertical_constraintsFieldStep2_91 = "V:"
        var vertical_constraintsFieldStep2_92 = "V:"
    
        step2ContentView = UIView()
        agentRegistrationStep2Scrollview.addSubview(step2ContentView)
        step2ContentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let initialViews = ["agentRegistrationStep2Scrollview":agentRegistrationStep2Scrollview,"step2ContentView":step2ContentView]
        
        agentRegistrationStep2Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[step2ContentView(==agentRegistrationStep2Scrollview)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
        
        agentRegistrationStep2Scrollview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[step2ContentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialViews))
    
        viewsDictStep2["step2ContentView"] = step2ContentView
        
        let fieldNamesArray : [NSString] = ["Nama Lengkap Ibu Kandung*","Tempat Lahir*","Alamat Sesuai KTP*","Provinsi*","Kota/Kabupaten*","Kecamatan*","Desa/Kelurahan*","RT","Alamat Domisili"]
        
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
            step2ContentView.addSubview(step2ErrorLabel)
            
            viewsDictStep2["step2Label_\(i)"] = step2Label
            viewsDictStep2["step2ErrorLabel_\(i)"] = step2ErrorLabel
            
            
            
            if( i == 3)
            {
                let step2TextField = UITextView(frame: CGRect.zero)
                step2TextField.backgroundColor = UIColor(netHex: Constants.TextFieldDisableBackcolor)
                step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2TextField.translatesAutoresizingMaskIntoConstraints = false
                step2TextField.layer.cornerRadius = 5
                step2TextField.text = ""
                step2TextField.editable = false
                step2TextField.tag = 20+i
                step2ContentView.addSubview(step2TextField)
                viewsDictStep2["step2TextField_\(i)"] = step2TextField
                
                step2TextField.contentInset = UIEdgeInsetsMake(0.0,8.0,0,0.0);
                
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDictStep2))
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                
                vertical_constraintsStep2  += "[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(100))]-\(nextFieldMArgin)-"
                
            }else if ( i == 8)
            {
                
                let step2Field8Label1 = UILabel()
                step2Field8Label1.text = "RT"
                step2Field8Label1.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label1.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label1.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field8Label1)
                viewsDictStep2["step2Field8Label1"] = step2Field8Label1
                
                
                let step2Field8Label2 = UILabel()
                step2Field8Label2.text = "RW"
                step2Field8Label2.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label2.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label2.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field8Label2)
                viewsDictStep2["step2Field8Label2"] = step2Field8Label2
                
                let step2Field8Label3 = UILabel()
                step2Field8Label3.text = "Kode Pos*"
                step2Field8Label3.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label3.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label3.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field8Label3)
                viewsDictStep2["step2Field8Label3"] = step2Field8Label3
                
                let step2Text8Field1 = UITextField(frame: CGRect.zero)
                step2Text8Field1.backgroundColor = UIColor(netHex: Constants.TextFieldDisableBackcolor)
                step2Text8Field1.enabled = false
                step2Text8Field1.text = ""
                step2Text8Field1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field1.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field1.borderStyle = .None
                step2Text8Field1.layer.cornerRadius = 5
                step2Text8Field1.tag = 20+8
                step2Text8Field1.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2Text8Field1)
                viewsDictStep2["step2Text8Field1"] = step2Text8Field1
                
                let mobileNumberView1 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field1.frame.height))
                step2Text8Field1.leftView = mobileNumberView1
                step2Text8Field1.leftViewMode = UITextFieldViewMode.Always
                
                
                let step2Text8Field2 = UITextField(frame: CGRect.zero)
                step2Text8Field2.backgroundColor = UIColor(netHex: 0xDBDBDB)
                step2Text8Field2.text = ""
                step2Text8Field2.enabled = false
                step2Text8Field2.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field2.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field2.borderStyle = .None
                step2Text8Field2.layer.cornerRadius = 5
                step2Text8Field2.tag = 20+9
                step2Text8Field2.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2Text8Field2)
                viewsDictStep2["step2Text8Field2"] = step2Text8Field2
                
                let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field2.frame.height))
                step2Text8Field2.leftView = mobileNumberView2
                step2Text8Field2.leftViewMode = UITextFieldViewMode.Always
                
                let step2Text8Field3 = UITextField(frame: CGRect.zero)
                step2Text8Field3.backgroundColor = UIColor(netHex: Constants.TextFieldDisableBackcolor)
                step2Text8Field3.enabled = false
                step2Text8Field3.text = ""
                step2Text8Field3.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field3.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field3.borderStyle = .None
                step2Text8Field3.layer.cornerRadius = 5
                step2Text8Field3.tag = 20+10
                step2Text8Field3.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2Text8Field3)
                viewsDictStep2["step2Text8Field3"] = step2Text8Field3
                
                let mobileNumberView3 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field3.frame.height))
                step2Text8Field3.leftView = mobileNumberView3
                step2Text8Field3.leftViewMode = UITextFieldViewMode.Always
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field8Label1(50)]-20-[step2Field8Label2(==step2Field8Label1)]-25-[step2Field8Label3(90)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDictStep2))
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Text8Field1(50)]-20-[step2Text8Field2(==step2Text8Field1)]-20-[step2Text8Field3]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                
                vertical_constraintsStep2               += "[step2Field8Label1]-\(labelFieldMArgin)-[step2Text8Field1(\(textFieldHeight))]-\(nextFieldMArgin)-"
                
                vertical_constraintsFieldStep2_81        += "[step2Field8Label2]-\(labelFieldMArgin)-[step2Text8Field2(\(textFieldHeight))]"
                vertical_constraintsFieldStep2_82        += "[step2Field8Label3]-\(labelFieldMArgin)-[step2Text8Field3(\(textFieldHeight))]"
                
                
            }else if ( i == 9)
            {
                
                isDomesticIdentity = true
                
                step2Field9CheckBox1 = UIButton()
                step2Field9CheckBox1.backgroundColor = UIColor.clearColor()
                step2Field9CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
                step2Field9CheckBox1.translatesAutoresizingMaskIntoConstraints = false
                step2Field9CheckBox1.tag = 500
                step2ContentView.addSubview(step2Field9CheckBox1)
                step2Field9CheckBox1.addTarget(self, action: #selector(AgentRegistrationViewC.sameAddressClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                viewsDictStep2["step2Field9CheckBox1"] = step2Field9CheckBox1
                
                let step2Field9Label1 = UILabel()
                step2Field9Label1.text = "Sesuai Identitas"
                step2Field9Label1.font =  UIFont(name:"HelveticaNeue-Light", size:13)
                step2Field9Label1.translatesAutoresizingMaskIntoConstraints = false
                step2Field9Label1.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field9Label1)
                viewsDictStep2["step2Field9Label1"] = step2Field9Label1
                
                step2Field9CheckBox2 = UIButton()
                step2Field9CheckBox2.backgroundColor = UIColor.clearColor()
                step2Field9CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
                step2Field9CheckBox2.translatesAutoresizingMaskIntoConstraints = false
                step2Field9CheckBox2.tag = 600
                step2ContentView.addSubview(step2Field9CheckBox2)
                step2Field9CheckBox2.addTarget(self, action: #selector(AgentRegistrationViewC.otherAddressClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                viewsDictStep2["step2Field9CheckBox2"] = step2Field9CheckBox2
                
                step2Field9Label2 = UILabel()
                step2Field9Label2.text = "Berbeda dengan Identitas"
                step2Field9Label2.font =  UIFont(name:"HelveticaNeue-Light", size:13)
                step2Field9Label2.translatesAutoresizingMaskIntoConstraints = false
                step2Field9Label2.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field9Label2)
                viewsDictStep2["step2Field9Label2"] = step2Field9Label2
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDictStep2))
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field9CheckBox1(22)]-10-[step2Field9Label1]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Field9CheckBox2(22)]-10-[step2Field9Label2]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                vertical_constraintsStep2  += "[step2Label_\(i)]-\(18)-[step2Field9CheckBox1(22)]-\(18)-[step2Field9CheckBox2(22)]"
                vertical_constraintsFieldStep2_91 += "[step2Label_\(i)]-\(21)-[step2Field9Label1]"
                vertical_constraintsFieldStep2_92 += "[step2Field9Label1]-\(25)-[step2Field9Label2]"
                
                
            }else{
                
                let step2TextField = UITextField(frame: CGRect.zero)
                step2TextField.backgroundColor = UIColor(netHex: Constants.TextFieldDisableBackcolor)
                step2TextField.enabled = false
                step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2TextField.translatesAutoresizingMaskIntoConstraints = false
                step2TextField.borderStyle = .None
                step2TextField.layer.cornerRadius = 5
                step2TextField.tag = 20+i
                step2TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2TextField)
                
                let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step2TextField.frame.height))
                step2TextField.leftView = mobileNumberView;
                step2TextField.leftViewMode = UITextFieldViewMode.Always
                viewsDictStep2["step2TextField_\(i)"] = step2TextField
                
                if ( i == 1)
                {step2TextField.text = ""}
                
                if ( i == 2)
                {step2TextField.text = ""}
                
                if ( i == 4)
                {step2TextField.text = ""}
                
                if ( i == 5)
                {step2TextField.text = ""}
                
                if ( i == 6)
                {step2TextField.text = ""}
                
                if ( i == 7)
                {step2TextField.text = ""}
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2Label_\(i)]-0-[step2ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewsDictStep2))
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                vertical_constraintsStep2  += "[step2Label_\(i)]-\(labelFieldMArgin)-[step2TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
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
                step2FormAcceptBtn.addTarget(self, action: #selector(AgentRegistrationViewC.step2AcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
                viewsDictStep2["step2FormAcceptBtn"] = step2FormAcceptBtn
                
                step2FormAcceptBtn.layer.cornerRadius = 5
                
                let buttonMargin = (self.view.frame.size.width-200)/2
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(buttonMargin))-[step2FormAcceptBtn(200)]-(\(buttonMargin))-|",
                    options: NSLayoutFormatOptions.AlignAllCenterY,metrics: nil,
                    views: viewsDictStep2))
                
                vertical_constraintsStep2  += "-\(30)-[step2FormAcceptBtn(50)]"
                
            }
            
        }
        
        vertical_constraintsStep2 += "-\(15)-|"
        
        view_constraint_2 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsStep2, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        
        view_constraint_2_81 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsFieldStep2_81, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        view_constraint_2_82 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsFieldStep2_82, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        view_constraint_2_91 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsFieldStep2_91, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        view_constraint_2_92 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsFieldStep2_92, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        
        
        step2ContentView.addConstraints(view_constraint_2    as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_81 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_82 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_91 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_92 as! [NSLayoutConstraint])
        
        
        
    }
    
    @IBAction func sameAddressClicked(sender: UIButton)
    {
        isDomesticIdentity = true
        step2Field9CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        step2Field9CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        step2FormAcceptBtn.hidden = false

        step2ContentView.removeFromSuperview()
        
        addAgentRegistrationStep2()
        
        fillKTPValidationdata(self.ktpValidationData)
       
    }
    
    @IBAction func otherAddressClicked(sender: UIButton)
    {
        isDomesticIdentity = false
        self.step2OtherFormDictonary = NSMutableDictionary()
        
        step2FormAcceptBtn.hidden = true
        
        step2Field9CheckBox2.setBackgroundImage(UIImage(named:"btn-checkbox-on"), forState: .Normal)
        step2Field9CheckBox1.setBackgroundImage(UIImage(named:"btn-checkbox-off"), forState: .Normal)
        
        
        
        let original = vertical_constraintsStep2
        vertical_constraintsStep2 = String(original.characters.dropLast()) // ello
        
        let topMargin = 20
        let labelFieldMArgin = 10
        let nextFieldMArgin = 20
        let textFieldHeight = 38
        let errorLabelWidth = 50
        
        tempVertical_constraintsStep2 = vertical_constraintsStep2
        
        vertical_constraintsStep2 = vertical_constraintsStep2.stringByReplacingOccurrencesOfString("[step2FormAcceptBtn(50)]-15-", withString: "")
        
        // var vertical_constraintsStep22 = "V:[step2Field9CheckBox2]-\(15)-"
        var vertical_constraintsFieldStep22_811 = "V:"
        var vertical_constraintsField_Step22_821 = "V:"
    
        let fieldNamesArray : [NSString] = ["Provinsi*","Kota/Kabupaten*","Kecamatan*","Desa/Kelurahan*"]
        
        //vertical_constraintsStep2 += "[step2Field9CheckBox2]-\(15)-"
        
    
        
        
        for i in 1...4 {

            if ( i == 1 )
            {
                let step2TextField = UITextView(frame: CGRect.zero)
                step2TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2TextField.translatesAutoresizingMaskIntoConstraints = false
                step2TextField.textColor = UIColor.lightGrayColor()
                step2TextField.layer.cornerRadius = 5
                step2TextField.delegate = self
                step2TextField.text = domicilAddresPlaceholder
                step2TextField.tag = 99
                step2ContentView.addSubview(step2TextField)
                viewsDictStep2["step2TextView2"] = step2TextField
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step2TextView2]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                vertical_constraintsStep2  += "[step2TextView2(100)]-\(nextFieldMArgin)-"
                
            }
            
            
            if ( i == 1 || i == 2 || i == 3 || i == 4) {
                
                let step22Label = UILabel()
                step22Label.text = "\(fieldNamesArray[i-1])"
                step22Label.font = UIFont(name:"HelveticaNeue-Medium", size:12.5)
                step22Label.translatesAutoresizingMaskIntoConstraints = false
                step2ContentView.addSubview(step22Label)
                
                let step22ErrorLabel = UILabel()
                step22ErrorLabel.text = "wajib diisi"
                step22ErrorLabel.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step22ErrorLabel.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step22ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                step22ErrorLabel.hidden = true
                step22ErrorLabel.tag = 100+i
                step2ContentView.addSubview(step22ErrorLabel)
                
                viewsDictStep2["step22Label_\(i)"] = step22Label
                viewsDictStep2["step22ErrorLabel_\(i)"] = step22ErrorLabel
                
                
                let step22TextField = UITextField(frame: CGRect.zero)
                step22TextField.backgroundColor = UIColor.whiteColor()
                step22TextField.placeholder = "Pilih"
                step22TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step22TextField.translatesAutoresizingMaskIntoConstraints = false
                step22TextField.borderStyle = .None
                step22TextField.layer.cornerRadius = 5
                step22TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step22TextField)
                step22TextField.tag = 200+i
                
                let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step22TextField.frame.height))
                step22TextField.leftView = mobileNumberView;
                step22TextField.leftViewMode = UITextFieldViewMode.Always
                viewsDictStep2["step22TextField_\(i)"] = step22TextField
                
                let dropDownImage = UIImage(named: "btn-dropdown")
                let dropDownButton = UIButton()
                dropDownButton.frame = CGRect(x: 9, y: (step22TextField.frame.height-10)/2, width: 16, height: 10)
                dropDownButton.setBackgroundImage(dropDownImage, forState: UIControlState.Normal)
                
                let dropDownView = UIView(frame: CGRectMake(0, 0, 15+18, step22TextField.frame.height))
                dropDownView.addSubview(dropDownButton)
                step22TextField.rightView = dropDownView
                step22TextField.rightViewMode = UITextFieldViewMode.Always
                
                step22TextField.addTarget(self, action: #selector(AgentRegistrationViewC.pickerTextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step22Label_\(i)]-0-[step22ErrorLabel_\(i)(\(errorLabelWidth))]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step22TextField_\(i)]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                vertical_constraintsStep2  += "[step22Label_\(i)]-\(labelFieldMArgin)-[step22TextField_\(i)(\(textFieldHeight))]-\(nextFieldMArgin)-"
                
                
                
                if ( i == 1)
                {
                    step22TextField.enabled = true
                    
                }else{
                    step22TextField.enabled = false
                }
 
            
         
            if ( i == 4)
            {
                
                let step2Field8Label1 = UILabel()
                step2Field8Label1.text = "RT"
                step2Field8Label1.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label1.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label1.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field8Label1)
                viewsDictStep2["step22Field8Label11"] = step2Field8Label1
                
                
                let step2Field8Label2 = UILabel()
                step2Field8Label2.text = "RW"
                step2Field8Label2.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label2.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label2.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field8Label2)
                viewsDictStep2["step22Field8Label22"] = step2Field8Label2
                
                let step2Field8Label3 = UILabel()
                step2Field8Label3.text = "Kode Pos*"
                step2Field8Label3.font =  UIFont(name:"HelveticaNeue-Medium", size:12)
                step2Field8Label3.translatesAutoresizingMaskIntoConstraints = false
                step2Field8Label3.textAlignment = NSTextAlignment.Left
                step2ContentView.addSubview(step2Field8Label3)
                viewsDictStep2["step22Field8Label33"] = step2Field8Label3
                
            
                let step2Text8Field1 = UITextField(frame: CGRect.zero)
                step2Text8Field1.backgroundColor = UIColor.whiteColor()
                step2Text8Field1.enabled = true
                step2Text8Field1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field1.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field1.borderStyle = .None
                step2Text8Field1.tag = 205
                step2Text8Field1.layer.cornerRadius = 5
                step2Text8Field1.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2Text8Field1)
                viewsDictStep2["step22Text8Field11"] = step2Text8Field1
                
                let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field1.frame.height))
                step2Text8Field1.leftView = mobileNumberView;
                step2Text8Field1.leftViewMode = UITextFieldViewMode.Always
                
                
                let step2Text8Field2 = UITextField(frame: CGRect.zero)
                step2Text8Field2.backgroundColor = UIColor.whiteColor()
                step2Text8Field2.enabled = true
                step2Text8Field2.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field2.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field2.borderStyle = .None
                step2Text8Field2.tag = 206
                step2Text8Field2.layer.cornerRadius = 5
                step2Text8Field2.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2Text8Field2)
                viewsDictStep2["step22Text8Field22"] = step2Text8Field2
                
                let mobileNumberView1 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field2.frame.height))
                step2Text8Field2.leftView = mobileNumberView1;
                step2Text8Field2.leftViewMode = UITextFieldViewMode.Always
                
                let step2Text8Field3 = UITextField(frame: CGRect.zero)
                step2Text8Field3.backgroundColor = UIColor.whiteColor()
                step2Text8Field3.enabled = true
                step2Text8Field3.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step2Text8Field3.translatesAutoresizingMaskIntoConstraints = false
                step2Text8Field3.borderStyle = .None
                step2Text8Field3.tag = 207
                step2Text8Field3.layer.cornerRadius = 5
                step2Text8Field3.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step2ContentView.addSubview(step2Text8Field3)
                viewsDictStep2["step22Text8Field33"] = step2Text8Field3
                
                
                let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 10, step2Text8Field3.frame.height))
                step2Text8Field3.leftView = mobileNumberView2;
                step2Text8Field3.leftViewMode = UITextFieldViewMode.Always
                
                let step22ErrorLabel1 = UILabel()
                step22ErrorLabel1.text = "wajib diisi"
                step22ErrorLabel1.textColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                step22ErrorLabel1.font = UIFont(name:"HelveticaNeue-Light", size:11)
                step22ErrorLabel1.translatesAutoresizingMaskIntoConstraints = false
                //step22ErrorLabel1.hidden = false
                step22ErrorLabel1.tag = 105
                step2ContentView.addSubview(step22ErrorLabel1)
                viewsDictStep2["step22ErrorLabel1"] = step22ErrorLabel1
                
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step22Field8Label11(80)]-20-[step22Field8Label22(80)]-20-[step22Field8Label33]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[step22ErrorLabel1]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(topMargin)-[step22Text8Field11(80)]-20-[step22Text8Field22(80)]-20-[step22Text8Field33]-\(topMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2))
                
                
                vertical_constraintsStep2   += "[step22Field8Label11]-\(labelFieldMArgin)-[step22Text8Field11(\(textFieldHeight))]-\(nextFieldMArgin)-"
                
                vertical_constraintsFieldStep22_811        += "[step22TextField_4]-\(nextFieldMArgin)-[step22Field8Label22]-\(labelFieldMArgin)-[step22Text8Field22(\(textFieldHeight))]"
                vertical_constraintsField_Step22_821       += "[step22TextField_4]-\(nextFieldMArgin)-[step22Field8Label33]-\(labelFieldMArgin)-[step22Text8Field33(\(textFieldHeight))]"
                
            }
 
            if(i == 4 )
            {
                let step2FormAcceptBtn:UIButton = UIButton()
                step2FormAcceptBtn.backgroundColor = UIColor(netHex:0xCC0000)
                step2FormAcceptBtn.setTitle("Lanjut", forState: UIControlState.Normal)
                step2FormAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
                step2FormAcceptBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:20)
                step2FormAcceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                step2FormAcceptBtn.addTarget(self, action: #selector(AgentRegistrationViewC.step2OtherAcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
                step2ContentView.addSubview(step2FormAcceptBtn)
                viewsDictStep2["step22FormAcceptBtn"] = step2FormAcceptBtn
                
                step2FormAcceptBtn.layer.cornerRadius = 5
                
                
                step2ContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(60)-[step22FormAcceptBtn(200)]-(60)-|",
                    options: NSLayoutFormatOptions.AlignAllCenterY,metrics: nil,
                    views: viewsDictStep2))
                
                vertical_constraintsStep2  += "[step22FormAcceptBtn(50)]-30-"
                
             }
            }
            
        }
        
        vertical_constraintsStep2 += "|"
        

        step2ContentView.removeConstraints(view_constraint_2 as! [NSLayoutConstraint])
        step2ContentView.removeConstraints(view_constraint_2_81 as! [NSLayoutConstraint])
        step2ContentView.removeConstraints(view_constraint_2_82 as! [NSLayoutConstraint])
        step2ContentView.removeConstraints(view_constraint_2_91 as! [NSLayoutConstraint])
        step2ContentView.removeConstraints(view_constraint_2_92 as! [NSLayoutConstraint])
        
        
        
        view_constraint_2 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsStep2, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        
        step2ContentView.addConstraints(view_constraint_2    as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_81 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_82 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_91 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_2_92 as! [NSLayoutConstraint])
        
         //view_constraint_22 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsStep22, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
        
         view_constraint_22_811 = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsFieldStep22_811, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)
         view_constraint_22_821  = NSLayoutConstraint.constraintsWithVisualFormat(vertical_constraintsField_Step22_821, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictStep2)

        //step2ContentView.addConstraints(view_constraint_22    as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_22_811 as! [NSLayoutConstraint])
        step2ContentView.addConstraints(view_constraint_22_821 as! [NSLayoutConstraint])
        
        if(SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_PROVIENCE_DATA) == nil)
        {
           getSimasPayProvienceData()
        }
        
    }
    
    
    func getStep2TextField()->UITextField
    {
        let step22TextField1 = UITextField(frame: CGRect.zero)
        step22TextField1.backgroundColor = UIColor.whiteColor()
        step22TextField1.delegate = self
        step22TextField1.placeholder = "Pilih"
        step22TextField1.font =  UIFont(name:"HelveticaNeue-Light", size:12)
        step22TextField1.translatesAutoresizingMaskIntoConstraints = false
        step22TextField1.borderStyle = .None
        step22TextField1.layer.cornerRadius = 5
        step22TextField1.clearButtonMode = UITextFieldViewMode.WhileEditing;
        
        let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step22TextField1.frame.height))
        step22TextField1.leftView = mobileNumberView;
        step22TextField1.leftViewMode = UITextFieldViewMode.Always
        viewsDictStep2["step22TextField1"] = step22TextField1
        
        let dropDownImage = UIImage(named: "btn-dropdown")
        let dropDownButton = UIButton()
        dropDownButton.frame = CGRect(x: 9, y: (step22TextField1.frame.height-10)/2, width: 16, height: 10)
        dropDownButton.setBackgroundImage(dropDownImage, forState: UIControlState.Normal)
        
        let dropDownView = UIView(frame: CGRectMake(0, 0, 15+18, step22TextField1.frame.height))
        dropDownView.addSubview(dropDownButton)
        step22TextField1.rightView = dropDownView
        step22TextField1.rightViewMode = UITextFieldViewMode.Always
        
        step22TextField1.addTarget(self, action: #selector(AgentRegistrationViewC.pickerTextFieldEditing(_:)), forControlEvents: .EditingDidBegin)

        return step22TextField1
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
        
        step3ContentView = UIView()
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
            step1ErrorLabel.tag = 300+i
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
                    
                    dropDownButton.addTarget(self, action: #selector(AgentRegistrationViewC.pickerTextFieldEditing(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    
                    let dropDownView = UIView(frame: CGRectMake(0, 0, 15+18, step1TextField.frame.height))
                    dropDownView.addSubview(dropDownButton)
                    step1TextField.rightView = dropDownView
                    step1TextField.rightViewMode = UITextFieldViewMode.Always
                    
                    step1TextField.addTarget(self, action: #selector(AgentRegistrationViewC.pickerTextFieldEditing(_:)), forControlEvents: .EditingDidBegin)
                    
                }
                
                
                step1TextField.backgroundColor = UIColor.whiteColor()
                step1TextField.enabled = true
                step1TextField.font =  UIFont(name:"HelveticaNeue-Light", size:12)
                step1TextField.translatesAutoresizingMaskIntoConstraints = false
                step1TextField.borderStyle = .None
                step1TextField.layer.cornerRadius = 5
                step1TextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                step3ContentView.addSubview(step1TextField)
                
                let mobileNumberView = UIView(frame: CGRectMake(0, 0, 10, step1TextField.frame.height))
                step1TextField.leftView = mobileNumberView;
                step1TextField.leftViewMode = UITextFieldViewMode.Always
                
                if(i==1)
                {
                    step1TextField.tag  = 31
                }
                if(i==2)
                {
                    let rupeeLabel = UILabel()
                    rupeeLabel.frame = CGRect(x: 10, y: (step1TextField.frame.height-20)/2, width: 15, height: 20)
                    rupeeLabel.text = "Rp"
                    rupeeLabel.textColor = UIColor.blackColor()
                    rupeeLabel.font = UIFont(name:"HelveticaNeue", size:11)
                    
                    let mobileNumberView2 = UIView(frame: CGRectMake(0, 0, 15+15, step1TextField.frame.height))
                    mobileNumberView2.addSubview(rupeeLabel);
                    step1TextField.leftView = mobileNumberView2
                    step1TextField.leftViewMode = UITextFieldViewMode.Always
                    step1TextField.keyboardType = .NumberPad
                    step1TextField.tag  = 33
                }
                if(i==3)
                {
                    step1TextField.tag  = 34
                    step1TextField.keyboardType = .NamePhonePad
                }
                if(i==4)
                {
                    step1TextField.tag  = 35
                    step1TextField.keyboardType = .NamePhonePad
                }
                if(i==5)
                {
                    step1TextField.tag  = 36
                    step1TextField.keyboardType = .EmailAddress
                }
                
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
                step1TextField.keyboardType = .NamePhonePad
                step1TextField.tag  = 32
                
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
                step3SelectProof1.tag = 1001
                viewsDict["step3SelectProof1"] = step3SelectProof1
                
                step3SelectProof1.addTarget(self, action: #selector(AgentRegistrationViewC.onTapSubmitProof1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
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
                step3SelectProof2.tag = 1002
                viewsDict["step3SelectProof2"] = step3SelectProof2
                step3SelectProof2.addTarget(self, action: #selector(AgentRegistrationViewC.onTapSubmitProof1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
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
                step3SelectProof3.tag = 1003
                viewsDict["step3SelectProof3"] = step3SelectProof3
                step3SelectProof3.addTarget(self, action: #selector(AgentRegistrationViewC.onTapSubmitProof1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
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
                step1FormAcceptBtn.addTarget(self, action: #selector(AgentRegistrationViewC.step3AcceptButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    
    func readWorkData()
    {
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[CATEGORY] = CATEGORY_WORK
        dict[INSTITUTION_ID] = ""
        dict[SERVICE] = SERVICE_PAYMENT
        let accType = "accountType"
        dict[accType] = ""
        dict[VERSION] = "0"
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        EZLoadingActivity.show("Loading...", disableUI: true)
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
            // Handle success response
            dispatch_async(dispatch_get_main_queue()) {
                
                EZLoadingActivity.hide()
                print("Work List : ",response)
                let responseDict = response as! NSDictionary
                self.workListViewData = responseDict.valueForKey("work_list") as! NSArray
            }
            
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController: self)
                }
                
        })
    }
    
    @IBAction func pickerTextFieldEditing(sender: AnyObject) {
    
        let subTextField = sender as! UITextField
        self.step1DatePickerTextField = subTextField
        let currentPickerView:UIPickerView = UIPickerView()
        currentPickerView.delegate = self
        
        subTextField.inputView = currentPickerView
        
        if sender.tag == 31  {
            currentPickerView.tag = 1000
        }
        
        if sender.tag == 201  {
            currentPickerView.tag = 1001
            makeProvinsiServiceCall(subTextField, pickerView: currentPickerView)
        }
        if sender.tag == 202 {
            currentPickerView.tag = 1002
            makeProvinsiServiceCall(subTextField, pickerView: currentPickerView)
        }
        if sender.tag == 203 {
            currentPickerView.tag = 1003
            makeProvinsiServiceCall(subTextField, pickerView: currentPickerView)
        }
        if sender.tag == 204 {
            currentPickerView.tag = 1004
            makeProvinsiServiceCall(subTextField, pickerView: currentPickerView)
        }
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (self.pickerViewData != nil) {
        
            return self.pickerViewData.count
        }else{
            return 0
        }
        
        //return 6
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1000 {
            
            let workObj = self.pickerViewData[row] as! NSDictionary
            return workObj.valueForKey("workName") as? String
        }
        
        if pickerView.tag == 1001 {
            let provienceObj = self.pickerViewData[row] as! NSDictionary
            return provienceObj.valueForKey("province_name") as? String
        }
        
        if pickerView.tag == 1002 {
            
            let regionObj = self.pickerViewData[row] as! NSDictionary
            return regionObj.valueForKey("region_name") as? String
        }
        if pickerView.tag == 1003 {
            let districtObj = self.pickerViewData[row] as! NSDictionary
            return districtObj.valueForKey("district_name") as? String
        }
        if pickerView.tag == 1004 {
            
            let villageObj = self.pickerViewData[row] as! NSDictionary
            return villageObj.valueForKey("village_name") as? String
            
            
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView.tag == 1000 {
            let workObj = self.pickerViewData[row] as! NSDictionary
            self.step1DatePickerTextField.text = workObj.valueForKey("workName") as? String
            let subTextField = step3ContentView.viewWithTag(32) as! UITextField
            if(self.step1DatePickerTextField.text == "Lainnya")
            {
                subTextField.enabled = true
                
            }else{
                subTextField.enabled = false
            }
        }
        
        if pickerView.tag == 1001 {
            let provienceObj = self.pickerViewData[row] as! NSDictionary
            self.step1DatePickerTextField.text = provienceObj.valueForKey("province_name") as? String
            
            let stateTextField = self.step2ContentView.viewWithTag(202) as! UITextField
            stateTextField.enabled = true
            stateTextField.text = ""
            let regionTextField = self.step2ContentView.viewWithTag(203) as! UITextField
            regionTextField.enabled = false
            regionTextField.text = ""
            let cityTextField = self.step2ContentView.viewWithTag(204) as! UITextField
            cityTextField.enabled = false
            cityTextField.text = ""
        }
        
        if pickerView.tag == 1002 {
            
            let regionObj = self.pickerViewData[row] as! NSDictionary
            self.step1DatePickerTextField.text =  regionObj.valueForKey("region_name") as? String
            
            let stateTextField = self.step2ContentView.viewWithTag(202) as! UITextField
            stateTextField.enabled = true
            let regionTextField = self.step2ContentView.viewWithTag(203) as! UITextField
            regionTextField.enabled = true
            regionTextField.text = ""
            let cityTextField = self.step2ContentView.viewWithTag(204) as! UITextField
            cityTextField.enabled = false
            cityTextField.text = ""
        }
        if pickerView.tag == 1003 {
            
            let regionObj = self.pickerViewData[row] as! NSDictionary
            self.step1DatePickerTextField.text =  regionObj.valueForKey("district_name") as? String
            
            let stateTextField = self.step2ContentView.viewWithTag(202) as! UITextField
            stateTextField.enabled = true
            let regionTextField = self.step2ContentView.viewWithTag(203) as! UITextField
            regionTextField.enabled = true
            let cityTextField = self.step2ContentView.viewWithTag(204) as! UITextField
            cityTextField.enabled = true
            cityTextField.text = ""
        }
        if pickerView.tag == 1004 {
            let regionObj = self.pickerViewData[row] as! NSDictionary
            self.step1DatePickerTextField.text =  regionObj.valueForKey("village_name") as? String
        }
        
        
    }
    
    
    // MARK: Locatios  Data Service
    
    func getSimasPayProvienceData()
    {
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[TXNNAME] = TXN_GetThirdPartyData
        dict[SERVICE] = SERVICE_PAYMENT
        dict[CATEGORY] = CATEGORY_PROVIENCE
        dict[VERSION] = "0"
        
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
                // Handle success response
                dispatch_async(dispatch_get_main_queue()) {
                    
                    EZLoadingActivity.hide()
                    print("Provience List Response : ",response)
                    
                    let responseDict = response as! NSDictionary
                    
                    SimasPayPlistUtility.saveDataToPlist(responseDict, key: SIMASPAY_PROVIENCE_DATA)
                    print("Response : ",SimasPayPlistUtility.getDataFromPlistForKey(SIMASPAY_PROVIENCE_DATA))
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController: self)
                }
                
        })
        
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
            
            if(self.selectedProofButton.tag == 1001)
            {
                self.isProof1Submitted = true
            }
            if(self.selectedProofButton.tag == 1002)
            {
                self.isProof2Submitted = true
            }
            if(self.selectedProofButton.tag == 1003)
            {
                self.isProof3Submitted = true
            }
            
            
            if (picker.sourceType == .Camera){
                
                let imageData = UIImageJPEGRepresentation(pickedImage, 0.6)
                let compressedJPGImage = UIImage(data: imageData!)
                ALAssetsLibrary().writeImageToSavedPhotosAlbum(compressedJPGImage!.CGImage, orientation: ALAssetOrientation(rawValue: compressedJPGImage!.imageOrientation.rawValue)!,
                    completionBlock:{ (path:NSURL!, error:NSError!) -> Void in
                       // println("\(path)")  //Here you will get your path
                })
            }
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func formatDate(date:NSDate)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate:String = dateFormatter.stringFromDate(date)
        return formattedDate
        
    }
    

    // MARK: Step1 Validation Methods
    
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
            
            
            self.step1FormDictonary = NSMutableDictionary()
            
            for  subView in step1ContentView.subviews
            {
                if (subView.isKindOfClass(UITextField))
                {
                    let currentTextField = subView as! UITextField
                    if(currentTextField.tag == 11  || currentTextField.tag == 13 || currentTextField.tag == 14 || currentTextField.tag == 15)
                    {
                        if(!currentTextField.isValid())
                        {
                            self.showRequiredMessage(currentTextField)
                            return
                        }else{
                            self.disableRequiredMessage(currentTextField)
                            
                            if(currentTextField.tag == 11)
                            {
                                self.step1FormDictonary["fullName"] = currentTextField.text
                            }
                            if(currentTextField.tag == 13)
                            {
                                if(currentTextField.text?.length < 16)
                                {
                                    self.showRequiredMessage(currentTextField)
                                    return
                                    
                                }else{
                                   self.step1FormDictonary["ktp"] = currentTextField.text
                                }
                                
                                
                            }
                            if(currentTextField.tag == 15)
                            {
                                self.step1FormDictonary["mobilePhoneNumber"] = currentTextField.text
                            }
                        }
                        
                    }
                    
                    if(currentTextField.tag == 12)
                    {
                        if(currentTextField.text == "DD-MM-YYYY")
                        {
                            self.showRequiredMessage(currentTextField)
                            return
                        }else{
                            self.step1FormDictonary["dob"] = currentTextField.text
                            self.disableRequiredMessage(currentTextField)
                        }
                    }
                    
                    if(currentTextField.tag == 14)
                    {
                        if(currentTextField.text == "DD-MM-YYYY" && !isKTPLifeValiditySelected)
                        {
                            self.showRequiredMessage(currentTextField)
                            return
                        }else{
                            self.disableRequiredMessage(currentTextField)
                        }
                        if(!isKTPLifeValiditySelected){
                            self.step1FormDictonary["ktpValidity"] = currentTextField.text
                        }else{
                            self.step1FormDictonary["ktpValidity"] = currentTextField.text
                        }
                        
                    }
                    
                }
            }
            
            self.validateKTPServiceCall()
            
            
        }
        
    }
    
    
    func showRequiredMessage(currentTextField:UITextField)
    {
        currentTextField.layer.borderWidth = 1
        currentTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
        
        let errorTag = 100+currentTextField.tag-10
        let errorLabel = agentRegistrationStep1Scrollview.viewWithTag(errorTag)
        errorLabel!.hidden = false
    }
    
    func disableRequiredMessage(currentTextField:UITextField)
    {
        currentTextField.layer.borderWidth = 0
        currentTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        let errorTag = 100+currentTextField.tag-10
        let errorLabel = agentRegistrationStep1Scrollview.viewWithTag(errorTag)
        errorLabel!.hidden = true
    }
    
    
    
    func validateKTPServiceCall()
    {

        var dobStribg = self.step1FormDictonary["dob"]
        dobStribg = dobStribg?.stringByReplacingOccurrencesOfString("-", withString: "")
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        //dict[INSTITUTION_ID] = SIMOBI
        dict[SERVICE] = SERVICE_AGENT
        dict[TXNNAME] = TXN_SUBSCRIBER_KTP_VALIDATION
        dict[SUB_FIRST_NAME] = self.step1FormDictonary["fullName"]
        dict[KTPID] = self.step1FormDictonary["ktp"]
        dict[SUB_DOB] = dobStribg
        
        //dict[DESTMDN] = SimaspayUtility.getNormalisedMDN(self.step1FormDictonary["mobilePhoneNumber"] as! NSString)
        dict[DESTMDN] = self.step1FormDictonary["mobilePhoneNumber"]
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        ServiceModel.connectPOSTURL(SIMASPAY_URL, postData:
            dict, successBlock: { (response) -> Void in
                // Handle success response
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    EZLoadingActivity.hide()
                    if(response == nil)
                    {
                        SimasPayAlert.showSimasPayAlert(REQUEST_FALIED,viewController: self)
                        return
                    }
                    let responseDict = response as NSDictionary
                    let messagecode  = responseDict.valueForKeyPath("response.message.code") as! String
                    let messageText  = responseDict.valueForKeyPath("response.message.text") as! String
                    
                    if( messagecode == SIMASPAY_KTP_VALIDATION_SUCESS)
                    {
                        self.isStep1Activated = true
                        self.agentRegistrationScrollview.setContentOffset(CGPoint(x:self.agentRegistrationStep1Scrollview.frame.size.width, y: 0), animated: true)
                        self.regiterStep1Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
                        self.regiterStep2Button.setTitleColor(UIColor.simasPayRedColor(), forState: .Normal)
                        self.regiterStep3Button.setTitleColor(UIColor.agentRegisBtnLightColor(), forState: .Normal)
                        self.regiterStep1Button.enabled = true
                        
                        //SimasPayPlistUtility.saveDataToPlist(responseDict, key: AGENT_KTP_VALIDATION_RESPONSE)
                        self.ktpValidationData = responseDict
                        self.fillKTPValidationdata(responseDict)
                        
                        print("KTP Validation Response : ",response)
                    }else{
                        SimasPayAlert.showSimasPayAlert(messageText,viewController: self)
                        if( messagecode == SIMASPAY_LOGIN_EXPIRE_CODE)
                        {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    }
                    
                }
                
            }, failureBlock: { (error: NSError!) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController:self)
                }
                
        })
    }
    
    
    func fillKTPValidationdata(ktpValidationRespone:NSDictionary)
    {
        //let ktpValidationRespone = SimasPayPlistUtility.getDataFromPlistForKey(AGENT_KTP_VALIDATION_RESPONSE)
        
        self.step2FormDictonary = NSMutableDictionary()
        
        let fullName  = ktpValidationRespone.valueForKeyPath("response.mothersMaidenName.text") as! String
        let  birthPlace  = ktpValidationRespone.valueForKeyPath("response.birthPlace.text") as! String
        let  addressLine =  ktpValidationRespone.valueForKeyPath("response.addressLine.text") as! String
        let  province  = ktpValidationRespone.valueForKeyPath("response.province.text") as! String
        let city  = ktpValidationRespone.valueForKeyPath("response.city.text") as! String
        let district = ktpValidationRespone.valueForKeyPath("response.district.text") as! String
        let subDistrict = ktpValidationRespone.valueForKeyPath("response.subDistrict.text") as! String
        let rtString  = ktpValidationRespone.valueForKeyPath("response.rt.text") as! String
        let rwstring  = ktpValidationRespone.valueForKeyPath("response.rw.text") as! String
        let postalCode  = ktpValidationRespone.valueForKeyPath("response.postalCode.text") as! String
        
        let transactionId = ktpValidationRespone.valueForKeyPath("response.transactionId.text") as! String
        
        self.step2FormDictonary["transactionId"] = transactionId
        
        for  subView in step2ContentView.subviews
        {
            if (subView.isKindOfClass(UITextView))
            {
                let currentTextView = subView as! UITextView
                if(currentTextView.tag == 23)
                {
                    currentTextView.text = addressLine
                    self.step2FormDictonary["ktpaddressLine"] = addressLine
                }
            }
            if (subView.isKindOfClass(UITextField))
            {
                let currentTextField = subView as! UITextField
                
                if(currentTextField.tag == 21)
                {
                    currentTextField.text = fullName
                    self.step2FormDictonary["fullNameMotherSibling"] = fullName
                }
                if(currentTextField.tag == 22)
                {
                    currentTextField.text = birthPlace
                    self.step2FormDictonary["birthPlace"] = birthPlace
                }
                if(currentTextField.tag == 24)
                {
                    currentTextField.text = province
                    self.step2FormDictonary["ktpProvince"] = province
                }
                if(currentTextField.tag == 25)
                {
                    currentTextField.text = city
                    self.step2FormDictonary["ktpCity"] = city
                }
                if(currentTextField.tag == 26)
                {
                    currentTextField.text = district
                    self.step2FormDictonary["ktpDistrict"] = district
                }
                if(currentTextField.tag == 27)
                {
                    currentTextField.text = subDistrict
                    self.step2FormDictonary["ktpSubDistrict"] = subDistrict
                }
                if(currentTextField.tag == 28)
                {
                    currentTextField.text = rtString
                    self.step2FormDictonary["ktpRT"] = rtString
                }
                if(currentTextField.tag == 29)
                {
                    currentTextField.text = rwstring
                    self.step2FormDictonary["ktpRW"] = rwstring
                }
                if(currentTextField.tag == 30)
                {
                    currentTextField.text = postalCode
                    self.step2FormDictonary["ktpPostalCode"] = postalCode
                }
                
            }
        }
    }
    
    // MARK: Step2 Validation Methods
    
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
            
            if(self.workListViewData.count > 0)
            {
                let firstTextField = step3ContentView.viewWithTag(31) as! UITextField
                let subTextField = step3ContentView.viewWithTag(32) as! UITextField
                
                let workObj = self.workListViewData[0] as! NSDictionary
                firstTextField.text = workObj.valueForKey("workName") as? String
                subTextField.enabled = false
            }
            
            self.pickerViewData = self.workListViewData
        }
        
        
    }
    
    
    func step2OtherAcceptButtonClicked()
    {
    
        for  subView in step2ContentView.subviews
        {
            if (subView.isKindOfClass(UITextField))
            {
                let currentTextField = subView as! UITextField
                
                if(currentTextField.tag == 201)
                {
                    let errorLabel = step2ContentView.viewWithTag(101)
                    
                    if(!currentTextField.isValid())
                    {
                        showErrorTextField(currentTextField)
                        errorLabel!.hidden = false
                        return
                    }else{
                        self.step2OtherFormDictonary["province"] = currentTextField.text
                        clearErrorTextField(currentTextField)
                        errorLabel!.hidden = true
                    }
                }
                
                if(currentTextField.tag == 202)
                {
                    let errorLabel = step2ContentView.viewWithTag(102)
                    if(!currentTextField.isValid())
                    {
                        showErrorTextField(currentTextField)
                        errorLabel!.hidden = false
                        return
                    }else{
                        
                        self.step2OtherFormDictonary["city"] = currentTextField.text
                        clearErrorTextField(currentTextField)
                        errorLabel!.hidden = true
                    }
                }
                
                if(currentTextField.tag == 203)
                {
                    let errorLabel = step2ContentView.viewWithTag(103)
                    if(!currentTextField.isValid())
                    {
                        showErrorTextField(currentTextField)
                        errorLabel!.hidden = false
                        return
                    }else{
                        self.step2OtherFormDictonary["district"] = currentTextField.text
                        clearErrorTextField(currentTextField)
                        
                        errorLabel!.hidden = true
                    }
                }
                
                if(currentTextField.tag == 204)
                {
                    let errorLabel = step2ContentView.viewWithTag(104)
                    
                    if(!currentTextField.isValid())
                    {
                        showErrorTextField(currentTextField)
                        errorLabel!.hidden = false
                        return
                    }else{
                        self.step2OtherFormDictonary["subDistrict"] = currentTextField.text
                        clearErrorTextField(currentTextField)
                        errorLabel!.hidden = true
                    }
                }
                
                if(currentTextField.tag == 205 || currentTextField.tag == 206 || currentTextField.tag == 206)
                {
                    let errorLabel = step2ContentView.viewWithTag(105)
                    
                    if(!currentTextField.isValid())
                    {
                        showErrorTextField(currentTextField)
                        errorLabel!.hidden = false
                        return
                    }else{
                        
                        if(currentTextField.tag == 205)
                        {
                            self.step2OtherFormDictonary["rt"] = currentTextField.text
                        }
                        if(currentTextField.tag == 206)
                        {
                            self.step2OtherFormDictonary["rw"] = currentTextField.text
                        }
                        if(currentTextField.tag == 206)
                        {
                           self.step2OtherFormDictonary["postalCode"] = currentTextField.text
                        }
                        
                        clearErrorTextField(currentTextField)
                        errorLabel!.hidden = true
                    }
                }
            }
            
            if (subView.isKindOfClass(UITextView))
            {
                
                
                let currentTextView = step2ContentView.viewWithTag(99) as! UITextView
                
                if(currentTextView.text == domicilAddresPlaceholder)
                {
                    
                    currentTextView.layer.borderWidth = 1
                    currentTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
                    
                    //let errorLabel = step2ContentView.viewWithTag(301)
                    //errorLabel!.hidden = false
                    return
                    
                }else{
                    
                    self.step2OtherFormDictonary["domicilAddressLine"] = currentTextView.text
                    
                    currentTextView.layer.borderWidth = 0
                    currentTextView.layer.borderColor = UIColor.clearColor().CGColor
                    //let errorLabel = step2ContentView.viewWithTag(301)
                    //errorLabel!.hidden = true
                }
                
            }
            
        }
        
        step2AcceptButtonClicked()
    }
    
    
    func showErrorTextField(currentTextField:UITextField)
    {
        currentTextField.layer.borderWidth = 1
        currentTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
    }
    
    func clearErrorTextField(currentTextField:UITextField)
    {
        currentTextField.layer.borderWidth = 0
        currentTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    // MARK: Step3 Validation Methods
    
    //"Pekerjaan*","Pendapatan per Bulan","Tujuan Pembukaan Rekening","Sumber Dana","E-mail","Lampiran*"
    
    func step3AcceptButtonClicked()
    {
        
        step3FormDictonary = NSMutableDictionary()
        
        for  subView in step3ContentView.subviews
        {
            if (subView.isKindOfClass(UITextField))
            {
                let currentTextField = subView as! UITextField
                
                if(currentTextField.tag == 31)
                {
                    let subTextField = step3ContentView.viewWithTag(32) as! UITextField
                    if(currentTextField.text == "Lainnya" && !subTextField.isValid())
                    {
                        
                        subTextField.layer.borderWidth = 1
                        subTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
                        
                        let errorLabel = step3ContentView.viewWithTag(301)
                        errorLabel!.hidden = false
                        return
                    }else{
                        
                        if(currentTextField.text == "Lainnya"){
                            self.step3FormDictonary["work"] = subTextField.text
                        }else{
                            self.step3FormDictonary["work"] = currentTextField.text
                        }
                        
                        subTextField.layer.borderWidth = 0
                        subTextField.layer.borderColor = UIColor.clearColor().CGColor
                        let errorLabel = step3ContentView.viewWithTag(301)
                        errorLabel!.hidden = true
                    }
                }
                
                
                if(currentTextField.tag == 33)
                {
                    self.step3FormDictonary["revenuePM"] = currentTextField.text
                }
                if(currentTextField.tag == 34)
                {
                    self.step3FormDictonary["acccountOpenIntrst"] = currentTextField.text
                }
                if(currentTextField.tag == 35)
                {
                    self.step3FormDictonary["sourceOfFunds"] = currentTextField.text
                }
                if(currentTextField.tag == 36)
                {
                    self.step3FormDictonary["emailID"] = currentTextField.text
                }
                
                if(!self.isProof1Submitted)
                {
                    //step3SelectProof1.chnageBorderColor(204.0, g: 0.0, b: 0.0)
                    //UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
                    let errorLabel = step3ContentView.viewWithTag(306)
                    errorLabel!.hidden = false
                    return
                }else{
                    //step3SelectProof1.chnageBorderColor(151.0, g: 151.0, b: 151.0)
                    let errorLabel = step3ContentView.viewWithTag(306)
                    errorLabel!.hidden = true
                }
                
                if(!self.isProof2Submitted)
                {
                    //step3SelectProof2.chnageBorderColor(204.0, g: 0.0, b: 0.0)
                    //UIColor(red: 204.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).CGColor
                    let errorLabel = step3ContentView.viewWithTag(306)
                    errorLabel!.hidden = false
                    return
                }else{
                    //step3SelectProof2.chnageBorderColor(151.0, g: 151.0, b: 151.0)
                    let errorLabel = step3ContentView.viewWithTag(306)
                    errorLabel!.hidden = true
                }
            }
        }
        
        
        // Read Step1 Form data
        
        
        let confirmationTitlesArray = NSMutableArray()
        let confirmationValuesArray = NSMutableArray()
        
        
        let fullName = self.step1FormDictonary["fullName"] as! NSString
        var fieldCount = 0
        
        if(fullName.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Nama Lengkap"
            confirmationValuesArray[fieldCount] = fullName
            fieldCount = fieldCount + 1
            
        }
        
        let dobString = self.step1FormDictonary["dob"] as! NSString
        if(dobString.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Tanggal Lahir"
            confirmationValuesArray[fieldCount] = dobString
            fieldCount = fieldCount + 1
        }
        let ktpNumber = self.step1FormDictonary["ktp"] as! NSString
        if(ktpNumber.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Nomor KTP"
            confirmationValuesArray[fieldCount] = ktpNumber
            fieldCount = fieldCount + 1
        }
        let ktpValidity = self.step1FormDictonary["ktpValidity"] as! NSString
        if(ktpValidity.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "KTP Berlaku Hingga"
            confirmationValuesArray[fieldCount] = ktpValidity
            fieldCount = fieldCount + 1
        }
        
        let mobilePhoneNumber = self.step1FormDictonary["mobilePhoneNumber"] as! NSString
        if(mobilePhoneNumber.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Nomor HP"
            confirmationValuesArray[fieldCount] = mobilePhoneNumber
            fieldCount = fieldCount + 1
        }
        

        // Read Step2 Form data
        let fullNameMotherSibLing = self.step2FormDictonary["fullNameMotherSibling"] as! NSString
        if(fullNameMotherSibLing.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Nama Lengkap Ibu Kandung"
            confirmationValuesArray[fieldCount] = fullNameMotherSibLing
            fieldCount = fieldCount + 1
        }
        
        let placeOfBirth = self.step2FormDictonary["birthPlace"] as! NSString
        if(placeOfBirth.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Tempat Lahir"
            confirmationValuesArray[fieldCount] = placeOfBirth
            fieldCount = fieldCount + 1
            
        }
        
        let addresMatchKTP = self.step2FormDictonary["ktpaddressLine"] as! NSString
        if(addresMatchKTP.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Alamat Sesuai KTP"
            confirmationValuesArray[fieldCount] = addresMatchKTP
            fieldCount = fieldCount + 1
            
        }
        
        var domicileAddress = ""
        if(isDomesticIdentity)
        {
            domicileAddress = self.step2FormDictonary["ktpaddressLine"]  as! String
        }else{
            domicileAddress = self.step2OtherFormDictonary["domicilAddressLine"] as! String
        }
        
        if(domicileAddress.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Alamat Domisili"
            confirmationValuesArray[fieldCount] = domicileAddress
            fieldCount = fieldCount + 1
            
        }
        
        let workString = self.step3FormDictonary["work"] as! NSString
        if(workString.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Pekerjaan"
            confirmationValuesArray[fieldCount] = workString
            fieldCount = fieldCount + 1
            
        }
        let incomePM = self.step3FormDictonary["revenuePM"] as! NSString
        if(incomePM.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Pendapatan per Bulan"
            confirmationValuesArray[fieldCount] = "Rp \(incomePM)"
            fieldCount = fieldCount + 1
            
        }
        
        let acccountOpenIntrst = self.step3FormDictonary["acccountOpenIntrst"] as! NSString
        if(acccountOpenIntrst.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Tujuan Pembukaan Rekening"
            confirmationValuesArray[fieldCount] = acccountOpenIntrst
            fieldCount = fieldCount + 1
        }
        
        let emailID = self.step3FormDictonary["emailID"] as! NSString
        if(emailID.length > 0)
        {
            confirmationTitlesArray[fieldCount] = "Tujuan Pembukaan Rekening"
            confirmationValuesArray[fieldCount] = emailID
            fieldCount = fieldCount + 1
        }
        
        
        // Prepare Request Object
        
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        
        var dobStrig = self.step1FormDictonary["dob"] as! NSString
        dobStrig = dobStrig.stringByReplacingOccurrencesOfString("-", withString: "")
        
        dict[SUB_FIRST_NAME] = self.step1FormDictonary["fullName"] as! NSString
        dict[SUB_DOB]   = dobStrig
        //dict[DESTMDN] = SimaspayUtility.getNormalisedMDN(self.step1FormDictonary["mobilePhoneNumber"] as! NSString)
        dict[DESTMDN] = self.step1FormDictonary["mobilePhoneNumber"]
        dict[KTP_Mother_Maiden_Name] = self.step2FormDictonary["fullNameMotherSibling"] as! NSString
        
        
        dict[KTPID] = self.step1FormDictonary["ktp"]
        
        dict[KTP_LINE1] = self.step2FormDictonary["ktpaddressLine"]  as! String
        dict[KTP_City] = self.step2FormDictonary["ktpCity"] as! NSString
        dict[KTP_State] = self.step2FormDictonary["ktpProvince"] as! NSString
        dict[KTP_District] = self.step2FormDictonary["ktpDistrict"] as! NSString
        dict[KTP_Sub_District] = self.step2FormDictonary["ktpSubDistrict"] as! NSString
        
        dict[KTP_RT] = self.step2FormDictonary["ktpRT"] as! NSString
        dict[KTP_RW] = self.step2FormDictonary["ktpRW"] as! NSString
        dict[KTP_Zipcode] = self.step2FormDictonary["ktpPostalCode"] as! NSString
        
        if(isKTPLifeValiditySelected)
        {
            dict[KTP_LifeTime] = "true"
        }else{
            dict[KTP_LifeTime] = "false"
            var ktpValidity = self.step1FormDictonary["ktpValidity"]  as! NSString
            ktpValidity = ktpValidity.stringByReplacingOccurrencesOfString("-", withString: "")
            
            dict[KTP_Validation_Until] = ktpValidity
        }
        
        if(isDomesticIdentity)
        {
          dict[Domestic_Identity] = "1"
        }else{
            
            dict[Domestic_Identity] = "2"
            
            dict[LINE1] = self.step2OtherFormDictonary["domicilAddressLine"] as! String
            dict[REGION_NAME] = self.step2OtherFormDictonary["province"] as! NSString
            dict[CITY] = self.step2OtherFormDictonary["city"] as! NSString
            dict[STATE] = self.step2OtherFormDictonary["district"] as! NSString
            dict[SUB_STATE] = self.step2OtherFormDictonary["subDistrict"] as! NSString
            
            dict[RT] = self.step2OtherFormDictonary["rt"] as! NSString
            dict[RW] = self.step2OtherFormDictonary["rw"] as! NSString
            dict[ZIPCODE] = self.step2OtherFormDictonary["postalCode"] as! NSString
        }
        
        dict[WORK] = self.step3FormDictonary["work"] as! NSString
        dict[INCOME] = self.step3FormDictonary["revenuePM"] as! NSString
        dict[Goal_Open_Account] = self.step3FormDictonary["acccountOpenIntrst"] as! NSString
        dict[SOURCE_OF_FUNDS] = self.step3FormDictonary["sourceOfFunds"] as! NSString
        dict[EMAIL] = self.step3FormDictonary["emailID"] as! NSString
        
        
        dict[Transaction_ID] =  self.step2FormDictonary["transactionId"] as! NSString
        
        dict[SOURCEMDN] = SimasPayPlistUtility.getDataFromPlistForKey(SOURCEMDN)
        dict[SOURCEPIN] = SimaspayUtility.simasPayRSAencryption(SimasPayPlistUtility.getDataFromPlistForKey(SOURCEPIN) as! String)
        //dict[INSTITUTION_ID] = SIMOBI
        dict[SERVICE] = SERVICE_AGENT
        dict[TXNNAME] = TXN_SUBSCRIBER_KTP_REGISTRATION
        
        if(isProof1Submitted)
        {
            let proof1Image:UIImage = step3SelectProof1.backgroundImageForState(.Normal)!
            let proof1Imagestring = self.getImageString(proof1Image)
            dict[KTP_DOCUMENT] = proof1Imagestring
        }
        
        if(isProof2Submitted)
        {
            let proof2Image:UIImage = step3SelectProof2.backgroundImageForState(.Normal)!
            let proof2Imagestring = self.getImageString(proof2Image)
            dict[SUBSCRIBER_FOR_DOCUMENT] = proof2Imagestring
        }
        
        if(isProof3Submitted)
        {
            let proof3Image:UIImage = step3SelectProof3.backgroundImageForState(.Normal)!
            let proof3Imagestring = self.getImageString(proof3Image)
            dict[SUPPORTING_DOCUMENT] = proof3Imagestring
        }
        
        let confirmationViewController = ConfirmationViewController()
        confirmationViewController.showOTPAlert = false
        confirmationViewController.simasPayOptionType = SimasPayOptionType.SIMASPAY_AGENT_REGISTRATION
        confirmationViewController.confirmationTitlesArray = confirmationTitlesArray as Array<AnyObject>
        confirmationViewController.confirmationValuesArray = confirmationValuesArray as Array<AnyObject>
        confirmationViewController.confirmationRequestDictonary = dict
        self.navigationController!.pushViewController(confirmationViewController, animated: true)
        
        
    }
    
    func getImageString(targetImage:UIImage )->NSString
    {
        
        let newImageData = UIImagePNGRepresentation(targetImage)
        let newImage = UIImage(data: newImageData!)
        let compressedNewImageData = compressImage(newImage!)
        let imageSize3: Int = compressedNewImageData.length
        print("compressedNewImageData in KB 3 : %f ", Double(imageSize3) / 1024.0)
        
        //step3SelectProof3.setBackgroundImage(UIImage(data: compressedNewImageData), forState: .Normal)
        
        let imageString = compressedNewImageData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
        return imageString
        
    }
    
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRectMake(posX, posY, edge, edge)
        
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    func compressImage(image:UIImage) -> NSData {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.drawInRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        
        return imageData!;
    }
    
    
    // MARK: UITextField Delegate Methods
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if textField.tag == 201 || textField.tag == 202 || textField.tag == 203 || textField.tag == 204
        {
            return true
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        let maxLength = 16
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        return  newString.length <= maxLength
        
    }
    
    // MARK: UITextView Delegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView.tag == 99 {
          if textView.textColor == UIColor.lightGrayColor()
          {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
          }
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView.tag == 99 {
            
            if textView.text.isEmpty {
                textView.text = domicilAddresPlaceholder
                textView.textColor = UIColor.lightGrayColor()
            }
        }
        
    }
    
    
    // MARK: Step 2 Service Calls
    
    
    func makeProvinsiServiceCall(sender:UITextField , pickerView:UIPickerView)
    {
        /*
         
         For Provinsi
         -------------
         category=category.province&service=Payment&channelID=7&txnName=GetThirdPartyData&version=0&institutionID=&mspID=1&accountType=
         
         for Kota/Keb
         --------------
         regionName=&state=ACEH&service=Payment&channelID=7&txnName=GetThirdPartyLocation&city=&institutionID=&mspID=1&accountType=
         
         for Kecamatan
         ----------------
         regionName=KAB.+ACEH+SELATAN&state=ACEH&service=Payment&channelID=7&txnName=GetThirdPartyLocation&city=&institutionID=&mspID=1&accountType=
         
         for Desa
         ----------
         state=ACEH&regionName=KAB.+ACEH+SELATAN&service=Payment&channelID=7&txnName=GetThirdPartyLocation&city=BAKONGAN&institutionID=&mspID=1&accountType=
         
         
         */
        
        var dict = NSMutableDictionary() as [NSObject : AnyObject]
        dict[CATEGORY] = CATEGORY_PROVIENCE
        dict[SERVICE] = SERVICE_PAYMENT
        dict[VERSION] = "0"
        
        
        if sender.tag == 201  {
         dict[TXNNAME] = TXN_GetThirdPartyData
        }
        if sender.tag == 202 {
            let stateTextField = step2ContentView.viewWithTag(201) as! UITextField
            dict[TXNNAME] = TXN_GetThirdPartyDataLocation
            dict[STATE] = stateTextField.text
            dict[REGIONAME] = ""
            dict[CITY] = ""
        }
        if sender.tag == 203 {
            let stateTextField = step2ContentView.viewWithTag(201) as! UITextField
            let regionTextField = step2ContentView.viewWithTag(202) as! UITextField
            dict[TXNNAME] = TXN_GetThirdPartyDataLocation
            dict[STATE] = stateTextField.text
            dict[REGIONAME] = regionTextField.text
            dict[CITY] = ""
        }
        if sender.tag == 204 {
            
            let stateTextField = step2ContentView.viewWithTag(201) as! UITextField
            let regionTextField = step2ContentView.viewWithTag(202) as! UITextField
            let cityTextField = step2ContentView.viewWithTag(203) as! UITextField
            
            dict[TXNNAME] = TXN_GetThirdPartyDataLocation
            dict[STATE] = stateTextField.text
            dict[REGIONAME] = regionTextField.text
            dict[CITY] = cityTextField.text
        }
        
        
        if(!SimaspayUtility.isConnectedToNetwork())
        {
            SimasPayAlert.showSimasPayAlert(SHOW_INTERNET_MSG, viewController: self)
            return
        }
        
        print("Provience Params : ",dict)
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        ServiceModel.connectJSONURL(SIMASPAY_URL,postData: dict,successBlock: { (response) -> Void in
            // Handle success response
            dispatch_async(dispatch_get_main_queue()) {
                
                EZLoadingActivity.hide()
                print("Provience Data : ",response)
                let responseDict = response as! NSDictionary
                
                if sender.tag == 201  {
                    self.provienceViewData = responseDict.valueForKeyPath("indonesia.province") as! NSArray
                    self.pickerViewData = responseDict.valueForKeyPath("indonesia.province") as! NSArray
                    
                    let currentTextField = self.step2ContentView.viewWithTag(202) as! UITextField
                    currentTextField.enabled = true
                    
                }
                if sender.tag == 202 {
                    self.regionData = responseDict.valueForKey("region") as! NSArray
                    self.pickerViewData = responseDict.valueForKey("region") as! NSArray
                    let currentTextField = self.step2ContentView.viewWithTag(203) as! UITextField
                    currentTextField.enabled = true
                }
                if sender.tag == 203 {
                    self.stateViewData = responseDict.valueForKey("district") as! NSArray
                    self.pickerViewData = responseDict.valueForKey("district") as! NSArray
                    let currentTextField = self.step2ContentView.viewWithTag(204) as! UITextField
                    currentTextField.enabled = true
                }
                if sender.tag == 204 {
                    self.cityViewData = responseDict.valueForKey("village") as! NSArray
                    self.pickerViewData = responseDict.valueForKey("village") as! NSArray
                }
                pickerView.reloadAllComponents()
            }
            
            }, failureBlock: { (error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    EZLoadingActivity.hide()
                    SimasPayAlert.showSimasPayAlert(error.localizedDescription,viewController: self)
                }
                
        })
    }

}