//
//  NewsTableViewCell.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 31.07.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
