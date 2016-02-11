//
//  ServiceProfileUtils.swift
//  BlueToothMan
//
//  Created by Jeeva on 09/02/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation

func int16ValueFromStringValue(name:String, values:[String:String]) -> Int16? {
    if let value = values[name] {
        return Int16(value)
    } else {
        return nil
    }
}

func uint16ValueFromStringValue(name:String, values:[String:String]) -> UInt16? {
    if let value = values[name] {
        return UInt16(value)
    } else {
        return nil
    }
}

func int8ValueFromStringValue(name:String, values:[String:String]) -> Int8? {
    if let value = values[name] {
        return Int8(value)
    } else {
        return nil
    }
}

func uint8ValueFromStringValue(name:String, values:[String:String]) -> UInt8? {
    if let value = values[name] {
        return UInt8(value)
    } else {
        return nil
    }
}

