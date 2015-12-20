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
    //var peripherals = [CBPeripheral]()
    var devices = [BluetoothDevice]()
    var deviceToPass = BluetoothDevice()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
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
        devices.removeAll()
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "StopScan", userInfo: nil, repeats: false)
        
    }
    
    
    func StopScan(){
        self.centralManager.stopScan()
        print("Stopped....")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        print("haha")
        print("******************")
        print("Name   : \(peripheral.name)")
        print("UUID   : \(peripheral.identifier.UUIDString)")
        print("Advert : \(advertisementData)")
        print("RSSI   : \(RSSI)")
        print("******************")
       
        let tempDevice = BluetoothDevice()
        tempDevice.device = peripheral
        tempDevice.rssi = RSSI
        tempDevice.advertisementData = advertisementData
        
        //self.peripherals.append(peripheral)
        
        self.devices.append(tempDevice)
        self.tableView.reloadData()
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
        
        self.StartScanning()
    }
    
    
    

}

