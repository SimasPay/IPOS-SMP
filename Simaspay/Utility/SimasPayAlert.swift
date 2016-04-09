//
//  SimasPayAlert.swift
//  Simaspay
//
//  Created by Rajesh Pothuraju on 03/03/16.
//  Copyright © 2016 RAND Software Service (india) PVT LTD. All rights reserved.
//

import Foundation
import UIKit

class SimasPayAlert: NSObject
{
    
    class func showSimasPayAlert(var message :String, viewController:UIViewController)
    {
        
        if (message == "Could not connect to the server.") {
            message = "Tidak dapat terhubung ke server."
        }
        
        if (message == "A server with the specified hostname could not be found."){
            message = SHOW_INTERNET_MSG
        }
        
        if (message == "The Internet connection appears to be offline."){
            message = SHOW_INTERNET_MSG
        }
        
        if (message == "The network connection was lost."){
            message = SHOW_NETWORK_LOST
        }
        
        if (message == "A connection failure occurred"){
            message = SHOW_NETWORK_LOST
        }
        
        
        if #available(iOS 8.0, *) {
            let alert : UIAlertController = UIAlertController(title: "SimasPay", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style:.Default, handler: nil))
            viewController.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            
            let alert = UIAlertView()
            alert.title = "SimasPay"
            alert.message = message
            alert.addButtonWithTitle("OK")
            alert.show()
            
        }
        
        
    }
    
    
    
}
