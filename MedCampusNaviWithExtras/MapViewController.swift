//
//  SecondViewController.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 24.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit
import CoreBluetooth
import WebKit
import JavaScriptCore

var JSInterface:cJSInterface!

class SecondViewController: UIViewController, UIWebViewDelegate, CBPeripheralDelegate ,CBCentralManagerDelegate {
    
    
    
    var centralManager:CBCentralManager!
    
    @IBOutlet weak var containerView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init Central Blueooth Mgr
        centralManager = CBCentralManager(delegate: self,queue: nil)
        
        //Webview
        containerView.delegate = self
        let url = URL(string: "https://map.medunigraz.at")
        let req = URLRequest(url: url!)
        containerView.loadRequest(req)
        
        let ctx = containerView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        //Init JSInterface
        JSInterface = cJSInterface(centralMgr: centralManager)
        ctx.setObject(JSInterface, forKeyedSubscript: "JSInterface" as NSCopying & NSObjectProtocol)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        var msg  = " "
        switch central.state {
        case .poweredOff:
            msg = "Bitte Bluetooth aktivieren"
        case .unsupported:
            msg = "Ihr Gerät unterstützt Bluetooth Low Energy nicht."
        case .unauthorized:
            msg = "Sie haben keine Berechtigung diese App zu verwenden."
        case .unknown:
            msg = "!!!Unkown Error!!!"
        case .resetting:
            msg = "!!!Unknown Error!!!"
        case .poweredOn: break
        }
        if msg != " " {
            let alertController = UIAlertController(title: "Info", message: msg , preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //Invoked when Device Found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any],rssi RSSI: NSNumber) {
        if (advertisementData[CBAdvertisementDataLocalNameKey] != nil){
            let localName:String=advertisementData[CBAdvertisementDataLocalNameKey] as! String
            if localName == "Kontakt" {
                let serviceData:NSDictionary = advertisementData[CBAdvertisementDataServiceDataKey]! as! NSDictionary
                let data:NSData=serviceData.allValues.first! as! NSData
                let dataString=String(data: data as Data,encoding:.utf8)!
                let beaconName=dataString.substring(to:dataString.index(dataString.startIndex,offsetBy:4))
                let jsonObject:String="[{\"Type\":\"BT\",\"ID\":\"00:00:00:00:00:00\",\"Value\":\(RSSI),\"Name\":\"\(beaconName)\",\"Batterie\":0}]"
                let jsScript: String = "updatesignals('\(jsonObject)')"
                containerView.stringByEvaluatingJavaScript(from: jsScript)
                
                
            }
        }
        
        
        
    }
    
    
    
}

