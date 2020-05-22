//
//  GlobalViewControllerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 5/22/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest

class GlobalViewControllerTests: XCTestCase {
    var gvc: GlobalViewController!
    
    override func setUp() {
        let bundle = Bundle(for: self.classForCoder)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        
        self.gvc = storyboard.instantiateViewController(identifier: "GlobalViewController") as GlobalViewController
        
        gvc.loadViewIfNeeded()
    }
    
    func testNumbersFormatProperly() {
        XCTAssert(gvc.formatPoints(num: 123) == "123")
        
        XCTAssert(gvc.formatPoints(num: 1000) == "1k")
        XCTAssert(gvc.formatPoints(num: 6789) == "6.78k")
        XCTAssert(gvc.formatPoints(num: 9999) == "9.99k")
        
        XCTAssert(gvc.formatPoints(num: 1000000) == "1M")
        XCTAssert(gvc.formatPoints(num: 1100000) == "1.1M")
        XCTAssert(gvc.formatPoints(num: 1120000) == "1.12M")
        XCTAssert(gvc.formatPoints(num: 1239999) == "1.23M")
        XCTAssert(gvc.formatPoints(num: 1240000) == "1.24M")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
