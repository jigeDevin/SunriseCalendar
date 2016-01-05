//
//  TemperatureCell.swift
//  SunriseCalendarChallenge
//
//  Created by Brandon Leeds on 1/4/16.
//  Copyright © 2016 Brandon Leeds. All rights reserved.
//

import UIKit

class TemperatureCell: UITableViewCell {

    @IBOutlet weak var timeOfDayLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
