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
    
    var writeCharacteristic : Characteristic!
    var readCharacteristic  : Characteristic!
    var readWriteCharacteristics : (Characteristic,Characteristic)!
    var error: NSError!
    var progressView : ProgressView!

    
    @IBOutlet weak var readChartxt: UITextField!
    @IBOutlet weak var writeCharTxt: UITextField!
    @IBOutlet weak var valueToWrite: UITextField!
    @IBOutlet weak var LogMessageView: UITextView!
    @IBOutlet weak var serviceUUIDText: UITextField!
    @IBOutlet weak var notifySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        LogMessageView.text = ""
         self.readChartxt.text = "NO"
        
        ///Step 1 - Check that segue passed service is valid
        if service == nil {
            LogMessage("Service object is Nil ")
        }else{
            self.navigationItem.title = service.name
           
            //readServiceCharacteristics()
        }
        
        ///Step 2 - Set the subscribe switch to off on initial load
        
       self.notifySwitch.setOn(false, animated: true)
        
        
        ///Step 3 - Loop through characteristics in the service and find the ones we are interested in
        self.identifyCharacteristics()
        
        
        ///Step 4 - Receive Notification updates
        
        
        
    
    }
    
    
    func receiveUpdates(){
        
        Logger.debug()
        
        if let characteristic = self.readCharacteristic {
            if characteristic.isNotifying {
                let future = characteristic.recieveNotificationUpdates(10)
                future.onSuccess {_ in
                    
                    self.readChartxt.text = characteristic.stringValue![characteristic.name]
                }
                future.onFailure{(error) in
                    self.presentViewController(UIAlertController.alertOnError("Characteristic Notification Error", error:error), animated:true, completion:nil)
                }
            } else if characteristic.propertyEnabled(.Read) {
                self.progressView.show()
                let future = characteristic.read(Double(ConfigStore.getCharacteristicReadWriteTimeout()))
                future.onSuccess {_ in
                    
                    self.progressView.remove()
                    self.readChartxt.text = characteristic.stringValue![characteristic.name]
                }
                future.onFailure {(error) in
                    self.progressView.remove()
                    self.presentViewController(UIAlertController.alertOnError("Charcteristic Read Error", error:error) {(action) in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                        }, animated:true, completion:nil)
                }
            }
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func identifyCharacteristics(){
        
        Logger.debug()
        
        let readCharacteristicCarista  : CBUUID = CBUUID(string: "FFF1")
        let writeCharacteristicCarista : CBUUID = CBUUID(string: "FFF2")
        let readCharacteristicSensorTag : CBUUID = CBUUID(string: "FFE1")

        
        for  characteristic in self.service.characteristics {
            self.LogMessage(characteristic.name + "  " + characteristic.cbCharacteristic.UUID.UUIDString )
            
            if characteristic.canRead || characteristic.canNotify {
                
                self.readCharacteristic = characteristic
                
                if characteristic.uuid.isEqual(readCharacteristicCarista) {
                    LogMessage("Read Characteristic found ")
                }
                if characteristic.uuid.isEqual(readCharacteristicSensorTag) {
                    LogMessage("Read Characteristic found for Sensor tag ")
                }

                
            }
            if characteristic.canWrite {
                
                self.writeCharacteristic = characteristic
                if characteristic.uuid.isEqual(writeCharacteristicCarista) {
                        LogMessage("Write Characteristic found ")
                }
                
            }
            
           
            
        }
        Logger.debug()
 
        
    }
    
    
    @IBAction func toggleNotify() {
        Logger.debug()
        
        if self.readCharacteristic == nil {
            self.LogMessage("Read Characteristic object is nil")
            return
        }
        
        if self.readCharacteristic.isNotifying  {
            let future = self.readCharacteristic.stopNotifying()
            future.onSuccess {_ in
                
                self.readCharacteristic.stopNotificationUpdates()
            }
            future.onFailure {(error) in
                self.notifySwitch.on = false
                
                self.presentViewController(UIAlertController.alertOnError("Stop Notifications Error", error:error), animated:true, completion:nil)
            }
        } else {
            let future = self.readCharacteristic.startNotifying()
            future.onSuccess {_ in
                self.LogMessage("Notification Started Successfully")
                self.receiveUpdates()
                
            }
            future.onFailure {(error) in
                self.notifySwitch.on = false
               
                self.presentViewController(UIAlertController.alertOnError("Start Notifications Error", error:error), animated:true, completion:nil)
            }
        }

        
        
        
    }

    
    
    func LogMessage(message : String) {
        
        LogMessageView.text = message + "\n\r " + LogMessageView.text
    }
    
    
    func readServiceCharacteristics() {
        Logger.debug()

        let readCharacteristic  : CBUUID = CBUUID(string: "FFF1")
        let writeCharacteristic : CBUUID = CBUUID(string: "FFF2")
        var data : NSData?
        
    
        self.writeCharacteristic = nil
        self.readCharacteristic = nil
        
        for  characteristic in self.service.characteristics {
            
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
            // PID - 01 => Current Data
            // PID - 0c => RPM data
            
            //var data: NSData = NSData(bytes: [0x01, 0x00] as [UInt8], length: 2)
            //self.readCharacteristic.service?.peripheral?.writeValue(data, forCharacteristic: self.readCharacteristic)

           
            //Subscribe for notification
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
            
            
            data = NSData(bytes: [0x01, 0x0c] as [UInt8], length: 2)
            
            self.writeCharacteristic.service?.peripheral?.writeValue(data!, forCharacteristic: self.writeCharacteristic)
           
           
            
        }
        
    }
    
    
    
    
    
    
    
    
    

}







