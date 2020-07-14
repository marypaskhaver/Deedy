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
    var ddvc: DisplayDeedsViewController!
    var advc: AddDeedViewController!
    
    lazy var managedObjectModel: NSManagedObjectModel = MockDataModelObjects().managedObjectModel
    lazy var mockPersistentContainer: NSPersistentContainer = MockDataModelObjects().persistentContainer
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        ddvc = MockDataModelObjects().createDisplayDeedsViewController()
        
        advc = storyboard.instantiateViewController(identifier: "AddDeedViewController") as? AddDeedViewController
        advc.loadViewIfNeeded()

        initDeedStubs()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        ddvc.dataSource = nil
        ddvc = nil
        advc = nil
        flushDeedData()
    }
    
    // MARK: - Needed funcs
    func addDeed(withTitle title: String, date: Date) {
        let deed = ddvc.dataSource.cdm.insertDeed(title: title, date: date)
        ddvc.dataSource.deeds.append(deed!)
        // Split deeds into proper sections

        ddvc.updateSections()
    }
    
    func initDeedStubs() {
        // Put fake items in the "database"
        addDeed(withTitle: "A", date: Date())
        addDeed(withTitle: "B", date: Date())
        addDeed(withTitle: "C", date: Date())
        addDeed(withTitle: "D", date: Date())
        addDeed(withTitle: "E", date: Date())
        
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
    
    func numberOfItemsInPersistentStore(withEntityName name: String) -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
        let results = try! mockPersistentContainer.viewContext.fetch(request)
        return results.count
    }
    
    // MARK: - Tests for ViewController
    func testAddingDeed() {
        XCTAssertEqual(ddvc.dataSource.deeds.count, 5)
                
        advc.textView.text = "Hello"
        
        ddvc.done(segue: UIStoryboardSegue(identifier: "doneAddingSegue", source: advc, destination: ddvc))
        
        XCTAssertEqual(ddvc.dataSource.deeds.count, 6)
    }
    
    func testSectionDeedsEqualToVCDeeds() {
        let calendar = Calendar.current

        var sumDeeds = 0

        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        addDeed(withTitle: "B", date: tomorrow!)
        addDeed(withTitle: "C", date: tomorrow!)

        for section in ddvc.dataSource.sections {
            sumDeeds += section.deeds.count
        }

        XCTAssertEqual(ddvc.dataSource.deeds.count, sumDeeds)
    }


    func testDeedLabelUpdates() {
        XCTAssert(ddvc.totalDeedsLabel != nil)
        XCTAssert(ddvc.totalDeedsLabel.text != nil)
        
        XCTAssertEqual(ddvc.totalDeedsLabel.text, String(5))

        addDeed(withTitle: "A", date: Date())
        ddvc.updateSections()
        
        XCTAssertEqual(ddvc.totalDeedsLabel.text, String(6))
    }
    
    func testIfDeedsDisplayInTableView() {
        let calendar = Calendar.current

        let today = Date()
        addDeed(withTitle: "A", date: today)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        addDeed(withTitle: "B", date: tomorrow!)
        addDeed(withTitle: "C", date: tomorrow!)

        if !ddvc.dataSource.deeds.isEmpty {
            XCTAssertTrue(ddvc.dataSource.sections.count > 0)
        }
        
        ddvc.tableView.reloadData()

        for (sectionIndex, section) in ddvc.dataSource.sections.enumerated() {
            for (deedIndex, deed) in section.deeds.enumerated() {
                let indexPath = IndexPath(row: deedIndex, section: sectionIndex)
                let cell: DeedTableViewCell = ddvc.tableView.cellForRow(at: indexPath) as! DeedTableViewCell
                
                XCTAssertTrue(cell.deedDescriptionLabel.text == deed.title)
            }
        }
    }

}
