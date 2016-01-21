//
//  UIAlertViewExtensions.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func alertOnError(title:String, error:NSError, handler:((UIAlertAction!) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title:title, message:error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:handler))
        return alert
    }
    
    class func alertOnErrorWithMessage(message:String, handler:((UIAlertAction!) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:handler))
        return alert
    }
    
    class func alertWithMessage(message:String, handler:((UIAlertAction!) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Alert", message:message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:handler))
        return alert
    }
    
}

