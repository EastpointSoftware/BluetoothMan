//
//  PeripheralServiceCharacteristicDetailsViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 28/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import UIKit

class PeripheralServiceCharacteristicDetailsViewController :UIViewController {
    
    
    //Segue passed objects
    
    weak var characteristic : Characteristic!
    var peripheralViewController    : PeripheralViewController?
    
    //Storyboard Outlets for programming reference
    
    @IBOutlet weak var peripheralUUID: UILabel!
    @IBOutlet weak var ServiceUUID: UILabel!
    @IBOutlet weak var characteristicUUID: UILabel!
    @IBOutlet weak var notifyValue: UISwitch!
    @IBOutlet weak var characteristicValue: UITextField!
    
    //user defined varibales
    
    //user defined constants
    
    override func viewDidLoad() {
        
        self.UISetup()
        //self.characteristic.startNotifying()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.UISetup()
        
    }
    
    func UISetup(){
        Logger.debug()
        
        self.peripheralUUID.text = self.characteristic.peripheralUUID.UUIDString
        self.ServiceUUID.text = self.characteristic.serviceUUID.UUIDString
        self.characteristicUUID.text = self.characteristic.uuid.UUIDString
        self.notifyValue.setOn(false, animated: true)
        
    }
    
    
    
    //=======
    
    @IBAction func onSetNotify(sender: AnyObject) {
        
        if let characteristic = self.characteristic {
            if characteristic.isNotifying{
                let future = characteristic.startNotifying()
                future.onSuccess { _ in
                    Logger.debug("Notification Started")
                    self.notify()
                }
                
                future.onFailure { (error) in
                    
                    self.presentViewController(UIAlertController.alertOnError("Start Notifications Error", error:error), animated:true, completion:nil)
                }
            }else{
                
                let future = characteristic.stopNotifying()
            }
            
            
            
            
        }
        
    }
    
    //=========
    
    
    func notify(){
        
        if let characteristic = self.characteristic {
            if characteristic.isNotifying {
                let future = characteristic.recieveNotificationUpdates()
                
                
                future.onSuccess {_ in
                   
                    self.updateUI()
                    
                }
                future.onFailure{(error) in
                    self.presentViewController(UIAlertController.alertOnError("Characteristic Notification Error", error:error), animated:true, completion:nil)
                }
            }
            
            
        }
        
    }
    
    func updateUI(){
        
        if let characteristic = self.characteristic {
            if let stringValues = characteristic.stringValue {
                let names = Array(stringValues.keys)
                let values = Array(stringValues.values)
                if names.count>0 {
                    self.characteristicValue.text = " ss" + names[0] + " : " +  values[0]
                }else{
                    
                    self.characteristicValue.text = "UNKNOWN"
                }
                
            }
            
        }
        
        
    }
    
    
    
    ///-============
    
    
}





