//
//  MonthSection.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/8/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

struct MonthSection: TimeSection {
    var date: Date
    var deeds: [Deed]
    static var dateFormat: String = "MMMM yyyy"

    static func group(deeds: [Deed]) -> [TimeSection] {
        // For each deed in deeds, get its date and use its particular components, including and especially the month it was completed, to group it with other deeds made in the same month.
        let groups = Dictionary(grouping: deeds) { (deed) -> Date in
            return firstDayOfMonth(date: deed.date!)
        }
        
        return groups.map(MonthSection.init(date:deeds:))
    }
    
    private static func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
}

