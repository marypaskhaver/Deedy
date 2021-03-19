//
//  DailyChallenge+CoreDataProperties.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/16/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyChallenge> {
        return NSFetchRequest<DailyChallenge>(entityName: "DailyChallenge")
    }

    @NSManaged public var dailyGoal: Int32
    @NSManaged public var date: Date?

}
