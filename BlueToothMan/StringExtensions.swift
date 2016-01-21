//
//  StringExtensions.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//

import Foundation

public extension String {
    
    public var floatValue : Float {
        return (self as NSString).floatValue
    }
    
    public func dataFromHexString() -> NSData {
        var bytes = [UInt8]()
        for i in 0..<(self.characters.count/2) {
            let stringBytes = self.substringWithRange(Range(start:self.startIndex.advancedBy(2*i), end:self.startIndex.advancedBy(2*i+2)))
            let byte = strtol((stringBytes as NSString).UTF8String, nil, 16)
            bytes.append(UInt8(byte))
        }
        return NSData(bytes:bytes, length:bytes.count)
    }
    
}
