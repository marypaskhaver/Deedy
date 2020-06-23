//
//  StreakAchievement+CoreDataProperties.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/23/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//
//

import Foundation
import CoreData


extension StreakAchievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StreakAchievement> {
        return NSFetchRequest<StreakAchievement>(entityName: "StreakAchievement")
    }

    @NSManaged public var goalNumber: Int32
    @NSManaged public var isDone: Bool
    @NSManaged public var title: String?

}
