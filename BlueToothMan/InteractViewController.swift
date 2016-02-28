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
        Logger.debug()

        let readCharacteristic  : CBUUID = CBUUID(string: "FFF1")
        let writeCharacteristic : CBUUID = CBUUID(string: "FFF2")
        var data : NSData?
        var error : NSError?
    
        self.writeCharacteristic = nil
        self.readCharacteristic = nil
        
        for  characteristic in service.characteristics {
            
            if characteristic.uuid.isEqual(readCharacteristic) {
         
                self.readCharacteristic = characteristic
                LogMessage("Read Characteristic found ")
                
            }else if characteristic.uuid.isEqual(writeCharacteristic) {
                
                self.writeCharacteristic = characteristic
                LogMessage("Write Characteristic found ")
            }
            
        }
        
        //get the current values from the characteristics
        
       // readChartxt.text = "\(self.readCharacteristic.service?.peripheral?.readValueForCharacteristic(self.readCharacteristic))"
        
        
        
        if self.writeCharacteristic != nil && self.readCharacteristic != nil {
            Logger.debug("Found read and write characteristics")
        
            //Construct Initial Command to get a list of vehicle supported PIDs 
            // PID - 01 =>
            // PID - 00 => Most supported pids to get the list of supported pids
            // Online Reference : https://learn.sparkfun.com/tutorials/obd-ii-uart-hookup-guide
            
            //var data: NSData = NSData(bytes: [0x01, 0x00] as [UInt8], length: 2)
            
            //self.readCharacteristic.service?.peripheral?.writeValue(data, forCharacteristic: self.readCharacteristic)

           
            self.readCharacteristic.startNotifying()
            
            
            
            if let characteristic = self.readCharacteristic {
                if characteristic.isNotifying {
                    let future = characteristic.recieveNotificationUpdates()
                    future.onSuccess {_ in
                        
                        self.readChartxt.text = characteristic.cbCharacteristic.value?.hexStringValue()
                    }
                    future.onFailure{(error) in
                        self.presentViewController(UIAlertController.alertOnError("Characteristic Notification Error", error:error), animated:true, completion:nil)
                    }
                } else{
                    
                    self.presentViewController(UIAlertController.alertOnError("Charcteristic Read Error", error:error!) {(action) in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                        }, animated:true, completion:nil)
                }
                
            }
            
            
            //self.readCharacteristic.service?.peripheral?.didUpdateValueForCharacteristic(self.readCharacteristic.cbCharacteristic , error : error)

                       
            // PID - 01 => Current Data
            // PID - 0c => RPM data
            
            
            
            
            
            data = NSData(bytes: [0x01, 0x0c] as [UInt8], length: 2)
            
            self.writeCharacteristic.service?.peripheral?.writeValue(data!, forCharacteristic: self.writeCharacteristic)
           
           
            
        }
        
    }
    
    
    
    

}







