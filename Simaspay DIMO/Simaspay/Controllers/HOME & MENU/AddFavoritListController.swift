//
//  AddFavoritListController.swift
//  Simaspay
//
//  Created by Abdul muhamad rosyid on 6/9/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import Foundation
class AddFavoritListController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelMdn: BaseLabel!
    @IBOutlet weak var inputMdn: BaseTextField!
    @IBOutlet weak var LabelDes: BaseLabel!
    @IBOutlet weak var inputDes: BaseTextField!
    @IBOutlet weak var btnNext: BaseButton!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    var value: String!
    var mPin: String!
    var favoriteCategoryID: String!
    var favoriteCode: String!
    
    static func initWithOwnNib() -> AddFavoritListController {
        let obj:AddFavoritListController = AddFavoritListController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(getString("Tambah ke Daftar Favorit"))
        self.showBackButton()
        self.viewBackground.backgroundColor = UIColor.init(hexString: color_background)
        
        self.labelMdn.font = UIFont .boldSystemFont(ofSize: 13)
        self.labelMdn.text = "Nomor Tujuan"
        
        self.LabelDes.font = self.labelMdn.font
        self.LabelDes.text = "Desrikpsi"

        btnNext.updateButtonType1()
        btnNext.setTitle(getString("TransferButtonNext"), for: .normal)
        
        self.inputMdn.font = UIFont.systemFont(ofSize: 14)
        self.inputMdn.addInset()
        self.inputMdn.text = self.value
        
        self.inputDes.font = UIFont.systemFont(ofSize: 14)
        self.inputDes.addInset()
        self.inputDes.delegate=self
        self.inputDes.tag = 2
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        self.constraintBottomScroll.constant = BaseViewController.keyboardSize.height
        self.view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        self.constraintBottomScroll.constant = 0
        self.view.layoutIfNeeded()
    }
    
    //MARK: Maximum Textfield length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 2 {
            let maxLength = 25
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    
    func nextProses() {
        let dict = NSMutableDictionary()
        dict[SERVICE] = SERVICE_ACCOUNT
        dict[TXNNAME] = TXN_ADD_FAVORITE
        dict[INSTITUTION_ID] = SIMASPAY
        dict[AUTH_KEY] = ""
        dict[SOURCEMDN] = getNormalisedMDN(UserDefault.objectFromUserDefaults(forKey: SOURCEMDN) as! NSString)
        dict[SOURCEPIN] = simasPayRSAencryption(self.mPin)
        dict[FAVORITE_CATEGORY_ID] = self.favoriteCategoryID
        dict[FAVORITE_CODE] = self.favoriteCode
        dict[FAVORITE_LABEL] = self.inputDes.text
        dict[FAVORITE_VALUE] = self.value
        
        DMBProgressHUD.showAdded(to: self.view, animated: true)
        let param = dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        DLog("\(dict)")
        SimasAPIManager .callAPI(withParameters: param) { (dict, err) in
            DMBProgressHUD .hideAllHUDs(for: self.view, animated: true)
            if (err != nil) {
                let error = err! as NSError
                if (error.userInfo.count != 0 && error.userInfo["error"] != nil) {
                    SimasAlertView.showAlert(withTitle: "", message: error.userInfo["error"] as! String, cancelButtonTitle: getString("AlertCloseButtonText"))
                } else {
                    SimasAlertView.showAlert(withTitle: "", message: error.localizedDescription, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                return
            }
            
            let dictionary = NSDictionary(dictionary: dict!)
            if (dictionary.allKeys.count == 0) {
                SimasAlertView.showAlert(withTitle: nil, message: String("ErrorMessageRequestFailed"), cancelButtonTitle: getString("AlertCloseButtonText"))
            } else {
                let responseDict = dictionary as NSDictionary
                DLog("\(responseDict)")
                let messagecode  = responseDict.value(forKeyPath: "message.code") as! String
                let messageText  = responseDict.value(forKeyPath: "message.text") as! String
                if ( messagecode == "2087" || messagecode == "2088" || messagecode == "2089" ){
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                            for vc in viewControllers {
                                if (vc.isKind(of: HomeViewController.self)) {
                                    self.navigationController!.popToViewController(vc, animated: true);
                                    return
                                }
                            }
                        }
                    }, cancelButtonTitle: "OK")
                } else if (messagecode == "631") {
                    SimasAlertView.showNormalTitle(nil, message: messageText, alert: UIAlertViewStyle.default, clickedButtonAtIndexCallback: { (index, alertview) in
                        if index == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
                        }
                    }, cancelButtonTitle: "OK")
                } else {
                    SimasAlertView.showAlert(withTitle: nil, message: messageText, cancelButtonTitle: getString("AlertCloseButtonText"))
                }
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: action next
    @IBAction func actionProses(_ sender: Any) {
        var message = "";
        if (!inputDes.isValid()) {
            message = "Silakan Masukkan Desrikpsi"
        } else if(inputDes.isValid() && inputDes.length() < 3){
            message = "Deskripsi hanya boleh berisi 3 sampai 25 karakter"
        }
        if (message.characters.count > 0) {
            SimasAlertView.showAlert(withTitle: "", message: message, cancelButtonTitle: getString("AlertCloseButtonText"))
            return
        }
        
        self.nextProses()
        
    }

}
