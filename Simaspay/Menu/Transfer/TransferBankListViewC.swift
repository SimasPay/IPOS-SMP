//
//  TransferBankListViewC.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 16/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class TransferBankListViewC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
    
    var simasPayOptionType:SimasPayOptionType!
    var historyTabeView : UITableView!
    var searchActive : Bool = false
    var searchBar : UISearchBar!
    
    var data = ["Bank Bukopin","BCA","Bank CIMB Niaga","Bank Danamon","Bank Hana","Bank ICBC Indonesia","Bank Index Selindo","Bank Maybank Indonesia","Bank Maspion","Bank Mayapada","Bank Mega","Bank OCBC NISP"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "Pilih Bank"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,NSForegroundColorAttributeName:UIColor(netHex: Constants.NavigationTitleColor)]
        
        
        
        self.view.backgroundColor = UIColor(netHex: 0xF3F3F3)
        
        var initialScrollViews = [String: UIView]()
        
        
        historyTabeView = UITableView(frame: view.bounds, style: .Plain)
        historyTabeView.translatesAutoresizingMaskIntoConstraints = false
        historyTabeView.rowHeight = UITableViewAutomaticDimension
        historyTabeView.estimatedRowHeight = 44
        historyTabeView.delegate = self
        historyTabeView.dataSource = self
        self.view.addSubview(historyTabeView)
        
        let tblView =  UIView(frame: CGRectZero)
        historyTabeView.tableFooterView = tblView
        historyTabeView.tableFooterView!.hidden = true
        
        historyTabeView.registerNib(UINib(nibName: "TransactionHistoryCell", bundle: nil), forCellReuseIdentifier: "CustomCellOne")
        initialScrollViews["historyTabeView"] = historyTabeView
        
        
        searchBar  = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        searchBar.barTintColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
        initialScrollViews["searchBar"] = searchBar
        
        //searchBar.layer.borderColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 0.5).CGColor
        //searchBar.layer.borderWidth = 0;
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(0)-[historyTabeView]-\(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(0)-[searchBar]-\(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(63)-[searchBar(44)]-0-[historyTabeView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: initialScrollViews))
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    func popToRoot(sender:UIBarButtonItem)
    {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        self.searchBar.resignFirstResponder()
        
        if(indexPath.row == 1)
        {
            let viewController = TransferBankLainViewC()
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.historyTabeView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:14)
        return cell;
    }
    
    
    
    
}