//
//  Good_Deed_CounterTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest
import CoreData

@testable import Good_Deed_Counter

class Good_Deed_CounterTests: XCTestCase {
    var vc: ViewController!
    var sdvc: SortDeedsViewController!
    var ddvc: AddDeedViewController!
    
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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        vc = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController
        
        vc.cdm = CoreDataManager(container: mockPersistentContainer)
        vc.loadViewIfNeeded()
        
        vc.dataSource.cdm = CoreDataManager(container: mockPersistentContainer)
        
        ddvc = storyboard.instantiateViewController(identifier: "DeedDetailViewController") as? AddDeedViewController
        ddvc.loadViewIfNeeded()

        initDeedStubs()
                
        sdvc = storyboard.instantiateViewController(identifier: "SortDeedsViewController") as? SortDeedsViewController
        sdvc.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vc.dataSource = nil
        vc = nil
        ddvc = nil
        sdvc = nil
        flushDeedData()
    }
    
    // MARK: - Needed funcs
    func addDeed(withTitle title: String, date: Date) {
        let deed = vc.cdm.insertDeed(title: title, date: date)
        vc.dataSource.deeds.append(deed!)
        // Split deeds into proper sections

        vc.updateSections()
    }
    
    func initDeedStubs() {
        // Put fake items in the "database"
        addDeed(withTitle: "A", date: Date())
        addDeed(withTitle: "B", date: Date())
        addDeed(withTitle: "C", date: Date())
        addDeed(withTitle: "D", date: Date())
        addDeed(withTitle: "E", date: Date())
        
        vc.dataSource.saveDeeds()
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
    
    // MARK: - Tests for ViewController
    func testAddingDeed() {
        XCTAssertEqual(vc.dataSource.deeds.count, 5)
                
        ddvc.textView.text = "Hello"
        
        vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))
        
        XCTAssertEqual(vc.dataSource.deeds.count, 6)
    }
    
    func testSectionDeedsEqualToVCDeeds() {
        let calendar = Calendar.current

        var sumDeeds = 0

        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        addDeed(withTitle: "B", date: tomorrow!)
        addDeed(withTitle: "C", date: tomorrow!)

        for section in vc.dataSource.sections {
            sumDeeds += section.deeds.count
        }

        XCTAssertEqual(vc.dataSource.deeds.count, sumDeeds)
    }


    func testDeedLabelUpdates() {
        XCTAssert(vc.totalDeedsLabel != nil)
        XCTAssert(vc.totalDeedsLabel.text != nil)
        
        XCTAssertEqual(vc.totalDeedsLabel.text, String(5))

        addDeed(withTitle: "A", date: Date())
        vc.updateSections()
        
        XCTAssertEqual(vc.totalDeedsLabel.text, String(6))
    }

    func testDeedsSortedByDay() {
        let calendar = Calendar.current
        
        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        addDeed(withTitle: "B", date: tomorrow!)
        addDeed(withTitle: "C", date: tomorrow!)

        ViewController.changeDateFormatter(toOrderBy: "dd MMMM yyyy", timeSection: "Day")
        vc.dataSource.splitSections()
        
        XCTAssert((vc.dataSource.sections as Any) is [DaySection])

        XCTAssertFalse(vc.dataSource.sections.count == 0)
        XCTAssertTrue(vc.dataSource.sections.count == 2)
        XCTAssertFalse(vc.dataSource.sections.count == 1)
    } 

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
