//
//  ServiceProfile.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation
import CoreBluetooth

public class ServiceProfile {
    
    internal var characteristicProfiles = [CBUUID:CharacteristicProfile]()
    
    public let uuid : CBUUID
    public let name : String
    public let tag  : String
    
    public var characteristics : [CharacteristicProfile] {
        return Array(self.characteristicProfiles.values)
    }
    
    public var characteristic : [CBUUID:CharacteristicProfile] {
        return self.characteristicProfiles
    }
    
    public init(uuid:String, name:String, tag:String = "Miscellaneous") {
        self.name = name
        self.uuid = CBUUID(string:uuid)
        self.tag = tag
    }
    
    public convenience init(uuid:String) {
        self.init(uuid:uuid, name:"Unknown")
    }
    
    public func addCharacteristic(characteristicProfile:CharacteristicProfile) {
        Logger.debug("name=\(characteristicProfile.name), uuid=\(characteristicProfile.uuid.UUIDString)")
        self.characteristicProfiles[characteristicProfile.uuid] = characteristicProfile
    }
    
}

public class ConfiguredServicesProfile<Config:ServiceConfigurable> : ServiceProfile {
    
    public init() {
        super.init(uuid:Config.uuid, name:Config.name, tag:Config.tag)
    }
    
}