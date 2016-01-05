//
//  CalendarViewController.swift
//  SunriseCalendarChallenge
//
//  Created by Brandon Leeds on 12/31/15.
//  Copyright © 2015 Brandon Leeds. All rights reserved.
//

import UIKit
import CoreLocation

class CalendarViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var IBcalendarCollectionView: UICollectionView!
    @IBOutlet weak var IBcalendarTableView: UITableView!
    @IBOutlet weak var IBtableViewHeightConstraint: NSLayoutConstraint!

    // Used to know which collection view cell is currently selected
    var currentSelectionIndexPath: NSIndexPath?
    // Total days in calendar
    let totalDays = 392
    
    var calendarStartDate: NSDate!
    var sundayTodayDifference = Int()
    // used to select today collection view cell
    var firstLoad = true
    
    var currentTopSection = Int()
    var didSelect = false
    
    // for animation
    var expanded = false
    
    // detect scroll direction of tableview
    var lastContentOffset = CGPoint()
    var originalTableViewFrame: CGRect!
    let weather = WeatherAPI.sharedInstance
    
//    var locationManager: CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedWeatherData:", name:"Weather", object: nil)
        
        // set 7 cells for each row depending on screen size
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/7, height: screenWidth/7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        IBcalendarCollectionView.setCollectionViewLayout(layout, animated: false)

    }

    override func viewWillAppear(animated: Bool) {
    
        // get calendar start date, used to calculate days
        let startDateArray = DateHelper.setStartDateAndDifference()
        calendarStartDate = startDateArray[0] as! NSDate
        sundayTodayDifference = startDateArray[1] as! Int
        
        IBcalendarTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // scroll to current day
        let indexPath = NSIndexPath(forRow: 119, inSection: 0)
        IBcalendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        // scroll to today, calculated by adding the difference from today and Sunday to 119
        
        let tableIndexPath = NSIndexPath(forRow: 0, inSection: 119 - sundayTodayDifference)
        IBcalendarTableView.scrollToRowAtIndexPath(tableIndexPath, atScrollPosition: .Top, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     set cell as the selected cell and reload collectionView
     
     - parameter indexPath: current cell selected
     */
    func setSelectedCell(indexPath: NSIndexPath) {
        currentSelectionIndexPath = indexPath
        IBcalendarCollectionView.reloadData()
    }
    
    //MARK: CollectionView Delegate

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDays
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let dayArray = DateHelper.getDay(indexPath.row, startDate: calendarStartDate)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        cell.setUnSelected()
        cell.day = dayArray[0] as! Int
        cell.date = dayArray[2] as! NSDate
        cell.checkDateBeforeToday()
        
        // first of month
        if dayArray[1] as! String != "" {
            cell.dayLabel.text = String(dayArray[1])
            cell.dayLabel.textColor = UIColor.redColor()
        }
        else {
            cell.dayLabel.text = String(dayArray[0])
            cell.dayLabel.textColor = UIColor.blackColor()
        }
        
        // current selected cell
        if indexPath == currentSelectionIndexPath {
            cell.setSelected()
        }
        
        // first load select today cell
        if firstLoad {
            if DateHelper.checkToday(cell.date) == true {
                cell.setSelected()
                currentSelectionIndexPath = indexPath
                firstLoad = false
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        didSelect = true
        currentSelectionIndexPath = indexPath
        
        IBcalendarCollectionView.reloadData()
        
        // scroll tableview to same date
        let tableIndexPath = NSIndexPath(forRow: 0, inSection: indexPath.row)
        IBcalendarTableView.scrollToRowAtIndexPath(tableIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    //MARK: TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return totalDays
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 119 - sundayTodayDifference:
                if weather.todayWeather == nil {
                    return 1
                } else {
                    return weather.todayWeather.count
                }
            
            case 120 - sundayTodayDifference:
                if weather.tomorrowWeather == nil {
                    return 1
                } else {
                    return weather.tomorrowWeather.count
                }
            
            default:
                break
            
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 119 - sundayTodayDifference:
            // todayWeather array contains hourly weather objects
            if weather.todayWeather != nil {
                let hourlyObject = weather.todayWeather[indexPath.row] as! HourlyTemp
                let cell = tableView.dequeueReusableCellWithIdentifier("TemperatureCell") as! TemperatureCell
                let formattedTemperature = String(format: "%.0f\u{00B0}", Float(hourlyObject.hourlyTemp))
                cell.temperature.text = formattedTemperature
                cell.timeOfDayLabel.text = hourlyObject.timeOfDay
                return cell
            }
        case 120 - sundayTodayDifference:
            // tomorrowWeather array contains hourly weather objects
            if weather.tomorrowWeather != nil {
                let hourlyObject = weather.tomorrowWeather[indexPath.row] as! HourlyTemp
                let cell = tableView.dequeueReusableCellWithIdentifier("TemperatureCell") as! TemperatureCell
                let formattedTemperature = String(format: "%.0f\u{00B0}", Float(hourlyObject.hourlyTemp))
                cell.temperature.text = formattedTemperature
                cell.timeOfDayLabel.text = hourlyObject.timeOfDay
                return cell
            }
        default:
            break
            
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("NoEventCell")
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // set custom headers with formatted date
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableCell
        let headerString = DateHelper.getHeaderDay(section, startDate: calendarStartDate)
        headerCell.dayLabel.text = headerString
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 119 - sundayTodayDifference, (120 - sundayTodayDifference):
            return 31
        default:
            return 50
        }
    }
    
    //MARK: Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let topSection = IBcalendarTableView.indexPathsForVisibleRows
        let topRow = topSection![0]
        let currentOffset = scrollView.contentOffset
        
        // if top section isn't current top and collection view cell hasen't been selected
        // and not first load, then scroll collection view and select cell
        if topRow.section != currentTopSection && didSelect == false && firstLoad == false && IBcalendarCollectionView != scrollView {
            currentTopSection = topRow.section
            let indexPath = NSIndexPath(forRow: currentTopSection, inSection: 0)
            setSelectedCell(indexPath)
            IBcalendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
        // if collectionview expanded and scroll direction is up, collapse collectionview
        else if expanded && scrollView == IBcalendarTableView && currentOffset.y > lastContentOffset.y && didSelect == false {
            expanded = false
            collapseCollectionView()
        }
        lastContentOffset = currentOffset
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // expand collection view
        if expanded == false && scrollView == IBcalendarCollectionView {
            expanded = true
            expandCollectionView()
        }
    }
    
    /**
     as a safety precaution
     */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        didSelect = false
    }
    
    //MARK: Animations
    /**
    resize table view to the bottom of the collection view
    */
    func expandCollectionView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        originalTableViewFrame = IBcalendarTableView.frame
        let tableViewY = IBcalendarCollectionView.frame.origin.y + IBcalendarCollectionView.frame.height
        var frame = IBcalendarTableView.frame
        frame.origin.y = screenSize.height / 2
        frame.size.height = frame.origin.y

        UIView.animateWithDuration(0.5) { () -> Void in
            self.IBcalendarTableView.frame  = frame
            self.IBtableViewHeightConstraint.constant = tableViewY - 20 // status bar height
        }
    }
    /**
     resize tableview to original frame
     */
    func collapseCollectionView() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.IBcalendarTableView.frame  = self.originalTableViewFrame
            self.IBtableViewHeightConstraint.constant = self.originalTableViewFrame.origin.y - 20 // status bar height
        }
        IBcalendarCollectionView.scrollToItemAtIndexPath(currentSelectionIndexPath!, atScrollPosition: .Top, animated: true)
    }
    

    


  
    //MARK: Weather Notification
    
    func receivedWeatherData (sender: NSNotificationCenter) {
        IBcalendarTableView.reloadData()
    }
}
