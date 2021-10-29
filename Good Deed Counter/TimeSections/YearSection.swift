//
//  YearSection.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

struct YearSection: TimeSection {
    var date: Date
    var deeds: [Deed]
    static var dateFormat: String = "yyyy"
    
    static func group(deeds: [Deed]) -> [TimeSection] {
        // For each deed in deeds, get its date and use its particular components, specifically the year it was completed, to group it with other deeds made in the same year.
        let groups = Dictionary(grouping: deeds) { (deed) -> Date in
            return year(date: deed.date!)
        }
        
        return groups.map(YearSection.init(date:deeds:))
    }
    
    private static func year(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return calendar.date(from: components)!
    }
}

