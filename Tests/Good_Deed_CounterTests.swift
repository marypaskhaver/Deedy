//
//  Good_Deed_CounterTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest

@testable import Good_Deed_Counter

class Good_Deed_CounterTests: XCTestCase {
    var vc: ViewController!
    var sdvc: SortDeedsViewController!
    var ddvc: DeedDetailViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let bundle = Bundle(for: self.classForCoder)

        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        self.vc = storyboard.instantiateViewController(identifier: "ViewController") as ViewController
        self.sdvc = storyboard.instantiateViewController(identifier: "SortDeedsViewController") as SortDeedsViewController
        self.ddvc = storyboard.instantiateViewController(identifier: "DeedDetailViewController") as DeedDetailViewController
        
        vc.loadViewIfNeeded()
        sdvc.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingDeed() {
        let deedCountBeforeAdding = vc.deeds.count
        
        ddvc.deed = Deed(withDesc: "A")
        vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))
        
        XCTAssertEqual(deedCountBeforeAdding + 1, vc.deeds.count)
    }
    
    func testDeletingDeed() {
        // Add deed
        let deedsArr = [Deed(withDesc: "A"), Deed(withDesc: "B")]
        
        for deed in deedsArr {
            ddvc.deed = deed
            vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))
        }
        
        XCTAssertEqual(vc.sections.count, 1)
        XCTAssertEqual(vc.deeds.count, 2)
        
        let indexPath = IndexPath(row: 0, section: 0)

        vc.tableView(vc.tableView, commit: .delete, forRowAt: indexPath)

        XCTAssertEqual(vc.deeds.count, 1)
    }
    
    func testSectionDeedsEqualToVCDeeds() {
        var sumDeeds = 0
        
        for section in vc.sections {
            sumDeeds += section.deeds.count
        }

        XCTAssertEqual(vc.deeds.count, sumDeeds)
    }
    
    func testDeedLabelUpdates() {
        XCTAssert(vc.totalDeedsLabel != nil)
        XCTAssert(vc.totalDeedsLabel.text != nil)
        
        ddvc.deed = Deed(withDesc: "A")
        vc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: ddvc, destination: vc))
        
        XCTAssertEqual(vc.totalDeedsLabel.text, String(1))
    }
    
    func testDeedsSortedByDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let day1 = formatter.date(from: "3/10/2020")
        let day2 = formatter.date(from: "3/11/2020")
        
        // All have the same date
        vc.deeds = [Deed(withDesc: "A"), Deed(withDesc: "B"), Deed(withDesc: "C")]
        
        vc.deeds[0].date = day1! // Bad practice, using for the moment
        vc.deeds[1].date = day1!
        vc.deeds[2].date = day2!
        
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
        
        // All have the same date
        vc.deeds = [Deed(withDesc: "A"), Deed(withDesc: "B"), Deed(withDesc: "C")]
        
        vc.deeds[0].date = week1! // Bad practice, using for the moment
        vc.deeds[1].date = week1!
        vc.deeds[2].date = week2!
        
        sdvc.pickerDidSelectRow(selectedRowValue: "Day") // Should call changeDateFormatter func in ViewController]
        vc.done(segue: UIStoryboardSegue(identifier: "doneSortingSegue", source: sdvc, destination: vc)) // Calls updateSections
                        
        XCTAssert((vc.sections as Any) is [DaySection])
        
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
        vc.deeds = [Deed(withDesc: "A"), Deed(withDesc: "B"), Deed(withDesc: "C")]

        vc.deeds[0].date = month1! // Bad practice, using for the moment
        vc.deeds[1].date = month1!
        vc.deeds[2].date = month2!

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
        vc.deeds = [Deed(withDesc: "A"), Deed(withDesc: "B"), Deed(withDesc: "C")]
        
        vc.deeds[0].date = year1! // Bad practice, using for the moment
        vc.deeds[1].date = year1!
        vc.deeds[2].date = year2!
        
        sdvc.pickerDidSelectRow(selectedRowValue: "Day") // Should call changeDateFormatter func in ViewController]
        vc.done(segue: UIStoryboardSegue(identifier: "doneSortingSegue", source: sdvc, destination: vc)) // Calls updateSections
                        
        XCTAssert((vc.sections as Any) is [DaySection])
        
        XCTAssertFalse(vc.sections.count == 0)
        XCTAssertTrue(vc.sections.count == 2)
        XCTAssertFalse(vc.sections.count == 1)
    }
    
    func testIfDeedsDisplayInTableView() {
        if !vc.deeds.isEmpty {
            XCTAssertTrue(vc.tableView.numberOfSections > 0)
        }
        
        for section in vc.sections {
            for (index, deed) in section.deeds.enumerated() {
                XCTAssertTrue((vc.tableView.cellForRow(at: [index])?.textLabel?.text == deed.description))
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
