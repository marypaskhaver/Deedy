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
        XCTAssert(gvc.formatPoints(num: 123) == ["123", ""])
        
        XCTAssert(gvc.formatPoints(num: 1000) == ["1", "thousand"])
        XCTAssert(gvc.formatPoints(num: 6789) == ["6.78", "thousand"])
        XCTAssert(gvc.formatPoints(num: 9999) == ["9.99", "thousand"])
        
        XCTAssert(gvc.formatPoints(num: 1000000) == ["1", "million"])
        XCTAssert(gvc.formatPoints(num: 1100000) == ["1.1", "million"])
        XCTAssert(gvc.formatPoints(num: 1120000) == ["1.12", "million"])
        XCTAssert(gvc.formatPoints(num: 1239999) == ["1.23", "million"])
        XCTAssert(gvc.formatPoints(num: 1240000) == ["1.24", "million"])
        
        XCTAssert(gvc.formatPoints(num: 1000000000) == ["1", "billion"])
        XCTAssert(gvc.formatPoints(num: 1239000999) == ["1.23", "billion"])
        XCTAssert(gvc.formatPoints(num: 1240000000) == ["1.24", "billion"])
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
