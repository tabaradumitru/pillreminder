//
//  CreateReminderViewController.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/4/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import UIKit

class CreateReminderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var titleReminder: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notes: UITextView!
    
    var reminderDays: [Reminder] = []
    let storage = UserDefaultsStorage()
    var defaultDate: Date?
    var mainVC: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaultDate != nil {
            self.date.date = defaultDate!
        }
        
        setDefaultStyles()

        titleReminder.delegate = self
        notes.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleReminder.endEditing(true)
        return true
    }
    
    
    @IBAction func cancelReminder(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveReminder(_ sender: UIButton) {
        if titleReminder.text != "" {
            let currentReminder = Reminder(title: titleReminder.text, date: date.date, calendar: date.calendar, notes: notes.text)
            storage.addReminder(reminder: currentReminder)
            mainVC?.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
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
