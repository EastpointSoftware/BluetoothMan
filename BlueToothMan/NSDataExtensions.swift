//
//  NSDataExtensions.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation

extension NSData : Serializable {
    
    public class func fromString(value:String, encoding:NSStringEncoding = NSUTF8StringEncoding) -> NSData? {
        return value.dataUsingEncoding(encoding).map{NSData(data:$0)}
    }
    
    public class func serialize<T>(value:T) -> NSData {
        let values = [fromHostByteOrder(value)]
        return NSData(bytes:values, length:sizeof(T))
    }
    
    public class func serializeArray<T>(values:[T]) -> NSData {
        let littleValues = values.map{fromHostByteOrder($0)}
        return NSData(bytes:littleValues, length:sizeof(T)*littleValues.count)
    }
    
    public class func serialize<T1, T2>(value1:T1, value2:T2) -> NSData {
        let data = NSMutableData()
        data.setData(NSData.serialize(value1))
        data.appendData(NSData.serialize(value2))
        return data
    }
    
    public class func serializeArrays<T1, T2>(values1:[T1], values2:[T2]) -> NSData {
        let data = NSMutableData()
        data.setData(NSData.serializeArray(values1))
        data.appendData(NSData.serializeArray(values2))
        return data
    }
    
    public func hexStringValue() -> String {
        var dataBytes = [UInt8](count:self.length, repeatedValue:0x0)
        self.getBytes(&dataBytes, length:self.length)
        let hexString = dataBytes.reduce(""){(out:String, dataByte:UInt8) in
            return out + (NSString(format:"%02lx", dataByte) as String)
        }
        return hexString
    }
    
}
