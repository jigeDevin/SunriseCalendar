//
//  WeatherAPI.swift
//  SunriseCalendarChallenge
//
//  Created by Brandon Leeds on 1/3/16.
//  Copyright © 2016 Brandon Leeds. All rights reserved.
//

import UIKit

final class WeatherAPI: NSObject {

    static let sharedInstance = WeatherAPI()
    
    var todayWeather: NSArray!
    var tomorrowWeather: NSArray!

    private override init() {
        
        
    }
    
    /**
     Get request to Dark Sky Forecase API
     
     - parameter longitude: current location longitude
     - parameter latitude:  current location latitude
     */
    func getWeather(longitude: Float, latitude: Float) {
        
        let url = String(format: "https://api.forecast.io/forecast/8a4b69faa8d6b5dd7e3535621bc82dc1/%f,%f", latitude, longitude)
        let manager = AFHTTPSessionManager()
        manager.GET(url, parameters: nil, progress: nil, success: { (data, object) -> Void in
            let test = object as! NSDictionary
            let hourly = test.objectForKey("hourly")?.objectForKey("data") as! NSArray
            self.convertData(hourly)
            }) { (data, error) -> Void in
                print(error)
        }
    }
    
    /**
     Create HourlyTempObjects and sort them into Today/Tomorrow arrays
     
     - parameter hourly: array containing hourly json data
     */
     private func convertData(hourly: NSArray) {
        var hourlyArrayToday = Array<HourlyTemp>()
        var hourlyArrayTomorrow = Array<HourlyTemp>()
        for hour in hourly {
            let epochTime = hour.objectForKey("time")
            let convertedTime = NSDate(timeIntervalSince1970: epochTime as! Double)
            let temp = hour.objectForKey("temperature") as! Double
            let hourlyTempObject = HourlyTemp.init(time: convertedTime, temp: temp)
            
            if DateHelper.checkToday(hourlyTempObject.hourlyTime) {
                hourlyArrayToday.append(hourlyTempObject)
            } else {
                hourlyArrayTomorrow.append(hourlyTempObject)
            }
        }
        todayWeather = sortHourlyArray(hourlyArrayToday)
        tomorrowWeather = sortHourlyArray(hourlyArrayTomorrow)
        NSNotificationCenter.defaultCenter().postNotificationName("Weather", object: nil)

    }
    
    /**
     Sort arrays into Morning, Afternoon, Evening
     Only ony HourlyTemp object is added to the array
     (the first object to that passes the if statement is added to the array)
     
     - parameter hourlyArray: array of HourlyTemp objects
     
     - returns: array with morning, afternoon and evening objects
     */
    private func sortHourlyArray(hourlyArray: Array<HourlyTemp>) -> NSMutableArray {
        let returnArray = NSMutableArray()
        var morningObject: HourlyTemp!
        var afternoonObject: HourlyTemp!
        var eveningObject: HourlyTemp!
        
        for hourObject in hourlyArray {
            let objectDate = hourObject.hourlyTime
            let calendar = NSCalendar.currentCalendar()
            let objectDateComponents = calendar.components([.Hour], fromDate: objectDate)
            let objectHour = objectDateComponents.hour
            
            if morningObject == nil && (objectHour >= 7 && objectHour <= 12) {
                hourObject.timeOfDay = "Morning"
                morningObject = hourObject
                returnArray.addObject(morningObject)
            }
            else if afternoonObject == nil && (objectHour > 13 && objectHour <= 17) {
                hourObject.timeOfDay = "Afternoon"
                afternoonObject = hourObject
                returnArray.addObject(afternoonObject)
            }
            else if eveningObject == nil && (objectHour > 18 && objectHour < 24) {
                hourObject.timeOfDay = "Evening"
                eveningObject = hourObject
                returnArray.addObject(eveningObject)
            }
        }
        return returnArray
    }
}
