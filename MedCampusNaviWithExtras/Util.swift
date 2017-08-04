//
//  Util.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 03.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import Foundation

class Util{
    //Converts Dates from Api
    func convertDate(date: String) ->String {
        print("date lappen")
        let index: Range<String.Index> = date.range(of: "T")!
        print("datelappen geht")
        return date.substring(to: index.lowerBound)
    }
    
}
