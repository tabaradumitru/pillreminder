//
//  ReminderTableViewController.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/5/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {
    
    let itemArray = ["Paracetamol", "Citramon", "Vitamine"]
    let storage = UserDefaultsStorage()
    var reminderToSearch = String()
    var dataToShow = [Reminder]()
    var dateToShow = String()
    
    var selectedReminder = Reminder(title: String(), date: Date(), calendar: Calendar.current, notes: String())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dateToShow != "" {
            dataToShow = storage.getRemindersForDate(date: dateToShow)
        }

        if reminderToSearch != "" {
            dataToShow = storage.searchReminders(byKeyword: reminderToSearch)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderItemCell", for: indexPath) as! ReminderTableViewCell
        
        cell.titleLabel?.text = dataToShow[indexPath.row].title
        cell.dateLabel?.text = getStringDate(date: dataToShow[indexPath.row].date)
        cell.currentReminder = dataToShow[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedReminder = dataToShow[indexPath.row]
        
        performSegue(withIdentifier: "showUpdateReminder", sender: self)
    }
    
    func getStringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        return formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUpdateReminder" {
            let destinationVC = segue.destination as! UpdateReminderViewController
            destinationVC.reminderTableViewController = self
            destinationVC.reminder = selectedReminder
        }
    }
    
    func reloadData() {
        dataToShow = storage.getRemindersForDate(date: dateToShow)
        self.tableView.reloadData()
    }
}
