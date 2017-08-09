//
//  SecondViewController.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 24.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit
import CoreBluetooth
import JavaScriptCore



class SecondViewController: UIViewController, UIWebViewDelegate, CBPeripheralDelegate ,CBCentralManagerDelegate{
  
    //JSInterface
    var JSInterface:cJSInterface!
    
    //CBManager
    var centralManager:CBCentralManager!
    
    //Webview Outlet
    @IBOutlet weak var containerView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init Central Blueooth Mgr
        centralManager = CBCentralManager(delegate: self,queue: nil)
        
        //Webview
        
        containerView.delegate = self
        let url = URL(string: "https://map.medunigraz.at/")
        let req = URLRequest(url: url!)
        containerView.loadRequest(req)
    
 
        
        //
        //JSContext Definition
        let ctx = containerView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        //Init JSInterface
        JSInterface = cJSInterface(centralMgr: centralManager)
        ctx.setObject(JSInterface, forKeyedSubscript: "JSInterface" as NSCopying & NSObjectProtocol)
        
        //Keyboard fix
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        //The State query to tell the user, if something is not working
        var msg  = " "
        switch central.state {
        //Happens if Bluetooth is disabled
        case .poweredOff:
            msg = "Bitte Bluetooth aktivieren"
        //Happens if Bluetooth is unsupported
        case .unsupported:
            msg = "Ihr Gerät unterstützt Bluetooth Low Energy nicht."
        //Happens if Bluetooth is unauthorized
        case .unauthorized:
            msg = "Sie haben keine Berechtigung diese App zu verwenden."
        //Happens if an unknown Error happens --> mostly broken Bluetooth
        case .unknown:
            msg = "!!!Unkown Error!!!"
        //Happens if Bluetooth is resetting
        case .resetting:
            msg = "!!!Unknown Error!!!"
        case .poweredOn: break
        }
        //Executed if an Error occured
        if msg != " " {
            let alertController = UIAlertController(title: "Info", message: msg , preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //Invoked when Device Found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any],rssi RSSI: NSNumber) {
        //Checks if the advertisment Data is not nil
        //When a null advertisement occurs the signal is not send
        if (advertisementData[CBAdvertisementDataLocalNameKey] != nil){
            let localName:String=advertisementData[CBAdvertisementDataLocalNameKey] as! String
            //Kontakt --> standart BTLE Name for Kontakt.io Beacons
            if localName == "Kontakt" {
                //get of ServiceData to get the Beacon Name
                let serviceData:NSDictionary = advertisementData[CBAdvertisementDataServiceDataKey]! as! NSDictionary
                let data:NSData=serviceData.allValues.first! as! NSData
                let dataString=String(data: data as Data,encoding:.utf8)!
                let beaconName=dataString.substring(to:dataString.index(dataString.startIndex,offsetBy:4))
                
                //Json for the Javascript Method
                let jsonObject:String="[{\"Type\":\"BT\",\"ID\":\"00:00:00:00:00:00\",\"Value\":\(RSSI),\"Name\":\"\(beaconName)\",\"Batterie\":0}]"
        
                //Create and Execution of the Javascript Method
                let jsScript: String = "updatesignals('\(jsonObject)')"
                containerView.stringByEvaluatingJavaScript(from: jsScript)
                
                
            }
        }
        
        
        
    }
    
    
    
}

