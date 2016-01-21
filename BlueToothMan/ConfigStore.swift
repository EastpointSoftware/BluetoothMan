//
//  ConfigStore.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import Foundation
import CoreBluetooth
import CoreLocation

class ConfigStore {
    
    // scan mode
    class func getScanMode() -> String {
        if let scanMode = NSUserDefaults.standardUserDefaults().stringForKey("scanMode") {
            return scanMode
        } else {
            return "Promiscuous"
        }
    }
    
    class func setScanMode(scanMode:String) {
        NSUserDefaults.standardUserDefaults().setObject(scanMode, forKey:"scanMode")
    }
    
    // scan timeout
    class func getScanTimeoutEnabled() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("scanTimeoutEnabled")
    }
    
    class func setScanTimeoutEnabled(timeoutEnabled:Bool) {
        NSUserDefaults.standardUserDefaults().setBool(timeoutEnabled, forKey:"scanTimeoutEnabled")
    }
    
    class func getScanTimeout() -> Int {
        let timeout = NSUserDefaults.standardUserDefaults().integerForKey("scanTimeout")
        if timeout == 0 {
            return 20
        } else {
            return timeout
        }
    }
    
    class func setScanTimeout(timeout:Int) {
        NSUserDefaults.standardUserDefaults().setInteger(timeout, forKey:"scanTimeout")
    }
    
    // peripheral connection timeout
    class func getPeripheralConnectionTimeout() -> Int {
        let peripheralConnectionTimeout = NSUserDefaults.standardUserDefaults().integerForKey("peripheralConnectionTimeout")
        if peripheralConnectionTimeout == 0 {
            return 10
        } else {
            return peripheralConnectionTimeout
        }
    }
    
    class func setPeripheralConnectionTimeout(peripheralConnectionTimeout:Int) {
        NSUserDefaults.standardUserDefaults().setInteger(peripheralConnectionTimeout, forKey:"peripheralConnectionTimeout")
    }
    
    // characteristic read write timeout
    class func getCharacteristicReadWriteTimeout() -> Int {
        let characteristicReadWriteTimeout = NSUserDefaults.standardUserDefaults().integerForKey("characteristicReadWriteTimeout")
        if characteristicReadWriteTimeout == 0 {
            return 10
        } else {
            return characteristicReadWriteTimeout
        }
    }
    
    class func setCharacteristicReadWriteTimeout(characteristicReadWriteTimeout:Int) {
        NSUserDefaults.standardUserDefaults().setInteger(characteristicReadWriteTimeout, forKey:"characteristicReadWriteTimeout")
    }
    
    // maximum reconnections
    class func getMaximumReconnections() -> UInt {
        let maximumReconnetions = NSUserDefaults.standardUserDefaults().integerForKey("maximumReconnections")
        if maximumReconnetions == 0 {
            return 5
        } else {
            return UInt(maximumReconnetions)
        }
    }
    
    class func setMaximumReconnections(maximumReconnetions:UInt) {
        NSUserDefaults.standardUserDefaults().setInteger(Int(maximumReconnetions), forKey:"maximumReconnections")
    }
    
    // scanned services
    class func getScannedServices() -> [String:CBUUID] {
        if let storedServices = NSUserDefaults.standardUserDefaults().dictionaryForKey("services") {
            var services = [String:CBUUID]()
            for (name, uuid) in storedServices {
                if let uuid = uuid as? String {
                    services[name] = CBUUID(string: uuid)
                }
            }
            return services
        } else {
            return [:]
        }
    }
    
    class func getScannedServiceNames() -> [String] {
        return Array(self.getScannedServices().keys)
    }
    
    class func getScannedServiceUUIDs() -> [CBUUID] {
        return Array(self.getScannedServices().values)
    }
    
    class func getScannedServiceUUID(name:String) -> CBUUID? {
        let services = self.getScannedServices()
        if let uuid = services[name] {
            return uuid
        } else {
            return nil
        }
    }
    
    class func setScannedServices(services:[String:CBUUID]) {
        var storedServices = [String:String]()
        for (name, uuid) in services {
            storedServices[name] = uuid.UUIDString
        }
        NSUserDefaults.standardUserDefaults().setObject(storedServices, forKey:"services")
    }
    
    class func addScannedService(name:String, uuid:CBUUID) {
        var services = self.getScannedServices()
        services[name] = uuid
        self.setScannedServices(services)
    }
    
    class func removeScannedService(name:String) {
        var beacons = self.getScannedServices()
        beacons.removeValueForKey(name)
        self.setScannedServices(beacons)
    }
    
}