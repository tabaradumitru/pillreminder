//
//  LocalNotificationManager.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/7/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//
import UserNotifications

import Foundation

class LocalNotificationManager {
    var notifications = [Reminder]()
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications() {
        for notification in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title!
            content.sound    = .default
            
            var dateComponent = DateComponents()
            dateComponent.calendar = notification.calendar
            dateComponent.year = notification.calendar.component(.year, from: notification.date)
            dateComponent.day = notification.calendar.component(.day, from: notification.date)
            dateComponent.month = notification.calendar.component(.month, from: notification.date)
            dateComponent.weekday = notification.calendar.component(.weekday, from: notification.date)
            dateComponent.hour = notification.calendar.component(.hour, from: notification.date)
            dateComponent.minute = notification.calendar.component(.minute, from: notification.date)
            dateComponent.second = 0

            print(dateComponent)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}
