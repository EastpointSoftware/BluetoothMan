//
//  UITableViewControllerExtensions.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import UIKit

extension UITableViewController {
    
    func updateWhenActive() {
        if UIApplication.sharedApplication().applicationState == .Active {
            self.tableView.reloadData()
        }
    }
    
    func styleNavigationBar() {
        let font = UIFont(name:"Thonburi", size:20.0)
        var titleAttributes : [String:AnyObject]
        if let defaultTitleAttributes = UINavigationBar.appearance().titleTextAttributes {
            titleAttributes = defaultTitleAttributes
        } else {
            titleAttributes = [String:AnyObject]()
        }
        titleAttributes[NSFontAttributeName] = font
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    func styleUIBarButton(button:UIBarButtonItem) {
        let font = UIFont(name:"Thonburi", size:16.0)
        var titleAttributes : [String:AnyObject]
        if let defaultitleAttributes = button.titleTextAttributesForState(UIControlState.Normal) {
            titleAttributes = defaultitleAttributes
        } else {
            titleAttributes = [String:AnyObject]()
        }
        titleAttributes[NSFontAttributeName] = font
        button.setTitleTextAttributes(titleAttributes, forState:UIControlState.Normal)
    }
}
