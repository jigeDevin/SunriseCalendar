//
//  HourlyTemp.swift
//  SunriseCalendarChallenge
//
//  Created by Brandon Leeds on 1/3/16.
//  Copyright © 2016 Brandon Leeds. All rights reserved.
//

import UIKit

class HourlyTemp: NSObject {

    var hourlyTime: NSDate!
    var hourlyTemp: Double!
    var timeOfDay: String!
    
    init(time: NSDate, temp: Double) {
        hourlyTime = time
        hourlyTemp = temp
    }
    
    
}
