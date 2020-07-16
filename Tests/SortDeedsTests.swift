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
    var ddvc: DisplayDeedsViewController!
    var sdvc: SortDeedsViewController!

    lazy var managedObjectModel: NSManagedObjectModel = MockDataModelObjects().managedObjectModel
    lazy var mockPersistentContainer: NSPersistentContainer = MockDataModelObjects().persistentContainer
        
    let dateHandler = DateHandler()
    let calendar = Calendar.current

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        ddvc = MockDataModelObjects().createDisplayDeedsViewController()

        sdvc = storyboard.instantiateViewController(identifier: "SortDeedsViewController") as? SortDeedsViewController
        sdvc.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        ddvc.dataSource = nil
        ddvc = nil
        sdvc = nil
        flushDeedData()
    }
    
    // MARK: - Needed funcs
    func addDeed(withTitle title: String, date: Date) {
        let deed = ddvc.dataSource.cdm.insertDeed(title: title, date: date)
        ddvc.dataSource.deeds.append(deed!)
        // Split deeds into proper sections

        ddvc.updateSections()
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
        let today = dateHandler.currentDate() as Date
        addDeed(withTitle: "A", date: today)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        addDeed(withTitle: "B", date: tomorrow!)
        addDeed(withTitle: "C", date: tomorrow!)

        DisplayDeedsViewController.changeDateFormatter(toOrderBy: DaySection.dateFormat, timeSection: "Day")
        ddvc.dataSource.splitSections()
        
        XCTAssert((ddvc.dataSource.sections as Any) is [DaySection])

        XCTAssertFalse(ddvc.dataSource.sections.count == 0)
        XCTAssertTrue(ddvc.dataSource.sections.count == 2)
        XCTAssertFalse(ddvc.dataSource.sections.count == 1)
    }

    func testDeedsSortedByWeek() {
        let today = dateHandler.currentDate() as Date
        addDeed(withTitle: "A", date: today)
        
        let oneWeekFromNow = calendar.date(byAdding: .weekOfYear, value: 1, to: today)
        addDeed(withTitle: "B", date: oneWeekFromNow!)
        addDeed(withTitle: "C", date: oneWeekFromNow!)

        DisplayDeedsViewController.changeDateFormatter(toOrderBy: WeekSection.dateFormat, timeSection: "Week")
        ddvc.dataSource.splitSections()
        
        XCTAssert((ddvc.dataSource.sections as Any) is [WeekSection])

        XCTAssertFalse(ddvc.dataSource.sections.count == 0)
        XCTAssertTrue(ddvc.dataSource.sections.count == 2)
        XCTAssertFalse(ddvc.dataSource.sections.count == 1)
    }

    func testDeedsSortedByMonth() {
        let today = dateHandler.currentDate() as Date
        addDeed(withTitle: "A", date: today)
        
        let oneMonthFromNow = calendar.date(byAdding: .month, value: 1, to: today)
        addDeed(withTitle: "B", date: oneMonthFromNow!)
        addDeed(withTitle: "C", date: oneMonthFromNow!)

        DisplayDeedsViewController.changeDateFormatter(toOrderBy: MonthSection.dateFormat, timeSection: "Month")
        ddvc.dataSource.splitSections()
        
        XCTAssert((ddvc.dataSource.sections as Any) is [MonthSection])

        XCTAssertFalse(ddvc.dataSource.sections.count == 0)
        XCTAssertTrue(ddvc.dataSource.sections.count == 2)
        XCTAssertFalse(ddvc.dataSource.sections.count == 1)
    }

    func testDeedsSortedByYear() {
        let today = dateHandler.currentDate() as Date
        addDeed(withTitle: "A", date: today)
        
        let oneYearFromNow = calendar.date(byAdding: .year, value: 1, to: today)
        addDeed(withTitle: "B", date: oneYearFromNow!)
        addDeed(withTitle: "C", date: oneYearFromNow!)

        DisplayDeedsViewController.changeDateFormatter(toOrderBy: YearSection.dateFormat, timeSection: "Year")
        ddvc.dataSource.splitSections()
        
        XCTAssert((ddvc.dataSource.sections as Any) is [YearSection])

        XCTAssertFalse(ddvc.dataSource.sections.count == 0)
        XCTAssertTrue(ddvc.dataSource.sections.count == 2)
        XCTAssertFalse(ddvc.dataSource.sections.count == 1)
    }

}
