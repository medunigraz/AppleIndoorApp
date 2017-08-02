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
    
    //MARK: Initialization
    
    init(title: String, desc: String, link: String) {
        self.title=title
        self.desc=desc
        self.link=URL(string: link)!
        
    }
    init(title: String, desc: String) {
        self.title=title
        self.desc=desc
        self.link=URL(string: "http://www.medunigraz.at")!
        
    }
    public var description: String { return "title: \(title) \n desc: \(desc) \n" }
    
}
