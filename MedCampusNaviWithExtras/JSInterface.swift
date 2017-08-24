//
//  JSInterface.swift
//  MedCampusNavi
//
//  Created by o_rossmanf on 17.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import Foundation
import CoreBluetooth
import JavaScriptCore

//JSInterface/Protocoll --> written Object-C
@objc protocol JSInterfaceProtocol : JSExport{
    
    func checkdevice() -> Int
    func startscan() -> Void
    func stopscan() -> Void
}

//JSInterface Class
@objc class cJSInterface:NSObject,JSInterfaceProtocol{
   
    //CBCentralManager
    var centralManager:CBCentralManager!
    
    var isScanning = false
    
    //Init
    init(centralMgr: CBCentralManager){
        centralManager=centralMgr
    }
    //Functions for javascript
    func stopscan() {
        centralManager.stopScan()
        isScanning = false
    }
    
    func startscan() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true]);
        isScanning = true
    }
    
    func checkdevice() -> Int {
        
        //print("checkdevice - We hate apple")
        
        var res = 0
        switch centralManager.state{
        case .poweredOn:
            res = 0
        default:
            res = 1
        }
        
        if(isScanning)
        {
            centralManager.stopScan()
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true]);
        }
        
        return res;
    }
    
    
    
    
    
}
