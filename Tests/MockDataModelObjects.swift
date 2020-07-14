//
//  MockDataModelObjects.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/5/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@testable import Good_Deed_Counter

class MockDataModelObjects {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel", managedObjectModel: self.managedObjectModel)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    func createDisplayDeedsViewController() -> DisplayDeedsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ddvc: DisplayDeedsViewController! = storyboard.instantiateViewController(identifier: "DisplayDeedsViewController") as? DisplayDeedsViewController
        ddvc.loadViewIfNeeded()
        ddvc.dataSource.isShowingTutorial = false
        ddvc.dataSource.cdm = CoreDataManager(container: persistentContainer)
        ddvc.dataSource.loadDeeds()
        
        return ddvc
    }

}
