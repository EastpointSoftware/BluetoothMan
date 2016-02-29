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
        if let stringValues = characteristic.stringValue {
            let names = Array(stringValues.keys)
            let values = Array(stringValues.values)
            
            for var i = names.count; i < names.count; i++ {
                
                self.characteristicValue.text = self.characteristicValue.text! + names[i] + " : "
                self.characteristicValue.text = self.characteristicValue.text! + values[i] + " / "
                
            }
            
            
        }else{
            print("No String Values")
        }
        
    }
    
   
    @IBAction func onSetNotify(sender: AnyObject) {
        
        if  notifyValue.on {
            var error : NSError?
            
            self.characteristic.startNotifying()
            
            if let characteristic = self.characteristic {
                if characteristic.isNotifying {
                    let future = characteristic.recieveNotificationUpdates()
                    future.onSuccess {_ in
                        
                        self.characteristicValue.text = characteristic.cbCharacteristic.value?.hexStringValue()
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
                
            
            
            
        }else{
            
            
            self.characteristic.stopNotifying()
        }
        
    }
    
    

    }


}