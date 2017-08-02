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

@objc protocol JSInterfaceProtocol : JSExport{
    
    func checkdevice() -> Int
    func startscan() -> Void
    func stopscan() -> Void
}


@objc class cJSInterface:NSObject,JSInterfaceProtocol{
    let timerScanInterval: TimeInterval=2.0
    let timerPauseInterval: TimeInterval=10.0
    
    var centralManager:CBCentralManager!
    
    init(centralMgr: CBCentralManager){
        centralManager=centralMgr
    }
    
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
