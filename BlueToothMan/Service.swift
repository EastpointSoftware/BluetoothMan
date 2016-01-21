//
//  Service.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import Foundation
import CoreBluetooth

public class Service {
    
    private let profile : ServiceProfile?
    
    internal var discoveredCharacteristics          = [CBUUID:Characteristic]()
    private var _characteristicsDiscoveredPromise   = Promise<Service>()
    
    private weak var _peripheral : Peripheral?
    
    public let cbService : CBService
    
    public var characteristicsDiscoveredPromise : Promise<Service> {
        return self._characteristicsDiscoveredPromise
    }
    
    public var name : String {
        if let profile = self.profile {
            return profile.name
        } else {
            return "Unknown"
        }
    }
    
    public var uuid : CBUUID {
        return self.cbService.UUID
    }
    
    public var characteristics : [Characteristic] {
        return Array(self.discoveredCharacteristics.values)
    }
    
    public var peripheral : Peripheral? {
        return self._peripheral
    }
    
    public init(cbService:CBService, peripheral:Peripheral) {
        self.cbService = cbService
        self._peripheral = peripheral
        self.profile = ProfileManager.sharedInstance.serviceProfiles[cbService.UUID]
    }
    
    public func discoverAllCharacteristics() -> Future<Service> {
        Logger.debug("uuid=\(self.uuid.UUIDString), name=\(self.name)")
        return self.discoverIfConnected(nil)
    }
    
    public func discoverCharacteristics(characteristics:[CBUUID]) -> Future<Service> {
        Logger.debug("uuid=\(self.uuid.UUIDString), name=\(self.name)")
        return self.discoverIfConnected(characteristics)
    }
    
    public func characteristic(uuid:CBUUID) -> Characteristic? {
        return self.discoveredCharacteristics[uuid]
    }
    
    public func didDiscoverCharacteristics(discoveredCharacteristics:[CBCharacteristic], error:NSError?) {
        if let error = error {
            Logger.debug("discover failed")
            self.characteristicsDiscoveredPromise.failure(error)
        } else {
            self.discoveredCharacteristics.removeAll()
            for cbCharacteristic in discoveredCharacteristics {
                let bcCharacteristic = Characteristic(cbCharacteristic:cbCharacteristic, service:self)
                self.discoveredCharacteristics[bcCharacteristic.uuid] = bcCharacteristic
                Logger.debug("uuid=\(self.uuid.UUIDString), name=\(self.name)")
                bcCharacteristic.afterDiscoveredPromise?.success(bcCharacteristic)
                Logger.debug("uuid=\(bcCharacteristic.uuid.UUIDString), name=\(bcCharacteristic.name)")
            }
            Logger.debug("discover success")
            self.characteristicsDiscoveredPromise.success(self)
        }
    }
    
    private func discoverIfConnected(characteristics:[CBUUID]?) -> Future<Service> {
        self._characteristicsDiscoveredPromise = Promise<Service>()
        if self.peripheral?.state == .Connected {
            self.peripheral?.discoverCharacteristics(characteristics, forService:self)
        } else {
            self.characteristicsDiscoveredPromise.failure(BCError.peripheralDisconnected)
        }
        return self.characteristicsDiscoveredPromise.future
    }
}