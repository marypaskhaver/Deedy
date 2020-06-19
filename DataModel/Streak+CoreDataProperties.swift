//
//  Streak+CoreDataProperties.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/19/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Streak {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Streak> {
        return NSFetchRequest<Streak>(entityName: "Streak")
    }

    @NSManaged public var daysKept: Int32
    @NSManaged public var date: Date?

}
