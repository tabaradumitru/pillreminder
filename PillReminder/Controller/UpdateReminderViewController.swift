//
//  UpdateReminderViewController.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/6/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import UIKit

class UpdateReminderViewController: UIViewController {
    @IBOutlet weak var titleReminder: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var reminder = Reminder(title: String(), date: Date(), calendar: Calendar.current, notes: String())
    var reminderTableViewController: ReminderTableViewController?
    let storage = UserDefaultsStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultStyles()
        
        setOutlets()
    }
    
    @IBAction func cancelReminder(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveReminder(_ sender: UIButton) {
        let currentReminder = Reminder(title: titleReminder.text, date: date.date, calendar: date.calendar, notes: notes.text, id: reminder.id)
        storage.editReminder(reminder: currentReminder)
        self.dismiss(animated: true, completion: nil)
        reminderTableViewController?.reloadData()
        
        // tell reminder table to update table data
    }
    
    func setOutlets() {
        titleReminder.text = reminder.title
        date.date = reminder.date
        notes.text = reminder.notes
    }
    
    func setDefaultStyles() {
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.cornerRadius = 5
        notes.layer.borderWidth = 1
        notes.layer.borderColor = UIColor.white.cgColor
        notes.layer.cornerRadius = 5
        titleReminder.layer.borderWidth = 1
        titleReminder.layer.borderColor = UIColor.white.cgColor
        titleReminder.layer.cornerRadius = 5
        date.setValue(UIColor.white, forKey: "textColor")
        date.setValue(false, forKey: "highlightsToday")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
