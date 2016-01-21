//
//  DoubleExtensions.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import Foundation

public extension Double {
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}
