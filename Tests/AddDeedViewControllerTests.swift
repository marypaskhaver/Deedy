//
//  AddDeedViewControllerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/16/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest

@testable import Deedy

class AddDeedViewControllerTests: XCTestCase {
    var advc: AddDeedViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        advc = storyboard.instantiateViewController(identifier: "AddDeedViewController") as? AddDeedViewController
        advc.loadViewIfNeeded()
    }

    override func tearDown() {
        advc = nil
    }
    
    func testInvalidInputWarningLabelHidesWhenViewIsLoaded() {
        XCTAssertTrue(advc.invalidInputWarningLabel.isHidden)
    }

    func testInvalidInputWarningLabelShows() {
        advc.textView.text = "   \n "
        XCTAssertFalse(advc.shouldPerformSegue(withIdentifier: "doneAddingSegue", sender: UIViewController()))
        XCTAssertFalse(advc.invalidInputWarningLabel.isHidden)
    }

}
