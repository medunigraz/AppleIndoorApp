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
    
    //Init
    init(centralMgr: CBCentralManager){
        centralManager=centralMgr
    }
    //Functions for javascript
    func stopscan() {
        centralManager.stopScan()
    }
    
    func startscan() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true]);
    }
    
    func checkdevice() -> Int {
        switch centralManager.state{
        case .poweredOn:
            return 0
        default:
            return 1
        }
    }
    
    
    
    
    
}
