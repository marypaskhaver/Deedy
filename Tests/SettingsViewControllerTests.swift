//
//  SettingsViewControllerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/16/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest

@testable import Good_Deed_Counter

class SettingsViewControllerTests: XCTestCase {
    var svc: SettingsViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               
        svc = storyboard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
        svc.loadViewIfNeeded()
    }

    override func tearDown() {
        svc = nil
    }
    
    func testAppColorResetsWhenResetButtonPressed() {
        svc.redSlider.value = 1
        svc.greenSlider.value = 1
        svc.blueSlider.value = 1

        svc.resetButtonPressed(UIButton())
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        CustomColors.defaultBlue.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        XCTAssert(svc.redSlider.value == Float(r * 255))
        XCTAssert(svc.greenSlider.value == Float(g * 255))
        XCTAssert(svc.blueSlider.value == Float(b * 255))
    }
    
    func testShowingTutorialDisablesSlidersAndButtons() {
        for item in [svc.redSlider, svc.greenSlider, svc.blueSlider, svc.reviewTutorialButton, svc.resetButton] {
            XCTAssertTrue(item!.isEnabled)
        }

        svc.showTutorial()
        
        for item in [svc.redSlider, svc.greenSlider, svc.blueSlider, svc.reviewTutorialButton, svc.resetButton] {
            XCTAssertFalse(item!.isEnabled)
        }
    }

}
