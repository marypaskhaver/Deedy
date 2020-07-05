//
//  SortDeedsTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/3/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest
import CoreData

@testable import Good_Deed_Counter

class SortDeedsTests: XCTestCase {
    var vc: ViewController!
    var sdvc: SortDeedsViewController!
    
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
        vc.loadViewIfNeeded()
        
        vc.dataSource.cdm = CoreDataManager(container: mockPersistentContainer)
        
        initDeedStubs()
                
        sdvc = storyboard.instantiateViewController(identifier: "SortDeedsViewController") as? SortDeedsViewController
        sdvc.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vc.dataSource = nil
        vc = nil
        sdvc = nil
        flushDeedData()
    }
    
    // MARK: - Needed funcs
    func addDeed(withTitle title: String, date: Date) {
        let deed = vc.dataSource.cdm.insertDeed(title: title, date: date)
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
    func testDeedsSortedByDay() {
        let calendar = Calendar.current
        
        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        addDeed(withTitle: "B", date: tomorrow!)
        addDeed(withTitle: "C", date: tomorrow!)

        ViewController.changeDateFormatter(toOrderBy: DaySection.dateFormat, timeSection: "Day")
        vc.dataSource.splitSections()
        
        XCTAssert((vc.dataSource.sections as Any) is [DaySection])

        XCTAssertFalse(vc.dataSource.sections.count == 0)
        XCTAssertTrue(vc.dataSource.sections.count == 2)
        XCTAssertFalse(vc.dataSource.sections.count == 1)
    }

    func testDeedsSortedByWeek() {
        let calendar = Calendar.current
        
        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let oneWeekFromNow = calendar.date(byAdding: .weekOfYear, value: 1, to: today)
        addDeed(withTitle: "B", date: oneWeekFromNow!)
        addDeed(withTitle: "C", date: oneWeekFromNow!)

        ViewController.changeDateFormatter(toOrderBy: WeekSection.dateFormat, timeSection: "Week")
        vc.dataSource.splitSections()
        
        XCTAssert((vc.dataSource.sections as Any) is [WeekSection])

        XCTAssertFalse(vc.dataSource.sections.count == 0)
        XCTAssertTrue(vc.dataSource.sections.count == 2)
        XCTAssertFalse(vc.dataSource.sections.count == 1)
    }

    func testDeedsSortedByMonth() {
        let calendar = Calendar.current
        
        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let oneMonthFromNow = calendar.date(byAdding: .month, value: 1, to: today)
        addDeed(withTitle: "B", date: oneMonthFromNow!)
        addDeed(withTitle: "C", date: oneMonthFromNow!)

        ViewController.changeDateFormatter(toOrderBy: MonthSection.dateFormat, timeSection: "Month")
        vc.dataSource.splitSections()
        
        XCTAssert((vc.dataSource.sections as Any) is [MonthSection])

        XCTAssertFalse(vc.dataSource.sections.count == 0)
        XCTAssertTrue(vc.dataSource.sections.count == 2)
        XCTAssertFalse(vc.dataSource.sections.count == 1)
    }

    func testDeedsSortedByYear() {
        let calendar = Calendar.current
        
        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let oneYearFromNow = calendar.date(byAdding: .year, value: 1, to: today)
        addDeed(withTitle: "B", date: oneYearFromNow!)
        addDeed(withTitle: "C", date: oneYearFromNow!)

        ViewController.changeDateFormatter(toOrderBy: YearSection.dateFormat, timeSection: "Year")
        vc.dataSource.splitSections()
        
        XCTAssert((vc.dataSource.sections as Any) is [YearSection])

        XCTAssertFalse(vc.dataSource.sections.count == 0)
        XCTAssertTrue(vc.dataSource.sections.count == 2)
        XCTAssertFalse(vc.dataSource.sections.count == 1)
    }

}
