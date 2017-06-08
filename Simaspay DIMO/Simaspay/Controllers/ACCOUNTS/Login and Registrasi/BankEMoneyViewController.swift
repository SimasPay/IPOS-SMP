//
//  BankEMoneyViewController.swift
//  Simaspay
//
//  Created by Dimo on 1/9/17.
//  Copyright © 2017 Kendy Susantho. All rights reserved.
//

import UIKit

class BankEMoneyViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var lblInfo: BaseLabel!
    @IBOutlet weak var tableView: UITableView!
    var accountArray:NSArray!
    static func initWithArray(data: NSArray) -> BankEMoneyViewController {
        let obj:BankEMoneyViewController = BankEMoneyViewController.init(nibName: String(describing: self), bundle: nil)
        obj.accountArray = data
        return obj
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblInfo.textAlignment = .center
        lblInfo.text = "Pilih Akun Simaspay Anda:"
        tableView.backgroundColor = UIColor.white
        tableView.layer.cornerRadius = 5
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.init(hexString: "f1f1f1").cgColor
        tableView.clipsToBounds = true;
        tableView.isScrollEnabled = false;
        tableView.delegate = self
        tableView.dataSource = self
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    //MARK: Tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65;
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = UITableViewCell(style: .default, reuseIdentifier: "contactus")
        temp.accessoryType = .disclosureIndicator;

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 65))
        view.backgroundColor = UIColor.clear
        view.addUnderline()
        
        let titleAccount = BaseLabel(frame: CGRect(x: 16, y: 11, width: 160, height: 18))
        titleAccount.font = UIFont.systemFont(ofSize: 20)
        titleAccount.text = (accountArray[indexPath.row] as! NSDictionary).value(forKey: "accountName") as! String?
        let numberAccount = BaseLabel(frame: CGRect(x: 16, y: 35, width: 160, height: 18))
        numberAccount.text = (accountArray[indexPath.row] as! NSDictionary).value(forKey: "numberAccount") as! String?
        view.addSubview(titleAccount)
        view.addSubview(numberAccount)
        temp.addSubview(view)
        view.isUserInteractionEnabled = true
        temp.isUserInteractionEnabled = true
        temp.selectionStyle = .none
        return temp
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        UserDefault.setObject((accountArray[indexPath.row] as! NSDictionary).value(forKey: "numberAccount") as! String?, forKey: ACCOUNT_NUMBER)
        
        // DLog("\(accountArray[indexPath.row] as! NSDictionary)")
        
        let vc = (self.accountArray[indexPath.row] as! NSDictionary).value(forKey:"accountType")
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)

    }

    @IBAction func actionLogout(_ sender: Any) {
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: SOURCEMDN)
        prefs.removeObject(forKey: ACCOUNT_NUMBER)
        prefs.removeObject(forKey: USERNAME)
        prefs.removeObject(forKey: GET_USER_API_KEY)
        prefs.removeObject(forKey: mPin)
        prefs.removeObject(forKey: "imageProfil")
        prefs.removeObject(forKey: EULAPBQR)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for vc in viewControllers {
            print(vc)
            if (vc.isKind(of: LoginRegisterViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            } else if (vc.isKind(of: LandingScreenViewController.self)) {
                self.navigationController!.popToViewController(vc, animated: true);
                return
            }
        }
        let vc = LoginRegisterViewController(nibName: "LoginRegisterViewController", bundle: nil)
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
