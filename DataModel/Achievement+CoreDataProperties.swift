//
//  Achievement+CoreDataProperties.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/17/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var title: String?
    @NSManaged public var goalNumber: Int32
    @NSManaged public var isDone: Bool

}
