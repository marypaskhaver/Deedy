
//
//  CoreDataManagerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest
import CoreData

@testable import Good_Deed_Counter

class CoreDataManagerTests: XCTestCase {
    // MARK: - Class vars
    var sut: CoreDataManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
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
    
    // MARK: - Set up and tear down methods
    override func setUp() {
        super.setUp()
        sut = CoreDataManager(container: mockPersistentContainer)
        initDeedStubs()
        
        // When a context has an item saved to it, it puts out a notification
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil )
    }

    override func tearDown() {
        flushDeedData()
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Needed funcs
    
    func initDeedStubs() {
        // Put fake items in the "database"
        _ = sut.insertDeed(title: "1", date: Date())
        _ = sut.insertDeed(title: "2", date: Date())
        _ = sut.insertDeed(title: "3", date: Date())
        _ = sut.insertDeed(title: "4", date: Date())
        _ = sut.insertDeed(title: "5", date: Date())

        sut.save()
    }
    
    func flushDeedData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Deed")
        
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)

        
        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
        }
        
        try! mockPersistentContainer.viewContext.save()
    }
    
    func numberOfItemsInPersistentStore(withEntityName name: String) -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
        let results = try! mockPersistentContainer.viewContext.fetch(request)
        return results.count
    }
    
    func contextSaved(notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
    
    var saveNotificationCompleteHandler: ((Notification)->())?

    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    // MARK: - Deed tests
    func testCreatingDeed() {
        let title = "A"
        let date = Date()
        
        let deed = sut.insertDeed(title: title, date: date)
        
        XCTAssertNotNil(deed)
    }
    
    func testSavingDeed() {
        let title = "A"
        let date = Date()

        let expect = expectation(description: "Context Saved")
        
        waitForSavedNotification { (notification) in
            expect.fulfill()
        }
        
        _ = sut.insertDeed(title: title, date: date)
        sut.save()

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchingDeeds() {
        let deeds = sut.fetchDeeds()

        // There should be 5 that were initialized in the initStubs() method
        XCTAssertEqual(deeds.count, 5)
    }

}
