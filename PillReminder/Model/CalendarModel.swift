//
//  Calendar.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/3/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import Foundation

class CalendarModel {

    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    let date = Date()
    let calendar = Calendar.current
    
    var day = Int()
    var weekday = Int()
    var weekOfMonth = Int()
    var month = Int()
    var year = Int()
    
    var numberOfEmptyBox = 0
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    
    var currentMonth: String {
        return Months[month]
    }
    var currentMonthDays: Int {
        return DaysInMonths[month]
    }
    
    init() {
        day = calendar.component(.day, from: date)
        weekday = calendar.component(.weekday, from: date)
        weekOfMonth = calendar.component(.weekOfMonth, from: date)
        month = calendar.component(.month, from: date) - 1
        year = calendar.component(.year, from: date)
        numberOfEmptyBox = (7 * weekOfMonth) - (7 - weekday) - day
        positionIndex = numberOfEmptyBox
        changeFebruaryNumberOfDays()
    }
    
    func getCurrentMonthAndYear() -> String {
        return "\(currentMonth) \(year)"
    }
    
    func getPreviousMonth() {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            changeFebruaryNumberOfDays()
            direction = -1
            getStartDateDayPosition()
        default:
            month -= 1
            direction = -1
            getStartDateDayPosition()
        }
    }
    
    func getNextMonth() {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            changeFebruaryNumberOfDays()
            direction = 1
            getStartDateDayPosition()
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
        }
    }
    
    func getStartDateDayPosition() {
        switch direction {
        case 0:
            switch day {
            case 1...7:
                numberOfEmptyBox = weekday - day
                case 8...14:
                    numberOfEmptyBox = weekday - day - 7
                case 15...21:
                    numberOfEmptyBox = weekday - day - 14
                case 22...28:
                    numberOfEmptyBox = weekday - day - 21
                case 29...31:
                    numberOfEmptyBox = weekday - day - 28
            default:
                break
            }
            positionIndex = numberOfEmptyBox
           
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + DaysInMonths[month]) % 7
            positionIndex = nextNumberOfEmptyBox
            
        case -1:
            previousNumberOfEmptyBox = 7 - (DaysInMonths[month] - positionIndex) % 7
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func getCurrentMonthDays() -> Int {
        switch direction {
        case 0:
            return DaysInMonths[month] + numberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func getCurrentDay(indexPathRow: Int) -> Int {
        switch direction {
        case 0:
            return indexPathRow + 1 - numberOfEmptyBox
        case 1:
            return indexPathRow + 1 - nextNumberOfEmptyBox
        case -1:
            return indexPathRow + 1 - previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func isLeapYear(_ year: Int) -> Bool {
        return ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
    }
    
    func changeFebruaryNumberOfDays() {
        DaysInMonths[1] = isLeapYear(year) ? 29 : 28;
    }
    
    func getCurrentDateAsString(indexPathRow: Int) -> String {
        let currentDay = getCurrentDay(indexPathRow: indexPathRow)
        let currentMonth = month + 1
        let currentYear = year
        
        return ("\(currentDay)-\(currentMonth)-\(currentYear)")
    }
    
    func createDateFromDay(dateToConvert: String) -> Date {
        let dateFormatter = DateFormatter()
        let format = "d-m-yyyy"
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateToConvert)!
    }
}
