//
//  SecurityQuestionViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/11/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class SecurityQuestionViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var lblInfo: BaseLabel!
    @IBOutlet weak var btnRegister: BaseButton!
    @IBOutlet weak var tfAnswer: BaseTextField!
    @IBOutlet weak var tfQuestion: BaseTextField!
    @IBOutlet weak var viewTFQuetion: UIView!
    @IBOutlet weak var viewTfAnswer: UIView!
    @IBOutlet weak var constraintHeightBtn: NSLayoutConstraint!
   
    var pickOption:[String]!
    var questionData : NSArray!
    var data: NSDictionary!
    var MDNString:String!
    var questionArray: [String] = []
    var dictForAcceptedOTP: NSDictionary!
    let pickerView = UIPickerView()
    
    static func initWithOwnNib() -> SecurityQuestionViewController {
        let obj:SecurityQuestionViewController = SecurityQuestionViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton(subMenu: false)
        self.showTitle("Pendaftaran Akun E-money", subMenu: false)
        lblInfo.font = UIFont.systemFont(ofSize: 18)
        lblInfo.textColor = UIColor.init(hexString: color_text_default)
        lblInfo.numberOfLines = 3;
        lblInfo.textAlignment = .center
        lblInfo.text = getString("SecurityQuestionInfoTitle")
        
        tfQuestion.font = UIFont.systemFont(ofSize: 16)
        tfQuestion.text = getString("SecurityQuestionTextfieldQuestion")
        tfQuestion.addInset()
        tfQuestion.rightViewMode =  UITextFieldViewMode.always
        tfQuestion.updateTextFieldWithRightImageNamed("icon_arrow_down")
        
        
        tfAnswer.placeholder = getString("SecurityQuestionTextfieldAnswerPlaceholder")
        tfAnswer.addInset()
        tfAnswer.font = UIFont.systemFont(ofSize: 16)
        
        btnRegister.updateButtonType1()
        btnRegister.setTitle(getString("SecurityQuestionButtonTitle"), for: .normal)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        for question in questionData {
            print((question as! NSDictionary).value(forKey: "question") as! String)
            questionArray.append((question as! NSDictionary).value(forKey: "question") as! String)
        }
        self.pickOption = questionArray
        pickerView.delegate = self
        tfQuestion.delegate = self
        tfQuestion.font = UIFont.systemFont(ofSize: 14)
        tfAnswer.delegate = self
        self.tfQuestion.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTFQuetion.updateViewRoundedWithShadow()
        viewTfAnswer.updateViewRoundedWithShadow()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         
    }
    
    //MARK: PickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = questionArray[row]
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 13)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickOption.count
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickOption[row]
    }
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.tfQuestion.text = pickOption[row]
    }
    
    @IBAction func actionShowPicker(_ sender: Any) {
        
    }
    
    //MARK: keyboard Show set last object above keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfQuestion{
            constraintHeightBtn.constant = 56
            BaseViewController.lastObjectForKeyboardDetector = self.tfQuestion.superview
        }else if textField == tfAnswer{
            BaseViewController.lastObjectForKeyboardDetector = self.tfAnswer.superview
        }
        updateUIWhenKeyboardShow()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        constraintHeightBtn.constant = 0
    }


    //MARK: Action button Register
    @IBAction func actionBtnRegister(_ sender: AnyObject) {
        
        var message = "";
        if (!tfQuestion.isValid() || self.tfQuestion.text == getString("SecurityQuestionTextfieldQuestion")) {
            message = "Masukkan pertanyaan Anda"
        } else if (!tfAnswer.isValid()) {
            message = "Masukkan jawaban Anda"
        }
        
        if (message.characters.count > 0) {
            DIMOAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }

        
        //Dictionary data for request OTP
        DLog("\(dictForAcceptedOTP as NSDictionary)")
        let vc = ConfirmationViewController.initWithOwnNib()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dict = NSMutableDictionary()
        dict[TXNNAME] = GENETARE_OTP
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[SOURCEMDN] = getNormalisedMDN((dictForAcceptedOTP as NSDictionary).value(forKey: SOURCEMDN) as! NSString)
        dict[CHANNEL_ID] = "7"
        dict[SOURCE_APP_TYPE_KEY] = SOURCE_APP_TYPE_VALUE
        dict[SOURCE_APP_VERSION_KEY] = version
        dict[SOURCE_APP_OSVERSION_KEY] = "\(UIDevice.current.modelName)  \(UIDevice.current.systemVersion)"
        vc.dictForRequestOTP = dict as NSDictionary
        
        vc.data = self.data
        vc.MDNString = self.MDNString

        //Dictionary data for send OTP
        let dict1 = NSMutableDictionary()
        dict1[TXNNAME] = TXN_SUBSCRIBER_KTP_REGISTRATION
        dict1[SERVICE] = SERVICE_ACCOUNT
        dict1[INSTITUTION_ID] = SIMASPAY
        dict1[AUTH_KEY] = ""
        dict1[SOURCEMDN] = getNormalisedMDN((dictForAcceptedOTP as NSDictionary).value(forKey: SOURCEMDN) as! NSString)
        dict1[CHANNEL_ID] = "7"
        dict1[SECURITY_QUESTION] = self.tfQuestion.text!
        dict1[SECURITY_ANSWER] = self.tfAnswer.text!

        let temp = NSMutableDictionary(dictionary: dict1);
        temp.addEntries(from: dictForAcceptedOTP as! [AnyHashable : Any])
        vc.dictForAcceptedOTP = temp as NSDictionary
        vc.useNavigation = false
        self.navigationController?.pushViewController(vc, animated: false)
    }

    
}
