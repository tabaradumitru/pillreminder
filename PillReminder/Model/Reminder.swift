//
//  Reminder.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/5/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import Foundation

class Reminder: Codable {
    var title: String?
    var date: Date
    var calendar: Calendar
    var notes: String?
    let id: String
    
    init(title: String?, date: Date, calendar: Calendar, notes: String?) {
        self.title = title
        self.date = date
        self.calendar = calendar
        self.notes = notes
        self.id = UUID().uuidString
    }
    
    init(title: String?, date: Date, calendar: Calendar, notes: String?, id: String) {
        self.title = title
        self.date = date
        self.calendar = calendar
        self.notes = notes
        self.id = id
    }
}
