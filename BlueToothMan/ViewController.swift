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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        performSegueWithIdentifier("ShowDeviceDetails", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ShowDeviceDetails" {
            if let destination = segue.destinationViewController as? ShowDeviceDetailsViewController {
                
                if let index = self.tableView.indexPathForSelectedRow {
                    
                    destination.receivedDevice = self.devices[index.row]
                }
                
            }
        }
    }
    
    
    func StartScanning(){
        
        
        print("we are in scan for devices function")
        if (isScanning){
            print("Scanning in progress. Now restarting")
            self.StopScan()
        }
        
        devices.removeAll()
        
        //NSDictionary options = {CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:allowDuplicates]};
        print("Scanning...")
        isScanning = true
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil )
        
        //NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "StopScan", userInfo: nil, repeats: false)
        
        
        
        
    }
    
    
    func StopScan(){
        self.centralManager.stopScan()
        print("Stopped....")
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
            print("******************")
            print("Name   : \(peripheral.name)")
            print("UUID   : \(peripheral.identifier.UUIDString)")
            print("Advert : \(advertisementData)")
            print("RSSI   : \(RSSI)")
            print("******************")
            //Add the device to the devices array
            
            
            self.devices.append(tempDevice)
            
            // Reload the table view to display the newly added device
            
            self.tableView.reloadData()
        }else
        {
             print("The device with UUID  \(peripheral.identifier.UUIDString) is already added to the device list")
        }
        
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        print("We are in Central Manager did update state")
        if central.state == CBCentralManagerState.PoweredOn {
            print("Bluetooth is ON")
            
            StartScanning()
        }else
        {
            let alertViewController = UIAlertController(title: "Bluetooth Man", message: "Make sure that your bluetooth is on", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Bluetooth Not working", style: UIAlertActionStyle.Default, handler: { (act  : UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertViewController.addAction(action)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            print("Bluetooth is OFF")
        }
        
    }

    
    @IBAction func Refresh(sender: UIBarButtonItem) {
        
        print("We are in Refersh Function")
        self.StartScanning()
    }
    
    
    

}

