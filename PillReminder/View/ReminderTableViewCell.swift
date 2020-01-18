//
//  ReminderTableViewCell.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/6/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var currentReminder = Reminder(title: String(), date: Date(), calendar: Calendar.current, notes: String())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
