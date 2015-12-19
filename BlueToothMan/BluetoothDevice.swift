//
//  BluetoothDevice.swift
//  BlueToothMan
//
//  Created by Jeeva on 19/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDevice {
    
    var device : CBPeripheral!
    var rssi : NSNumber!
    var advertisementData: [String : AnyObject]!
    
    
}