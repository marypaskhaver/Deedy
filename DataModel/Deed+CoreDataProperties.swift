//
//  Deed+CoreDataProperties.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/11/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Deed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deed> {
        return NSFetchRequest<Deed>(entityName: "Deed")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?

}
