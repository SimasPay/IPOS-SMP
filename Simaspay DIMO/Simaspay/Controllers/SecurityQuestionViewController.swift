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
    var timerCount = 60
    var clock:Timer!
    var lblTimer: BaseLabel!
    var btnResandOTP: BaseButton!
    var tfOTP: BaseTextField!
    var pickOption:[String]!
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
        self.pickOption = ["one","two","three"]
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        tfQuestion.delegate = self
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
        self.showOTP()
    }

    func didOTPCancel() {
        DLog("cancel");
        clock.invalidate()
        
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

    
    func didOTPOK() {
        DLog("OK");
        clock.invalidate()
        let vc = ActivationSuccessViewController.initWithOwnNib()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func showOTP()  {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 400))
        let messageAlert = UILabel(frame: CGRect(x: 10, y: 0, width: temp.frame.size.width, height: 60))
        messageAlert.font = UIFont.systemFont(ofSize: 13)
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = 4
        messageAlert.text = "Kode OTP dan link telah dikirimkan ke nomor 08881234567. Masukkan kode tersebut atau akses link yang tersedia."
        
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ActivationPinViewController.countDown), userInfo: nil, repeats: true)
        
        btnResandOTP = BaseButton(frame: CGRect(x: 10, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 3, width: temp.frame.size.width, height: 15))
        btnResandOTP.setTitle("Kirim Ulang", for: .normal)
        btnResandOTP.setTitleColor(UIColor.init(hexString: color_btn_alert), for: .normal)
        btnResandOTP.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btnResandOTP.titleLabel?.textAlignment = .center
        btnResandOTP.addTarget(self, action: #selector(ActivationPinViewController.resendOTP), for: .touchUpInside)
        btnResandOTP.isHidden = true
        
        lblTimer = BaseLabel(frame: CGRect(x: 10, y: messageAlert.bounds.origin.y + messageAlert.bounds.size.height + 3, width: temp.frame.size.width, height: 15))
        lblTimer.textAlignment = .center
        lblTimer.font = UIFont.systemFont(ofSize: 12)
        lblTimer.text = "01:00"
        
        
        tfOTP = BaseTextField(frame: CGRect(x: 10, y: lblTimer.frame.origin.y + lblTimer.frame.size.height + 3, width: temp.frame.size.width, height: 30))
        tfOTP.borderStyle = .line
        tfOTP.layer.borderColor = UIColor.init(hexString: color_border).cgColor
        tfOTP.layer.borderWidth = 1;
        tfOTP.placeholder = "6 digit kode OTP"
        tfOTP.isSecureTextEntry = true
        tfOTP.addInset()
        
        temp.addSubview(btnResandOTP)
        temp.addSubview(lblTimer)
        temp.addSubview(messageAlert)
        temp.addSubview(tfOTP)
        
        showOTPWith(title: "Masukkan Kode OTP", view: temp)
    }
    func countDown(){
        if (timerCount > 0) {
            timerCount -= 1
            lblTimer.text = "00:\(timerCount)"
        } else {
            lblTimer.isHidden = true
            btnResandOTP.isHidden = false
        }
    }
    func resendOTP()  {
    clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ActivationPinViewController.countDown), userInfo: nil, repeats: true)
    
    }

}
