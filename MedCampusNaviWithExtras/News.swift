//
//  News.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 31.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import Foundation
//Model for the News Controller
class News {
    //MARK: Properties
    var title: String
    var desc: String
    var url: URL?
    var date: String
    
    //MARK: Initialization
    
    init(title: String, desc: String, url: URL?, date: String) {
        self.title=title
        self.desc=desc
        if url != nil {
            self.url=url
            //print("Create News: " + (self.url?.absoluteString)!)
        }
        
        self.date=Util().convertDate(date: date)
    }
    
    
    
}
