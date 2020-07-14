//
//  MyProgressView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class MyProgressView: UIProgressView {
    var cdm: CoreDataManager = CoreDataManager()
    var calendar = Calendar.current
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendar.timeZone = NSTimeZone.local
        self.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
    }

}
