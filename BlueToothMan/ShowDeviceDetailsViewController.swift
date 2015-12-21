//
//  ShowDeviceDetailsViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 20/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth



class ShowDeviceDetailsViewController : UIViewController {
    
    var receivedDevice : BluetoothDevice!
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceUUIDLabel: UILabel!
    @IBOutlet weak var deviceRSSILabel: UILabel!
    @IBOutlet weak var deviceAdvertDataLabel: UILabel!

    @IBOutlet weak var deviceNameFromAdvertLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if receivedDevice.device.name != nil {
            deviceNameLabel.text = receivedDevice.device.name
        }else{
            deviceNameLabel.text = "nil"
        }
        deviceUUIDLabel.text = receivedDevice.device.identifier.UUIDString
        deviceRSSILabel.text = "\(receivedDevice.rssi)"
        deviceAdvertDataLabel.text = "\(receivedDevice.advertisementData)"
        let temp = NSDictionary (dictionary: receivedDevice.advertisementData)
        deviceNameFromAdvertLabel.text = "\(temp.objectForKey("kCBAdvDataIsConnectable")!)"
        //deviceNameFromAdvertLabel.text += receivedDevice.device.discoverServices( receivedDevice.device.identifier.UUIDString )
        
        
        
        
    }
    
    
}