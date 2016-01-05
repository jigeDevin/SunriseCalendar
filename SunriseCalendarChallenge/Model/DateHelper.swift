//
//  DateHelper.swift
//  SunriseCalendarChallenge
//
//  Created by Brandon Leeds on 1/4/16.
//  Copyright © 2016 Brandon Leeds. All rights reserved.
//

import Foundation

public class DateHelper {
    
    /**
     Checks if date is equal to today
     
     - parameter date: NSDate
     
     - returns: true or false
     */
    public class func checkToday(date: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let tadayComponents = calendar.components([.Day,.Month, .Year], fromDate: NSDate())
        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        if tadayComponents.day == dateComponents.day && tadayComponents.month == dateComponents.month && tadayComponents.year == dateComponents.year {
            return true
        }
        return false
    }

    /**
     Gets the start date of the calendar based on today and
     the difference between today and the Sunday of this week
     - returns: Calendar Start Date and Difference Between Sunday and Today
     */
   public class func setStartDateAndDifference() -> NSArray {
        var returnArray = NSMutableArray()
        let startDateComponenets = NSDateComponents()
        startDateComponenets.day = -119
        
        let calendar = NSCalendar.currentCalendar()
        
        let todayComponents = calendar.components([.Weekday ], fromDate: NSDate())
        let difference = calendar.firstWeekday - todayComponents.weekday
        // Create new date based on difference
        let sundayComponents = NSDateComponents()
        sundayComponents.day = difference
        let sundayDate : NSDate = calendar.dateByAddingComponents(sundayComponents, toDate: NSDate(), options: .MatchStrictly)!
        
        let startDate : NSDate = calendar.dateByAddingComponents(startDateComponenets, toDate: sundayDate, options: .MatchStrictly)!
        returnArray = [startDate, difference]
    
        return returnArray
    }
    
    /**
     Formats Header Date String
     
     - parameter row:       used to get day
     - parameter startDate: calendar start date
     
     - returns: formated string (Day of Week, Month, Day)
     */
    public class func getHeaderDay(row: Int, startDate: NSDate) -> String {
        let daysToAddComponenets = NSDateComponents()
        daysToAddComponenets.day = row
        let calendar = NSCalendar.currentCalendar()
        let newDate : NSDate = calendar.dateByAddingComponents(daysToAddComponenets, toDate: startDate, options: .MatchStrictly)!
        let newDateComponents = calendar.components([.Day, .Month, .Weekday], fromDate: newDate)
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        let monthArray = Array(dateFormatter.monthSymbols)
        let weekdayArray = Array(dateFormatter.weekdaySymbols)
        let month = monthArray[newDateComponents.month - 1]
        let weekday = weekdayArray[newDateComponents.weekday - 1]
        
        var formattedDayString = String()
        formattedDayString = String(format: "%@, %@ %d", weekday, month,newDateComponents.day)
        return formattedDayString
    }
    
    /**
     Collection view day
     
     - parameter row:       used to get the day for the cell
     - parameter startDate: calendar start date
     
     - returns: day, First of the month string (optional), new NSDate
     */
    public class func getDay(row: Int, startDate: NSDate) -> NSArray {
        let daysToAddComponenets = NSDateComponents()
        daysToAddComponenets.day = row
        let calendar = NSCalendar.currentCalendar()
        let newDate : NSDate = calendar.dateByAddingComponents(daysToAddComponenets, toDate: startDate, options: .MatchStrictly)!
        let newDateComponents = calendar.components([.Day, .Month, .Year], fromDate: newDate)
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        let monthArray = Array(dateFormatter.shortMonthSymbols)
        let shortMonth = monthArray[newDateComponents.month - 1]
        
        var formattedDayString = String()
        
        if newDateComponents.day == 1 {
            formattedDayString = String(format: "%@ %d %d", shortMonth, newDateComponents.day,newDateComponents.year)
        }
        
        let dateArray = [newDateComponents.day, formattedDayString, newDate]
        return dateArray
    }
}
