//
//  HTTP.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 02.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import Foundation

class HTTP{
    func get(urlStr:String,completionHandler: @escaping (_ result: [String:Any]) -> Void){
        
        let task = URLSession.shared.dataTask(with: URL(string: urlStr)!){ (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            completionHandler(json!)
        }
        task.resume()
    }
}
