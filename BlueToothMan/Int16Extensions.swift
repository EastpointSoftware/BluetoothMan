//
//  Int16Extensions.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation

extension Int16 : Deserializable {
    
    public static var size : Int {
        return sizeof(Int16)
    }
    
    public init?(doubleValue:Double) {
        if doubleValue >= 32767.0 || doubleValue <= -32768.0 {
            return nil
        } else {
            self = Int16(doubleValue)
        }
    }
    
    public static func deserialize(data:NSData) -> Int16? {
        if data.length >= sizeof(Int16) {
            var value : Int16 = 0
            data.getBytes(&value , length:sizeof(Int16))
            return toHostByteOrder(value)
        } else {
            return nil
        }
    }
    
    public static func deserialize(data:NSData, start:Int) -> Int16? {
        if data.length >= (sizeof(Int16) + start)  {
            var value : Int16 = 0
            data.getBytes(&value, range:NSMakeRange(start, sizeof(Int16)))
            return toHostByteOrder(value)
        } else {
            return nil
        }
    }
    
    public static func deserialize(data:NSData) -> [Int16] {
        let size = sizeof(Int16)
        let count = data.length / size
        return [Int](0..<count).reduce([]) {(result, idx) in
            if let value = self.deserialize(data, start:idx*size) {
                return result + [value]
            } else {
                return result
            }
        }
    }
    
}
