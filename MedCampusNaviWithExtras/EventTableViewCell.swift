//
//  EventTableViewCell.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 01.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var eventdesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
