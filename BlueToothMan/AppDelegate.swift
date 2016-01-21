//
//  AppDelegate.swift
//  BlueToothMan
//
//  Created by Jeeva on 18/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import UIKit


struct BluetoothNotification {
    static let peripheralDisconnected   = "PeripheralDisconnected"
    static let didUpdateBeacon          = "DidUpdateBeacon"
    static let didBecomeActive          = "DidBecomeActive"
    static let didResignActive          = "DidResignActive"
}

enum AppError : Int {
    case rangingBeacons = 0
    case outOfRegion    = 1
}

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    class func sharedApplication() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override init() {
        super.init()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes:[UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories:nil))
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(BluetoothNotification.didResignActive, object:nil)
        if CentralManager.sharedInstance.isScanning {
            CentralManager.sharedInstance.stopScanning()
            CentralManager.sharedInstance.disconnectAllPeripherals()
            CentralManager.sharedInstance.removeAllPeripherals()
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        Notify.resetEventCount()
        NSNotificationCenter.defaultCenter().postNotificationName(BluetoothNotification.didBecomeActive, object:nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}

