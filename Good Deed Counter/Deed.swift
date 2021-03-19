//
//  Deed.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

class Deed: Codable {
    var description: String
    var date: Date
    
    init(withDesc desc: String) {
        description = desc
        date = Date()
    }
}
