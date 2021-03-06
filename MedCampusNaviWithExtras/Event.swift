//
//  Event.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 24.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import Foundation

class Event{
    //MARK: Properties
    var start:String
    var end:String
    var allday:Bool
    var title:String
    var description:String
    var url:URL?
    var state:Bool
    
    //MARK: Initialization
    init(start:String, end:String, title:String, desc:String,allday:Bool,url:URL?,state:Bool){
        self.start=start
        self.end=end
        self.title=title
        self.description=desc
        self.allday=allday
        if url != nil {
            self.url=url
        }
        self.state=state
        
    }
    
    //converting the time to a valid String
    func getTimeString() -> String {
        var timeString = String()
        let index: Range<String.Index> = start.range(of: "T")!
        let index2: Range<String.Index> = end.range(of: "T")!
        if allday == false{
            timeString += start.substring(to: index.lowerBound)
            timeString += "-"
            timeString += end.substring(to: index2.lowerBound)
            return timeString
        }
        return start.substring(to: index.lowerBound)
    }
    
}
