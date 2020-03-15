//
//  WeekSection.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

struct WeekSection: TimeSection {
    var date: Date
    var deeds: [Deed]
    
    static func group(deeds: [Deed]) -> [TimeSection] {
        let groups = Dictionary(grouping: deeds) { (deed) -> Date in
            return firstWeekOfMonth(date: deed.date)
        }
        
        return groups.map(WeekSection.init(date:deeds:))
    }
    
    private static func firstWeekOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .weekOfMonth, .month, .year], from: date.startOfWeek ?? date)
        return calendar.date(from: components)!
    }
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return sunday
    }
}
