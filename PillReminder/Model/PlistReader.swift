//
//  PlistReader.swift
//  PillReminder
//
//  Created by Dumitru Tabara on 1/5/20.
//  Copyright © 2020 Dumitru Tabara. All rights reserved.
//

import Foundation

class PlistReader {
//    let xml = FileManager.default.contents(atPath: Bundle.main.path(forResource: "Reminders", ofType: "plist"))
    
    init() {}

//    func read() {
//        return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
//    }
    
    func getPlist(withName name: String) -> [String]?
    {
        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }

        return nil
    }
    
    func saveToPlist(data: String) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")

        do {
            let data = try encoder.encode(preferences)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
}
