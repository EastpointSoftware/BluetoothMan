//
//  ViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 18/12/2015.
//  Copyright © 2015 Jeeva. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate,UITableViewDataSource,UITableViewDelegate {

    var centralManager : CBCentralManager!
    var devices = [BluetoothDevice]()
    var deviceToPass = BluetoothDevice()
    var isScanning = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var LogView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        LogView.text = ""
    }
    
    func LogMessage(newLog: String){
        
       LogView.text = (newLog + "\r\n" + LogView.text )
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterForeground:", name: UIApplicationDidBecomeActiveNotification, object: nil)

        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.devices.removeAll()
        self.tableView.reloadData()
        self.StartScanning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bluetoothItem") as! BluetoothTableViewCell
        let peripheral = self.devices[indexPath.row].device
        if peripheral.name == nil {
            cell.nameLabel.text = peripheral.identifier.UUIDString

        }else {
            cell.nameLabel.text = peripheral.name
        }
            
        cell.rssiLabel.text = "\(self.devices[indexPath.row].rssi)"
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        deviceToPass = self.devices[indexPath.row]
        
        // Connect on select from Table View
        
        LogMessage("Connecting to device \(deviceToPass.device.identifier.UUIDString)")
        centralManager.connectPeripheral(deviceToPass.device, options: nil)
        
        
    }
    
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
    
        // Handle the failure and display exception in the UI Log
        
        if (error != nil) {
            
            LogMessage("error connecting to peripheral \(peripheral.description) " + (error?.description)!)
        }
        
        
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        //Write log that device connected
        
         LogMessage("Connected to peripheral \(peripheral.identifier.UUIDString)")
        
        //Discover Services
        peripheral.discoverServices(nil)
        
        
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        ///TODO : Log all services discovered
        
        if let actualError = error {
            
            LogMessage (actualError.description )
            
            
        }
        else {
            for service in peripheral.services as [CBService]!{
                LogMessage ("***********************")
                LogMessage ("Service Name : " + service.description)
                
                peripheral.discoverCharacteristics(nil, forService: service)
                LogMessage ("***********************")
            }
        }

        
        
    }
    
    
    
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        
        // Check whether the device is duplicate
        
        var isDeviceAlreadyDiscovered = false
        
        let tempDevice = BluetoothDevice()
        tempDevice.device = peripheral
        tempDevice.rssi = RSSI
        tempDevice.advertisementData = advertisementData
        tempDevice.isConnected = false
        
        
        for  deviceList in devices{
            
            if (deviceList.device.identifier.UUIDString == tempDevice.device.identifier.UUIDString){
                isDeviceAlreadyDiscovered = true
                break
            }
            
        }
        
        //if device not discovered earlier then add to device array
        if !isDeviceAlreadyDiscovered {
       
            //Print Newly discovered device
            LogMessage("******************")
            LogMessage("New device discovered")
            LogMessage("Name   : \(peripheral.name)")
            LogMessage("UUID   : \(peripheral.identifier.UUIDString)")
            LogMessage("Advert : \(advertisementData)")
            LogMessage("RSSI   : \(RSSI)")
            LogMessage("******************")
            //Add the device to the devices array
            
            
            self.devices.append(tempDevice)
            LogMessage("New device added to device array")
            // Reload the table view to display the newly added device
            
            self.tableView.reloadData()
            LogMessage("Reloaded Table View ")
        }else
        {
             LogMessage("The device with UUID  \(peripheral.identifier.UUIDString) is already added to the device list")
        }
        
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        LogMessage("We are in Central Manager did update state")
        if central.state == CBCentralManagerState.PoweredOn {
            LogMessage("Bluetooth is ON")
            
            //StartScanning()
        }else
        {
            let alertViewController = UIAlertController(title: "Bluetooth Man", message: "Make sure that your bluetooth is on", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Bluetooth Not working", style: UIAlertActionStyle.Default, handler: { (act  : UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertViewController.addAction(action)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            LogMessage("Bluetooth is OFF")
        }
        
    }

    
    func StartScanning(){
        
        
        LogMessage("we are in scan for devices function")
        if (isScanning){
            LogMessage("Scanning in progress. Now restarting")
            self.StopScan()
        }
        
        devices.removeAll()
        
        //NSDictionary options = {CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:allowDuplicates]};
        LogMessage("Scanning...")
        isScanning = true
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil )
        
        //NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "StopScan", userInfo: nil, repeats: false)
        
        
        
        
    }
    
    
    func StopScan(){
        self.centralManager.stopScan()
        LogMessage("Stopped....")
    }
    
    
    
    
    
    @IBAction func Refresh(sender: UIBarButtonItem) {
        
        LogMessage("We are in Refersh Function")
        self.StartScanning()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        self.StopScan()
    }
    
    func applicationDidEnterForeground(application: UIApplication) {
    
    }
    

}

