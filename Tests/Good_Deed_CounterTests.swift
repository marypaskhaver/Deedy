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
    var ddvc: DeedDetailViewController!

    let testContext = NSManagedObjectContext.contextForTests()
            
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.vc = storyboard.instantiateViewController(identifier: "ViewController") as ViewController
        self.sdvc = storyboard.instantiateViewController(identifier: "SortDeedsViewController") as SortDeedsViewController
        self.ddvc = storyboard.instantiateViewController(identifier: "DeedDetailViewController") as DeedDetailViewController

        vc.loadViewIfNeeded()
        vc.deeds = []
        vc.updateSections()
        
        ddvc.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func addDeeds(fromArray arr: [Deed]) {
        for deed in arr {
            ddvc.textView.text = deed.title
            vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))
        }
    }
    
    func testAddingDeed() {
        let deedCountBeforeAdding = vc.deeds.count
        
        ddvc.textView.text = "A"
        
        vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))
        
        XCTAssertEqual(deedCountBeforeAdding + 1, vc.deeds.count)
    }
    
    func testSectionDeedsEqualToVCDeeds() {
        var calendar = Calendar.current
        
        var sumDeeds = 0
        
        let a = Deed(context: testContext)
        a.title = "A"
        a.date = Date()
        
        let b = Deed(context: testContext)
        b.title = "B"
        b.date = calendar.date(byAdding: .day, value: 1, to: a.date!)
        
        let c = Deed(context: testContext)
        c.title = "C"
        c.date = calendar.date(byAdding: .day, value: 1, to: b.date!)
        
        vc.deeds = [a, b, c]
        vc.updateSections()

        for section in vc.sections {
            sumDeeds += section.deeds.count
        }

        XCTAssertEqual(vc.deeds.count, sumDeeds)
    }

    // Fails bc uses shared CoreData, not mock database-- fix
    func testDeedLabelUpdates() {
        XCTAssert(vc.totalDeedsLabel != nil)
        XCTAssert(vc.totalDeedsLabel.text != nil)

        ddvc.textView.text = "A"
        vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))

        XCTAssertEqual(vc.totalDeedsLabel.text, String(1))
    }
    
    func testDeedsSortedByDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        let day1 = formatter.date(from: "3/10/2020")
        let day2 = formatter.date(from: "3/11/2020")

        // All have the same date
        let deed1 = Deed(context: testContext)
        deed1.title = "A"
        deed1.date = day1

        let deed2 = Deed(context: testContext)
        deed2.title = "B"
        deed2.date = day1

        let deed3 = Deed(context: testContext)
        deed3.title = "C"
        deed3.date = day2

        vc.deeds = [deed1, deed2, deed3]

        sdvc.pickerDidSelectRow(selectedRowValue: "Day") // Should call changeDateFormatter func in ViewController]
        vc.done(segue: UIStoryboardSegue(identifier: "doneSortingSegue", source: sdvc, destination: vc)) // Calls updateSections

        XCTAssert((vc.sections as Any) is [DaySection])

        XCTAssertFalse(vc.sections.count == 0)
        XCTAssertTrue(vc.sections.count == 2)
        XCTAssertFalse(vc.sections.count == 1)
    }

    func testDeedsSortedByWeek() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        let week1 = formatter.date(from: "3/8/2020")
        let week2 = formatter.date(from: "3/15/2020")

        let deed1 = Deed(context: testContext)
        deed1.title = "A"
        deed1.date = week1

        let deed2 = Deed(context: testContext)
        deed2.title = "B"
        deed2.date = week1


        let deed3 = Deed(context: testContext)
        deed3.title = "C"
        deed3.date = week2

        vc.deeds = [deed1, deed2, deed3]

        sdvc.pickerDidSelectRow(selectedRowValue: "Week")
        vc.done(segue: UIStoryboardSegue(identifier: "doneSortingSegue", source: sdvc, destination: vc))

        XCTAssert((vc.sections as Any) is [WeekSection])

        XCTAssertFalse(vc.sections.count == 0)
        XCTAssertTrue(vc.sections.count == 2)
        XCTAssertFalse(vc.sections.count == 1)
    }

    func testDeedsSortedByMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        let month1 = formatter.date(from: "3/10/2020")
        let month2 = formatter.date(from: "4/10/2020")

        // All have the same date
        let deed1 = Deed(context: testContext)
        deed1.title = "A"
        deed1.date = month1

        let deed2 = Deed(context: testContext)
        deed2.title = "B"
        deed2.date = month1

        let deed3 = Deed(context: testContext)
        deed3.title = "C"
        deed3.date = month2

        vc.deeds = [deed1, deed2, deed3]

        sdvc.pickerDidSelectRow(selectedRowValue: "Month") // Should call changeDateFormatter func in ViewController]
        vc.done(segue: UIStoryboardSegue(identifier: "doneSortingSegue", source: sdvc, destination: vc)) // Calls updateSections

        XCTAssert((vc.sections as Any) is [MonthSection])

        XCTAssertFalse(vc.sections.count == 0)
        XCTAssertTrue(vc.sections.count == 2)
        XCTAssertFalse(vc.sections.count == 1)
    }

    func testDeedsSortedByYear() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        let year1 = formatter.date(from: "3/8/2020")
        let year2 = formatter.date(from: "3/8/2021")

        // All have the same date
        let deed1 = Deed(context: testContext)
        deed1.title = "A"
        deed1.date = year1

        let deed2 = Deed(context: testContext)
        deed2.title = "B"
        deed2.date = year1


        let deed3 = Deed(context: testContext)
        deed3.title = "C"
        deed3.date = year2

        vc.deeds = [deed1, deed2, deed3]

        sdvc.pickerDidSelectRow(selectedRowValue: "Year") // Should call changeDateFormatter func in ViewController]
        vc.done(segue: UIStoryboardSegue(identifier: "doneSortingSegue", source: sdvc, destination: vc)) // Calls updateSections

        XCTAssert((vc.sections as Any) is [YearSection])

        XCTAssertFalse(vc.sections.count == 0)
        XCTAssertTrue(vc.sections.count == 2)
        XCTAssertFalse(vc.sections.count == 1)
    }
    
//    func testIfDeedsDisplayInTableView() {
//        let calendar = Calendar.current
//
//        let a = Deed(context: testContext)
//        a.title = "A"
//        a.date = Date()
//
//        let b = Deed(context: testContext)
//        b.title = "B"
//        b.date = calendar.date(byAdding: .day, value: 1, to: a.date!)
//
//        let c = Deed(context: testContext)
//        c.title = "C"
//        c.date = calendar.date(byAdding: .day, value: 1, to: b.date!)
//
//        addDeeds(fromArray: [a, b, c])
//        vc.updateSections()
//
//        if !vc.deeds.isEmpty {
//            XCTAssertTrue(vc.tableView.numberOfSections > 0)
//        }
//
//        for (sectionIndex, section) in vc.sections.enumerated() {
//            print(sectionIndex)
//            for (deedIndex, deed) in section.deeds.enumerated() {
//                print(deedIndex)
//                let indexPath = IndexPath(row: deedIndex, section: sectionIndex)
//                print(indexPath)
//                XCTAssertTrue((vc.tableView.cellForRow(at: indexPath)?.textLabel?.text == deed.description))
//            }
//        }
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension NSManagedObjectContext {
    
    class func contextForTests() -> NSManagedObjectContext {
        // Get the model
        let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
        
        // Create and configure the coordinator
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Setup the context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
}
