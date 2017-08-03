//
//  News.swift
//  MedCampusNaviWithExtras
//
//  Created by gze on 31.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import Foundation

class News {
    //MARK: Properties
    var title: String
    var desc: String
    var link: URL
    var date: String
    
    //MARK: Initialization
    
    init(title: String, desc: String, link: String, date: String) {
        self.title=title
        self.desc=desc
        self.link=URL(string: link)!
        self.date=Util().convertDate(date: date)
    }
    
    init(title: String, desc: String, date:String) {
        self.title=title
        self.desc=desc
        self.link=URL(string: "http://www.medunigraz.at")!
        self.date=Util().convertDate(date: date)
        
    }
    

}
