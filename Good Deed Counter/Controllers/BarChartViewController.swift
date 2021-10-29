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
    
    // Label to display if no deeds have been done in the past month.
    @IBOutlet weak var noDeedsDoneLabel: UILabel!
    
    // Create barChartView
    lazy var barChartView: BarChartView = {
       let barChartView = BarChartView()
       barChartView.frame = view.frame
       
       return barChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDeedsDoneLabel.sizeToFit()
        
        // If in Dark Mode, set label text to white, otherwise, set it to black.
        noDeedsDoneLabel.textColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black

        // Set deedsDone var
        deedsDone = getDeedsDoneInPastMonth()
        
        // If at least one deed has been done in the past month, remove the noDeedsDoneLabel from the screen. Otherwise, keep it displayed and return; don't do anything further.
        if deedsDone.count > 0 {
            noDeedsDoneLabel.removeFromSuperview()
        } else {
            return
        }
        
        // Format dates according to DaySection format since all deeds displayed in the bar chart graph will be shown by day.
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = DaySection.dateFormat
            
        // Group deedsDone by day.
        var sections = DaySection.group(deeds: deedsDone)
        sections.sort { (lhs, rhs) in lhs.date > rhs.date }
         
        // For each DaySection (containing deeds done that day), create a bar entry showing the number of deeds done that day and the date of that day.
        for section in sections {
            let newBarEntry = BarEntry(count: section.deeds.count, title: dateFormatter.string(from: section.date))
            barChartView.dataEntries.append(newBarEntry)
        }
    
        // Show barChartView.
        view.addSubview(barChartView)
    }
    
    // Get the day a deed was done by extracting .day from its dateComponents.
    private func dayOfDeed(fromDate: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: fromDate)
        return calendar.date(from: components)!
    }
    
    func getDeedsDoneInPastMonth() -> [Deed] {
        // Create fetch request to get Deed entities from CoreData.
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()

        // Sort deeds in reverse-chrononlogical order: Most recent deeds should appear first; deeds done longer ago should appear last.
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        // Make sure calendar is set to user's local timeZone before extracting data of deeds done per day.
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get deeds from one month ago to the very end of today / start of tomorrow.
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: dateHandler.currentDate() as Date))
        let oneMonthEarlier = calendar.date(byAdding: .month, value: -1, to: tomorrow!)

        // Set request's predicate and fetch all the deeds done in the past month.
        setRequestPredicatesBetween(dateFrom: oneMonthEarlier!, dateTo: tomorrow!, forRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        return cdm.fetchDeeds(with: request)
    }
    
    // Set request's predicate to deeds done in the past month.
    func setRequestPredicatesBetween(dateFrom: Date, dateTo: Date, forRequest request: NSFetchRequest<NSFetchRequestResult>) {
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
    }

}
