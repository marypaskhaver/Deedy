//
//  EditDeedViewControllerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/16/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest

@testable import Deedy

class EditDeedViewControllerTests: XCTestCase {
    var edvc: EditDeedViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        edvc = storyboard.instantiateViewController(identifier: "EditDeedViewController") as? EditDeedViewController
        edvc.loadViewIfNeeded()
    }

    override func tearDown() {
        edvc = nil
    }
    
    func testInvalidInputWarningLabelHidesWhenViewIsLoaded() {
        XCTAssertTrue(edvc.invalidInputWarningLabel.isHidden)
    }

    func testInvalidInputWarningLabelShows() {
        edvc.textView.text = "   \n "
        edvc.doneButtonPressed(UIBarButtonItem())
        XCTAssertFalse(edvc.invalidInputWarningLabel.isHidden)
    }

}
