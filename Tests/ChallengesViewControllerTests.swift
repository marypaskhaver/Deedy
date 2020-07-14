//
//  ChallengesViewControllerTests.swift
//  Good Deed CounterTests
//
//  Created by Mary Paskhaver on 7/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import XCTest
import CoreData

@testable import Good_Deed_Counter

class ChallengesViewControllerTests: XCTestCase {
    var ddvc: DisplayDeedsViewController!
    var cvc: ChallengesViewController!
    
    lazy var managedObjectModel: NSManagedObjectModel = MockDataModelObjects().managedObjectModel
    lazy var mockPersistentContainer: NSPersistentContainer = MockDataModelObjects().persistentContainer
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        ddvc = MockDataModelObjects().createDisplayDeedsViewController()
        
        cvc = storyboard.instantiateViewController(identifier: "ChallengesViewController") as? ChallengesViewController
        cvc.cdm = ddvc.dataSource.cdm
        cvc.loadViewIfNeeded()
        cvc.setTotalDeedsDone()
        cvc.dataSource.loadAchievements()
        cvc.dailyGoalProgressView.cdm = ddvc.dataSource.cdm
        
        initDeedStubs()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        ddvc.dataSource = nil
        ddvc = nil
        cvc.dataSource = nil
        cvc = nil
        flushDeedData()
    }
    
    // MARK: - Needed funcs
    func addDeed(withTitle title: String, date: Date) {
        let deed = ddvc.dataSource.cdm.insertDeed(title: title, date: date)
        ddvc.dataSource.deeds.append(deed!)
        ddvc.dataSource.saveDeeds()
        cvc.setTotalDeedsDone()
    }
    
    func initDeedStubs() {
        // Put fake items in the "database"
        addDeed(withTitle: "A", date: Date())
        addDeed(withTitle: "B", date: Date())
        addDeed(withTitle: "C", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
    }
    
    func flushDeedData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Deed")
        
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)

        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
        }
        
        try! mockPersistentContainer.viewContext.save()
    }
    
    func testDailyProgressViewDailyGoalValueSame() {
        XCTAssert(cvc.dailyChallenge.dailyGoal == cvc.dailyGoalProgressView.getDailyGoalValue())
    }
    
    func testDailyGoalProgressViewGetsDeedsDoneToday() {
        XCTAssert(cvc.dailyGoalProgressView.getCountOfDeedsDoneToday() == 2)
    }
    
    func testDailyProgressViewValueUpdates() {
        cvc.stepper.value = 3
        cvc.stepperValueChanged(UIStepper()) // progressView and dailyChallenge.dailyGoal updated

        let stepperVal = cvc.stepper.value
        let progressView = cvc.dailyGoalProgressView
                
        // Deeds done today will be equal to 2, was set in initDeedStubs
        XCTAssert(progressView?.progress == Float(2 / stepperVal))
    }
    
    func testAchievementsLoaded() {
        for (achievementIndex, achievement) in cvc.dataSource.achievements.enumerated() {
            let indexPath = IndexPath(row: achievementIndex, section: 0)
            let cell: ChallengeTableViewCell = cvc.tableView.cellForRow(at: indexPath) as! ChallengeTableViewCell
            
            XCTAssertTrue(cell.challengeDescriptionLabel.text == achievement.title)
        }
    }
    
    func testTotalDeedsDoneCorrect() {
        XCTAssert(ddvc.dataSource.deeds.count == cvc.totalDeedsDone)
    }

}
