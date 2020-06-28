//
//  DaySection.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/11/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

struct DaySection: TimeSection {
    var date: Date
    var deeds: [Deed]
    static var dateFormat: String = "dd MMMM yyyy"
    
    static func group(deeds: [Deed]) -> [TimeSection] {
        let groups = Dictionary(grouping: deeds) { (deed) -> Date in
            return firstDayOfWeek(date: deed.date!)
        }

        return groups.map(DaySection.init(date:deeds:))
    }
    
    private static func firstDayOfWeek(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
}

