//
//  CalendarCell.swift
//  SunriseCalendarChallenge
//
//  Created by Brandon Leeds on 12/31/15.
//  Copyright © 2015 Brandon Leeds. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    var day: Int!
    var date: NSDate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        let bottomLine : UIView = UIView(frame: CGRectMake(0, self.contentView.bounds.height + 2, self.contentView.bounds.width + 50, 1))
        bottomLine.backgroundColor = UIColor(red:0.867, green:0.855, blue:0.835, alpha:0.8)
        self.contentView.addSubview(bottomLine)
    }
    
    func setSelected() {
        selectedView.layer.cornerRadius = 20
        selectedView.layer.masksToBounds = true
        selectedView.layer.backgroundColor = UIColor.blueColor().CGColor
        dayLabel.textColor = UIColor.whiteColor()
        
        if day == 1 {
            dayLabel.text = "1"
        }
    }
    
    func setUnSelected() {
        selectedView.layer.cornerRadius = 0
        selectedView.layer.masksToBounds = true
        selectedView.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    func checkDateBeforeToday() {
        
        if date.compare(NSDate()) == NSComparisonResult.OrderedAscending && DateHelper.checkToday(date) == false {
            backgroundColor = UIColor(red: 0.953, green:0.953, blue:0.953, alpha:1)
        }
        else {
            backgroundColor = UIColor.whiteColor()
        }
    }
}
