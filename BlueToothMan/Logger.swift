//
//  Logger.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import Foundation

public class Logger {
    public class func debug(message:String? = nil, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
        #if DEBUG
            if let message = message {
                print("\(file):\(function):\(line): \(message)")
            } else {
                print("\(file):\(function):\(line)")
            }
        #endif
    }
    
}
