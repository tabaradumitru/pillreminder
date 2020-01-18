//
//  UserDefaultsStorage.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/5/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import Foundation

class UserDefaultsStorage {
    var localNotificationManager = LocalNotificationManager()
    let defaults = UserDefaults.standard
    let remindersKey = "Reminders"
    
    func addReminder(reminder: Reminder) {
        var reminders = getAllReminders()

        let stringifiedReminder = stringify(encode(reminder))
        
        reminders.append(stringifiedReminder)
        
        defaults.set(reminders, forKey: remindersKey)
        localNotificationManager.notifications = getAllRemindersAsArray()
        localNotificationManager.schedule()
    }
    
    func getAllReminders() -> [String] {
        let reminders = defaults.array(forKey: remindersKey) as? [String] ?? [String]()
        
        var stringReminders = [String]()
        
        reminders.forEach({ reminder in
            stringReminders.append(reminder)
        })
        
        if stringReminders.count > 0 {
            return stringReminders
        }
        
        return [String]()
    }
    
    func stringify(_ object: Data) -> String {
        return String(decoding: object, as: UTF8.self)
    }
    
    func encode(_ object: Reminder) -> Data {
        return try! JSONEncoder().encode(object)
    }
    
    func getAllRemindersAsArray() -> [Reminder] {
        let allReminders = getAllReminders()
        var remindersArray = [Reminder]()
        
        allReminders.forEach({reminder in
            let data = Data(reminder.utf8)
            remindersArray.append(try! JSONDecoder().decode(Reminder.self, from: data.self))
        })
        
        return remindersArray
    }
    
    func checkIfDateHasReminders(date: String) -> Bool {
        let allReminders = getAllRemindersAsArray()
        var hasAnyReminders = false
        
        allReminders.forEach({ reminder in
            let day = reminder.calendar.component(.day, from: reminder.date)
            let month = reminder.calendar.component(.month, from: reminder.date)
            let year = reminder.calendar.component(.year, from: reminder.date)
            let stringDate = ("\(day)-\(month)-\(year)")
            if stringDate == date {
                hasAnyReminders = true
            }
        })
        return hasAnyReminders
    }
    
    func getRemindersForDate(date: String) -> [Reminder] {
        let allReminders = getAllRemindersAsArray()
        var dateReminders = [Reminder]()
        
        allReminders.forEach({ reminder in
            let day = reminder.calendar.component(.day, from: reminder.date)
            let month = reminder.calendar.component(.month, from: reminder.date)
            let year = reminder.calendar.component(.year, from: reminder.date)
            let stringDate = ("\(day)-\(month)-\(year)")
            if stringDate == date {
                dateReminders.append(reminder)
            }
        })
        
        return dateReminders
    }
    
    func editReminder(reminder: Reminder) {
        let allReminders = getAllRemindersAsArray()
        var stringifiedReminders = [String]()
        
        for var dbReminder in allReminders {
            if dbReminder.id == reminder.id {
                dbReminder = reminder
            }
            stringifiedReminders.append(stringify(encode(dbReminder)))
        }
        defaults.set(stringifiedReminders, forKey: remindersKey)
    }
    
    func searchReminders(byKeyword: String) -> [Reminder] {
        let allReminders = getAllRemindersAsArray()
        var results = [Reminder]()
        allReminders.forEach({ reminder in
            if reminder.title!.contains(byKeyword) {
                results.append(reminder)
            }
        })
        
        return results
    }
}
