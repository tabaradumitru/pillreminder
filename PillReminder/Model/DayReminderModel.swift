//
//  DayReminderModel.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/5/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import Foundation

class DayReminderModel {
    var day = Int()
    var month = Int()
    var year = Int()
    var reminders: [Reminder] = []
    
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
}
