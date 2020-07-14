//
//  BarChartViewControllerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/12/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest
import CoreData

@testable import Good_Deed_Counter

class BarChartViewControllerTests: XCTestCase {
    var ddvc: DisplayDeedsViewController!
    var bvc: BarChartViewController!

    lazy var managedObjectModel: NSManagedObjectModel = MockDataModelObjects().managedObjectModel
    lazy var mockPersistentContainer: NSPersistentContainer = MockDataModelObjects().persistentContainer
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        ddvc = MockDataModelObjects().createDisplayDeedsViewController()
        
        bvc = storyboard.instantiateViewController(identifier: "BarChartViewController") as? BarChartViewController
        bvc.cdm = ddvc.dataSource.cdm
            
        initDeedStubs()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        ddvc.dataSource = nil
        ddvc = nil
        bvc = nil
        flushDeedData()
    }
    
    // MARK: - Needed funcs
    func addDeed(withTitle title: String, date: Date) {
        let deed = ddvc.dataSource.cdm.insertDeed(title: title, date: date)
        ddvc.dataSource.deeds.append(deed!)

        ddvc.updateSections()
        ddvc.dataSource.saveDeeds()

        bvc.cdm = ddvc.dataSource.cdm
    }
    
    func initDeedStubs() {
        // Put fake items in the "database"
        addDeed(withTitle: "A", date: Date())
        addDeed(withTitle: "B", date: Date())
        
        ddvc.dataSource.saveDeeds()
    }
    
    func flushDeedData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Deed")
        
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)

        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
        }
        
        try! mockPersistentContainer.viewContext.save()
    }
    
    // MARK: - Tests
    func testIfGetsDeedsInPastMonth() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Include everything done today and 29 days ago (30 days total)
        let oneMonthBeforeToday = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: Date()))

        addDeed(withTitle: "1", date: oneMonthBeforeToday!)
        
        XCTAssert(bvc.getDeedsDoneInPastMonth().count == 3)
    }
}
