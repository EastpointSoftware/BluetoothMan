//
//  PeripheralServicesViewController.swift
//  BlueToothMan
//
//  Created by Jeeva on 21/01/2016.
//  Copyright © 2016 Jeeva. All rights reserved.
//


import UIKit

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: Characteristic)
}

class PeripheralServicesViewController : UITableViewController,MyCustomCellDelegator {
    
    weak var peripheral             : Peripheral!
    var peripheralViewController    : PeripheralViewController!
    var progressView                = ProgressView()
    
    struct MainStoryboard {
        static let peripheralServiceCell            = "PeripheralServiceCell"
        static let peripheralServicesCharacteritics = "PeripheralServicesCharacteritics"
        static let viewUART = "ViewUART"
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateWhenActive()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"peripheralDisconnected", name:BluetoothNotification.peripheralDisconnected, object:self.peripheral!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"didBecomeActive", name:BluetoothNotification.didBecomeActive, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"didResignActive", name:BluetoothNotification.didResignActive, object:nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject!) {
       
        
        if segue.identifier == MainStoryboard.peripheralServicesCharacteritics {
            if let peripheral = self.peripheral {
                if let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                   
                    let viewController = segue.destinationViewController as! PeripheralServiceCharacteristicsViewController
                    viewController.service = peripheral.services[selectedIndex.row]
                    viewController.peripheralViewController = self.peripheralViewController
                    
                }
                
            }
            if segue.identifier == MainStoryboard.viewUART {
                if let peripheral1 = self.peripheral {
                    if let selectedIndex1 = self.tableView.indexPathForCell(sender as! UITableViewCell){
                        
                        let viewController1 = segue.destinationViewController as! InteractViewController
                        viewController1.service = peripheral1.services[selectedIndex1.row]

                    }
                }
            }
            
            
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier:String?, sender:AnyObject?) -> Bool {
       
        return true
    }
    
    
    func callSegueFromCell(myData mydata: Characteristic){
        
    }
    
    func peripheralDisconnected() {
        Logger.debug()
        if self.peripheralViewController.peripehealConnected {
            self.presentViewController(UIAlertController.alertWithMessage("Peripheral disconnected"), animated:true, completion:nil)
            self.peripheralViewController.peripehealConnected = false
            self.updateWhenActive()
        }
    }
    
    func didResignActive() {
        Logger.debug()
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func didBecomeActive() {
        Logger.debug()
    }
    
    // UITableViewDataSource
    override func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        return 1
    }
    
    override func tableView(_:UITableView, numberOfRowsInSection section:Int) -> Int {
        if let peripheral = self.peripheral {
            return peripheral.services.count
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(MainStoryboard.peripheralServiceCell)
        print("\(indexPath.row)")
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.peripheralServiceCell, forIndexPath: indexPath) as! ServiceCell
        
            
            let service = peripheral.services[indexPath.row]
            cell.nameLabel.text = service.name
            cell.uuidLabel.text = service.uuid.UUIDString
            if let peripheralViewController = self.peripheralViewController {
                if peripheralViewController.peripehealConnected {
                    cell.nameLabel.textColor = UIColor.blackColor()
                } else {
                    cell.nameLabel.textColor = UIColor.lightGrayColor()
                }
            } else {
                cell.nameLabel.textColor = UIColor.blackColor()
            }
         return cell
        
    }
    
    
    
    // UITableViewDelegate
    
}
