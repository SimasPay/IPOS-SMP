//
//  TransactionHistoryCell.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 15/02/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class Transaction {
    
    var name: String?
    var action: String?
    var price: String?
    
    var transactionDate: String?
    var transactionType: String?
    var transactionAmount: String?
    var isCreditOrDebit: String?
    
    init(TransactionData: [String: AnyObject]) {
        
        if let n = TransactionData["stockName"] as? String {
            name = n
        }
        
        if let a = TransactionData["action"] as? String {
            action = a
        }
        if let p = TransactionData["stockPrice"] as? Float {
            price = NSString(format: "%.2f", p) as String
        }
        
        if let n = TransactionData["stockName"] as? String {
            name = n
        }
        
        
        if let d = TransactionData["transactionDate"] as? String {
            transactionDate = d
        }
        
        if let t = TransactionData["transactionType"] as? String {
            transactionType = t
        }
        
        if let a = TransactionData["transactionAmount"] as? String {
            transactionAmount = a
        }
        
        if let cd = TransactionData["isCreditOrDebit"] as? String {
            isCreditOrDebit = cd
        }
        
        
    }
    
    var backgroundColor: UIColor {
        if action == "sell" {
            return UIColor.greenColor()
        }
        return UIColor.blueColor()
    }
    
    var typeColor: UIColor {
        if action == "sell" {
            return UIColor.blackColor()
        }
        return UIColor.purpleColor()
    }
    
    var priceLabelColor: UIColor {
        if action == "sell" {
            return UIColor.redColor()
        }
        return UIColor.greenColor()
    }
}


class TransactionHistoryCell: UITableViewCell {
    
    let padding: CGFloat = 5
    var background: UIView!
    var typeLabel: UILabel!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionPriceLabel: UILabel!
    
   /* var transactionDateLabel: UILabel?
    var transactionTypeLabel: UILabel?
    var transactionNameLabel: UILabel?
    var transactionPriceLabel:UILabel?
    
    
    var transaction: Transaction? {
        didSet {
            if let s = transaction {
                
                background.backgroundColor = s.backgroundColor
                priceLabel.text = s.price
                priceLabel.backgroundColor = s.priceLabelColor
                typeLabel.text = s.action
                typeLabel.backgroundColor = s.typeColor
                nameLabel.text = s.name
                
                
                transactionDateLabel?.text = "06/11/2015"
                transactionNameLabel?.text = "Transfer"
                transactionTypeLabel?.text = "credit"
                transactionPriceLabel?.text = "Rp 500.000"
                
                setNeedsLayout()
            }
        }
    }
    */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
       /* background = UIView(frame: CGRectZero)
        background.alpha = 0.6
        contentView.addSubview(background)
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.textAlignment = .Left
        nameLabel.textColor = UIColor.blackColor()
        contentView.addSubview(nameLabel)
        
        typeLabel = UILabel(frame: CGRectZero)
        typeLabel.textAlignment = .Center
        typeLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(typeLabel)
        
        priceLabel = UILabel(frame: CGRectZero)
        priceLabel.textAlignment = .Center
        priceLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(priceLabel)*/
        
        
     /*
        transactionDateLabel = UILabel(frame: CGRectZero)
        transactionDateLabel!.textAlignment = .Left
        transactionDateLabel!.textColor = UIColor.blackColor()
        contentView.addSubview(transactionDateLabel!)
        
        transactionNameLabel = UILabel(frame: CGRectZero)
        transactionNameLabel!.textAlignment = .Left
        transactionNameLabel!.textColor = UIColor.blackColor()
        contentView.addSubview(transactionNameLabel!)
        
        transactionTypeLabel = UILabel(frame: CGRectZero)
        transactionTypeLabel!.textAlignment = .Right
        transactionTypeLabel!.textColor = UIColor.blackColor()
        contentView.addSubview(transactionTypeLabel!)
        
        transactionPriceLabel = UILabel(frame: CGRectZero)
        transactionPriceLabel!.textAlignment = .Right
        transactionPriceLabel!.textColor = UIColor.blackColor()
        contentView.addSubview(transactionPriceLabel!)
        
        var viewsDict = [String: UIView]()
        viewsDict["contentView"] = contentView
        viewsDict["transactionDateLabel"] = transactionDateLabel
        viewsDict["transactionNameLabel"] = transactionNameLabel
        viewsDict["transactionTypeLabel"] = transactionTypeLabel
        viewsDict["transactionPriceLabel"] = transactionPriceLabel
        
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[transactionDateLabel][transactionTypeLabel(50)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[transactionNameLabel][transactionPriceLabel(==transactionNameLabel)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[transactionDateLabel(21)][transactionNameLabel(21)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[transactionTypeLabel(21)][transactionPriceLabel(21)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        
        */
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*background.frame = CGRectMake(0, padding, frame.width, frame.height - 2 * padding)
        typeLabel.frame = CGRectMake(padding, (frame.height - 25)/2, 40, 25)
        priceLabel.frame = CGRectMake(frame.width - 100, padding, 100, frame.height - 2 * padding)
        nameLabel.frame = CGRectMake(CGRectGetMaxX(typeLabel.frame) + 10, 0, frame.width - priceLabel.frame.width - (CGRectGetMaxX(typeLabel.frame) + 10), frame.height)*/
    }
}