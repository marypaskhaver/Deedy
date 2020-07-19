//
//  BarChartViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class BarChartViewController: UIViewController {
    var deedsDone = [Deed]()
    var cdm: CoreDataManager = CoreDataManager()
    var dateHandler = DateHandler()
    
    @IBOutlet weak var noDeedsDoneLabel: UILabel!
    
    lazy var barChartView: BarChartView = {
       let barChartView = BarChartView()
       barChartView.frame = view.frame
       
       return barChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDeedsDoneLabel.sizeToFit()
        
        deedsDone = getDeedsDoneInPastMonth()
        
        if deedsDone.count > 0 {
            noDeedsDoneLabel.removeFromSuperview()
        } else {
            return
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = DaySection.dateFormat
            
        var sections = DaySection.group(deeds: deedsDone)
        sections.sort { (lhs, rhs) in lhs.date > rhs.date }
         
        for section in sections {
            let newBarEntry = BarEntry(count: section.deeds.count, title: dateFormatter.string(from: section.date))
            barChartView.dataEntries.append(newBarEntry)
        }
    
        view.addSubview(barChartView)
    }
    
    private func dayOfDeed(fromDate: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: fromDate)
        return calendar.date(from: components)!
    }
    
    func getDeedsDoneInPastMonth() -> [Deed] {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get deeds from one month ago to the very end of today/start of tomorrow
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: dateHandler.currentDate() as Date))
        let oneMonthEarlier = calendar.date(byAdding: .month, value: -1, to: tomorrow!)

        setRequestPredicatesBetween(dateFrom: oneMonthEarlier!, dateTo: tomorrow!, forRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        return cdm.fetchDeeds(with: request)
    }
    
    func setRequestPredicatesBetween(dateFrom: Date, dateTo: Date, forRequest request: NSFetchRequest<NSFetchRequestResult>) {
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
    }

}
