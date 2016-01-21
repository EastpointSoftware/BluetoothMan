//
//  BCErrors.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation

public enum CharacteristicError : Int {
    case ReadTimeout        = 1
    case WriteTimeout       = 2
    case NotSerializable    = 3
    case ReadNotSupported   = 4
    case WriteNotSupported  = 5
    case NotifyNotSupported = 6
}

public enum PeripheralError : Int {
    case DiscoveryTimeout   = 20
    case Disconnected       = 21
    case NoServices         = 22
}

public enum PeripheralManagerError : Int {
    case IsAdvertising      = 40
    case IsNotAdvertising   = 41
    case AddServiceFailed   = 42
}

public enum CentralError : Int {
    case IsScanning         = 50
    case IsPoweredOff       = 51
}

public struct BCError {
    public static let domain = "BluetoothScanner"
    
    public static let characteristicReadTimeout = NSError(domain:domain, code:CharacteristicError.ReadTimeout.rawValue, userInfo:[NSLocalizedDescriptionKey:"Characteristic read timeout"])
    public static let characteristicWriteTimeout = NSError(domain:domain, code:CharacteristicError.WriteTimeout.rawValue, userInfo:[NSLocalizedDescriptionKey:"Characteristic write timeout"])
    public static let characteristicNotSerilaizable = NSError(domain:domain, code:CharacteristicError.NotSerializable.rawValue, userInfo:[NSLocalizedDescriptionKey:"Characteristic not serializable"])
    public static let characteristicReadNotSupported = NSError(domain:domain, code:CharacteristicError.ReadNotSupported.rawValue, userInfo:[NSLocalizedDescriptionKey:"Characteristic read not supported"])
    public static let characteristicWriteNotSupported = NSError(domain:domain, code:CharacteristicError.WriteNotSupported.rawValue, userInfo:[NSLocalizedDescriptionKey:"Characteristic write not supported"])
    public static let characteristicNotifyNotSupported = NSError(domain:domain, code:CharacteristicError.NotifyNotSupported.rawValue, userInfo:[NSLocalizedDescriptionKey:"Characteristic notify not supported"])
    
    public static let peripheralDisconnected = NSError(domain:domain, code:PeripheralError.Disconnected.rawValue, userInfo:[NSLocalizedDescriptionKey:"Peripheral disconnected timeout"])
    public static let peripheralDiscoveryTimeout = NSError(domain:domain, code:PeripheralError.DiscoveryTimeout.rawValue, userInfo:[NSLocalizedDescriptionKey:"Peripheral discovery Timeout"])
    public static let peripheralNoServices = NSError(domain:domain, code:PeripheralError.NoServices.rawValue, userInfo:[NSLocalizedDescriptionKey:"Peripheral services not found"])
    
    public static let peripheralManagerIsAdvertising = NSError(domain:domain, code:PeripheralManagerError.IsAdvertising.rawValue, userInfo:[NSLocalizedDescriptionKey:"Peripheral Manager is Advertising"])
    public static let peripheralManagerIsNotAdvertising = NSError(domain:domain, code:PeripheralManagerError.IsNotAdvertising.rawValue, userInfo:[NSLocalizedDescriptionKey:"Peripheral Manager is not Advertising"])
    public static let peripheralManagerAddServiceFailed = NSError(domain:domain, code:PeripheralManagerError.AddServiceFailed.rawValue, userInfo:[NSLocalizedDescriptionKey:"Add service failed because service peripheral is advertising"])
    
    public static let centralIsScanning = NSError(domain:domain, code:CentralError.IsScanning.rawValue, userInfo:[NSLocalizedDescriptionKey:"Central is scanning"])
    public static let centralIsPoweredOff = NSError(domain:domain, code:CentralError.IsPoweredOff.rawValue, userInfo:[NSLocalizedDescriptionKey:"Central is powered off"])
    
}

