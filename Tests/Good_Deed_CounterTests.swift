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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()

        self.vc = ViewController()
        vc.loadView()

        sdvc = SortDeedsViewController()
        sdvc.loadView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
        vc.splitSections()
                        
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
        vc.splitSections()

        print(vc.sections.count)

        XCTAssert((vc.sections as Any) is [MonthSection])

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
