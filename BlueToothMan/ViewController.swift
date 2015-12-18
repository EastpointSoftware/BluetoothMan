//
//  ViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 18/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {

    var centralManager : CBCentralManager!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        
    }
    
    func StartScanning(){
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
        
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        print("haha")
        print("******************")
        print("Name   : \(peripheral.name)")
        print("UUID   : \(peripheral.identifier.UUIDString)")
        print("Advert : \(advertisementData)")
        print("RSSI   : \(RSSI)")
        print("******************")
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        print("We are in Central Manager did update state")
        if central.state == CBCentralManagerState.PoweredOn {
            print("Bluetooth is ON")
            StartScanning()
        }else
        {
            let alertViewController = UIAlertController(title: "Bluetooth Man", message: "Make sure that your bluetooth is on", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Bluetooth Not working", style: UIAlertActionStyle.Default, handler: { (act  : UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertViewController.addAction(action)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            print("Bluetooth is OFF")
        }
        
    }

    
    

}

