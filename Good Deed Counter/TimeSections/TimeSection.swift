//
//  TimeSection.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

protocol TimeSection {
    var date: Date { get set }
    var deeds: [Deed] { get set }
    static func group(deeds : [Deed]) -> [TimeSection]
    static var dateFormat: String { get }
}
