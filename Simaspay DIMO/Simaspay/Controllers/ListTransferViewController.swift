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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        self.arrayMenu = ["Bank Sinarmas","Bank Lainnya","Laku Pandai","Uangku","E-money Lainnya"];
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        cell.textLabel?.text =  self.arrayMenu[indexPath.row] as? String
        return cell
    }
    
}
