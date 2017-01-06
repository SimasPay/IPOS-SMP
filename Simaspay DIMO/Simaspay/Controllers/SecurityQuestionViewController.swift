//
//  SecurityQuestionViewController.swift
//  Simaspay
//
//  Created by Dimo on 11/11/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class SecurityQuestionViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var btnRegister: BaseButton!
    @IBOutlet weak var tfAnswer: BaseTextField!
    @IBOutlet weak var viewTfAnswer: UIView!
    @IBOutlet weak var tfQuestion: BaseTextField!
    @IBOutlet weak var viewTFQuetion: UIView!
    @IBOutlet weak var lblInfo: BaseLabel!
    var pickOption:[String]!
    var questionData : NSArray!
    var data: NSDictionary!
    var MDNString:String!
    var questionArray: [String] = []
    var dictForAcceptedOTP: NSDictionary!
    
    static func initWithOwnNib() -> SecurityQuestionViewController {
        let obj:SecurityQuestionViewController = SecurityQuestionViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.showTitle("Pendaftaran Akun E-money")
        lblInfo.font = UIFont.systemFont(ofSize: 18)
        lblInfo.textColor = UIColor.init(hexString: color_text_default)
        lblInfo.numberOfLines = 3;
        lblInfo.textAlignment = .center
        lblInfo.text = "Silakan pilih dan jawab pertanyaan keamanan untuk keperluan reset mPIN Anda."
        
        tfQuestion.font = UIFont.systemFont(ofSize: 16)
        tfQuestion.text = "Pilih Pertanyaan Keamanan"
        tfQuestion.addInset()
        tfQuestion.rightViewMode =  UITextFieldViewMode.always
        tfQuestion.updateTextFieldWithRightImageNamed("icon_arrow_down")
        
        tfAnswer.placeholder = "Jawaban Anda…"
        tfAnswer.addInset()
        tfAnswer.font = UIFont.systemFont(ofSize: 16)
        
        btnRegister.updateButtonType1()
        btnRegister.setTitle("Daftar", for: .normal)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        for question in questionData {
            print((question as! NSDictionary).value(forKey: "question") as! String)
            questionArray.append((question as! NSDictionary).value(forKey: "question") as! String)
        }
        self.pickOption = questionArray
        let pickerView = UIPickerView()
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPCancel), name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActivationPinViewController.didOTPOK), name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPCancel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didOTPOK"), object: nil)
         
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        
    {
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

    @IBAction func actionBtnRegister(_ sender: AnyObject) {
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
        temp .addEntries(from: dictForAcceptedOTP as! [AnyHashable : Any])
        vc.dictForAcceptedOTP = temp as NSDictionary
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfQuestion{
            BaseViewController.lastObjectForKeyboardDetector = self.tfQuestion.superview
        }else if textField == tfAnswer{
             BaseViewController.lastObjectForKeyboardDetector = self.tfAnswer.superview
        }
        updateUIWhenKeyboardShow()
        return true
    }

    
}
