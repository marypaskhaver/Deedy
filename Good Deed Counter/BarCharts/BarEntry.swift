//
//  BarEntry.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

// Struct representing an entry in the monthly deeds bar chart.
struct BarEntry {
    // Number of deeds done on a date.
    let count: Int
    
    // Some date in the past month that some deeds were done on.
    let title: String
}
