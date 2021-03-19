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

