//
//  InteractViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 11/02/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class InteractViewController : UIViewController {

    var service : Service!
    
    var writeCharacteristic : Characteristic!;
    var readCharacteristic  : Characteristic!;

    
    @IBOutlet weak var readChartxt: UITextField!
    
    @IBOutlet weak var writeCharTxt: UITextField!
    
    @IBOutlet weak var valueToWrite: UITextField!
    
    @IBOutlet weak var LogMessageView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogMessageView.text = ""
        if service == nil {
            LogMessage("Service object is Nil ")
        }else{
            self.navigationItem.title = service.name
        }
        
        
        
        readServiceCharacteristics()
        
        
    
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    
    
    
    func LogMessage(message : String) {
        
        LogMessageView.text = message + "\n\r " + LogMessageView.text
    }
    
    
    func readServiceCharacteristics() {

        self.writeCharacteristic = nil
        self.readCharacteristic = nil
        
        
        
        let readCharacteristic  : CBUUID = CBUUID(string: "FFF1")
        let writeCharacteristic : CBUUID = CBUUID(string: "FFF2")
        var error : NSError?
    
        for var characteristic in service.characteristics {
            
            
            if characteristic.uuid.isEqual(readCharacteristic) {
                
                self.readCharacteristic = characteristic
                
                LogMessage("Read Characteristic found ")
                
            }else if characteristic.uuid.isEqual(writeCharacteristic) {
                
                self.writeCharacteristic = characteristic
                LogMessage("Write Characteristic found ")
            }
            
            
            
        }
        
        
        
        if self.writeCharacteristic != nil && self.readCharacteristic != nil {
        
            
            
            var data: NSData = NSData(bytes: [0x01, 0x00] as [UInt8], length: 2)
            
            self.readCharacteristic.service?.peripheral?.writeValue(data, forCharacteristic: self.readCharacteristic)
            
            self.readCharacteristic.service?.peripheral?.didUpdateValueForCharacteristic(self.readCharacteristic.cbCharacteristic , error : error)

            
            error = nil
            
            self.readCharacteristic.didUpdate(error)
            
            if error != nil {
                
                let hexString : String = data.hexStringValue()
                
                 LogMessage( "Updated Value  \(hexString) ")
            }
            
            data = NSData(bytes: [0x01, 0x0c] as [UInt8], length: 2)
            
            self.writeCharacteristic.service?.peripheral?.writeValue(data, forCharacteristic: self.writeCharacteristic)
           
           
            
        }
    
        
        
}

}







