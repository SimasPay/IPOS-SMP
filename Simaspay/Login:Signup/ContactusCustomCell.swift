//
//  ContactusCustomCell.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 30/12/15.
//  Copyright © 2015 RAND Software Service (india) PVT LTD. All rights reserved.
//

import UIKit

class ContactusCustomCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let cvb = self.contentView.bounds
        //let imf = self.imageView!.frame
        //self.imageView!.frame.origin.x = cvb.size.width - imf.size.width - 15
        self.textLabel!.frame.origin.y = 20
        self.detailTextLabel!.frame.origin.y = self.textLabel!.frame.origin.y + 40
        self.detailTextLabel!.frame.size.width = self.frame.size.width
        //self.detailTextLabel!.font = self.textLabel!.font
    }
}
