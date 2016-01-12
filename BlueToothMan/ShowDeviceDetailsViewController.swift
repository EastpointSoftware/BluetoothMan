//
//  ShowDeviceDetailsViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 20/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth



class ShowDeviceDetailsViewController : UIViewController , CBCentralManagerDelegate {
    
    var receivedDevice : BluetoothDevice!
    var inputStream : NSInputStream!
    var outputStream : NSOutputStream!
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceUUIDLabel: UILabel!
    @IBOutlet weak var deviceRSSILabel: UILabel!
    @IBOutlet weak var deviceAdvertDataLabel: UILabel!

    @IBOutlet weak var deviceNameFromAdvertLabel: UILabel!
    @IBOutlet weak var deviceIdentDescLabel: UILabel!
    
    var centralManager : CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if receivedDevice.device.name != nil {
            deviceNameLabel.text = receivedDevice.device.name
        }else{
            deviceNameLabel.text = "nil"
        }
        deviceUUIDLabel.text = receivedDevice.device.identifier.UUIDString
        deviceRSSILabel.text = "\(receivedDevice.rssi)"
        deviceAdvertDataLabel.text = "\(receivedDevice.advertisementData)"
        let temp = NSDictionary (dictionary: receivedDevice.advertisementData)
        deviceNameFromAdvertLabel.text = "\(temp.objectForKey("kCBAdvDataIsConnectable")!)"
        deviceIdentDescLabel.text = receivedDevice.device.identifier.description
        
        //deviceNameFromAdvertLabel.text += receivedDevice.device.discoverServices( receivedDevice.device.identifier.UUIDString )
        
        //self.receivedDevice.delegate = self
        //centralManager.delegate = self
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager){
        
    }
    
    
    @IBAction func connectToDevice(sender: AnyObject) {
        
        //var readStream: CFReadStreamRef!
//        var writeStream: CFWriteStreamRef!
//        
//        
//       // CFStreamCreatePairWithSocketToHost(nil, "192.168.0.10" as CFString, 35000, readStream, writeStream)
//        self.inputStream = readStream as NSInputStream
//        self.outputStream = writeStream as NSOutputStream
//        self.inputStream.delegate = self
//        self.outputStream.delegate = self
//        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
//        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
//        self.inputStream.open()
//        self.outputStream.open()
//        
        
        print("Connecting to \(receivedDevice.advertisementData.description) ...")
        
        centralManager.connectPeripheral(receivedDevice.device, options: nil)
        
        /*centralManager.connectPeripheral(receivedDevice.device, options:[CBConnectPeripheralOptionNotifyOnConnectionKey : true,
            CBConnectPeripheralOptionNotifyOnDisconnectionKey : true,
            CBConnectPeripheralOptionNotifyOnNotificationKey : true])
            let cbp =  centralManager.retrievePeripheralsWithIdentifiers([NSUUID(UUIDString: receivedDevice.device.identifier.UUIDString)!]  )

        if cbp.count > 0 {
            centralManager.connectPeripheral(cbp[0], options:[CBConnectPeripheralOptionNotifyOnConnectionKey : true,
                CBConnectPeripheralOptionNotifyOnDisconnectionKey : true,
                CBConnectPeripheralOptionNotifyOnNotificationKey : true])
        }*/
        
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        if (error != nil) {
            
            print("error connecting to peripheral \(peripheral.description) " + (error?.description)!)
        }
        
        
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        peripheral.discoverServices(nil)
        
        print("Connected to peripheral")
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        
        if let actualError = error {
            
            self.deviceNameFromAdvertLabel.text = actualError.description + "\r\n" + self.deviceNameFromAdvertLabel.text! + "\r\n"
            
            
        }
        else {
            for service in peripheral.services as [CBService]!{
                
                self.deviceNameFromAdvertLabel.text  = service.description + "\r\n " + self.deviceNameFromAdvertLabel.text!
                 peripheral.discoverCharacteristics(nil, forService: service)
                print(service.description)
            }
        }
    }
    
    
    
    
    
}