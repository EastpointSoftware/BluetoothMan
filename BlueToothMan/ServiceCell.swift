//
//  ServiceCell.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import UIKit

class ServiceCell : UITableViewCell {
    
    
    var delegate : Characteristic!
    @IBOutlet var nameLabel     : UILabel!
    @IBOutlet var uuidLabel     : UILabel!
    @IBOutlet var uartButton    : UIButton!
    var isClicked               : Bool = false
    
    
    
    @IBAction func InteractWithService(sender: AnyObject) {
        
        isClicked = true
        
    }
    
    
}
