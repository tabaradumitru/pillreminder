//
//  ViewController.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/3/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UICollectionViewDelegate,
                      UICollectionViewDataSource,
                      UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var calendarModel: CalendarModel = CalendarModel()
    let storage = UserDefaultsStorage()
    var dateToShow = String()
    var dateToCreate: Date?
    var shouldSearchReminder = false
    var reminderToSearch = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultStyles()
        searchTextField.delegate = self
    }

    @IBAction func calendarSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        calendarModel.getNextMonth()
        monthLabel.text = calendarModel.getCurrentMonthAndYear()
        calendar.reloadData()
    }
    
    
    @IBAction func calendarSwipeRight(_ sender: UISwipeGestureRecognizer) {
        calendarModel.getPreviousMonth()
        monthLabel.text = calendarModel.getCurrentMonthAndYear()
        calendar.reloadData()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if searchTextField.text! != "" {
            reminderToSearch = searchTextField.text!
            shouldSearchReminder = true
            if storage.searchReminders(byKeyword: reminderToSearch).count != 0 {
                performSegue(withIdentifier: "showReminderTable", sender: self)
            }
        }
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarModel.getCurrentMonthDays();
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        if cell.isHidden {
            cell.isHidden = false
        }

        let currentDateString = calendarModel.getCurrentDateAsString(indexPathRow: indexPath.row)
        let currentDay = calendarModel.getCurrentDay(indexPathRow: indexPath.row)
        
        
        cell.dateLabel.text = String(currentDay)
        cell.hasRemindersLabel.isHidden = !storage.checkIfDateHasReminders(date: currentDateString)
        
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // se creaza un string cu ziua respectiva de forma day month year
        let currentDate = calendarModel.getCurrentDateAsString(indexPathRow: indexPath.row)
        dateToShow = currentDate
        
        // daca ziua respectiva are reminders atunci deschide lista de reminders
        if storage.checkIfDateHasReminders(date: currentDate) {
            // open reminderTableViewController with reminders from specific date
            performSegue(withIdentifier: "showReminderTable", sender: self)
        } else { // altfel deschide fereastra de adaugare a unui reminder cu ziua data completata
            // salveaza data celulei curente in dataToCreate
            dateToCreate = calendarModel.createDateFromDay(dateToConvert: calendarModel.getCurrentDateAsString(indexPathRow: indexPath.row))
            
            // deschide create reminder view
            performSegue(withIdentifier: "createReminderSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReminderTable" && shouldSearchReminder {
            let destinationVC = segue.destination as! ReminderTableViewController
            destinationVC.reminderToSearch = reminderToSearch
            shouldSearchReminder = false
        }
        
        if segue.identifier == "showReminderTable" {
            let destinationVC = segue.destination as! ReminderTableViewController
            destinationVC.dateToShow = dateToShow
        }
        
        if segue.identifier == "createReminderSegue" && dateToCreate != nil {
            let destinationVC = segue.destination as! CreateReminderViewController
            destinationVC.mainVC = self
            destinationVC.defaultDate = dateToCreate
        }
    }
    
    func setDefaultStyles() {
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.white.cgColor
        addButton.layer.cornerRadius = 35
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.cornerRadius = 5
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        monthLabel.text = calendarModel.getCurrentMonthAndYear()
    }
    
    func reloadData() {
        calendar.reloadData()
    }
}

