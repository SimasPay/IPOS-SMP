//
//  ListTransferViewController.swift
//  Simaspay
//
//  Created by Dimo on 10/25/16.
//  Copyright © 2016 Kendy Susantho. All rights reserved.
//

import UIKit

class ListTransferViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var arrayMenu: NSArray = []
    @IBOutlet var tableView: UITableView!
    static func initWithOwnNib() -> ListTransferViewController {
        let obj:ListTransferViewController = ListTransferViewController.init(nibName: String(describing: self), bundle: nil)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle("Transfer")
        self.showBackButton()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.rowHeight = 56
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Array of list bank menu transfer
        self.arrayMenu = [[
                          "title" : "Bank Sinarmas",
                          "action" : TransferBankViewController.initWithOwnNib(type: TransferType.TransferTypeSinarmas)],
                          [
                          "title" : "Bank Lainnya",
                          "action" : TransferOtherBankListViewController.initWithOwnNib()],
                          [
                          "title" : "Laku Pandai",
                          "action" : TransferBankViewController.initWithOwnNib(type: TransferType.TransferTypeSinarmas)],
                          [
                          "title" : "Uangku",
                          "action" : TransferBankViewController.initWithOwnNib(type: TransferType.TransferTypeSinarmas)],
                          [
                          "title" :"E-money Lainnya",
                          "action" : TransferBankViewController.initWithOwnNib(type: TransferType.TransferTypeSinarmas)]
                        ];
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayMenu.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        cell.accessoryType = .disclosureIndicator;
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.text =  (self.arrayMenu[indexPath.row] as? NSDictionary)?.value(forKey: "title") as! String?
        return cell
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = (self.arrayMenu[indexPath.row] as! NSDictionary).value(forKey:"action")
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
    

    
}
