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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        deviceNameLabel.text = receivedDevice.device.name
        deviceUUIDLabel.text = receivedDevice.device.identifier.UUIDString
        deviceRSSILabel.text = "\(receivedDevice.rssi)"
        deviceAdvertDataLabel.text = "\(receivedDevice.advertisementData)"
        
        
        
        
    }
    
    
}