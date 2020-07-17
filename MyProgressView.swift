//
//  MyProgressView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class MyProgressView: UIProgressView {
    var cdm: CoreDataManager = CoreDataManager()
    var calendar = Calendar.current
    var dateHandler = DateHandler()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendar.timeZone = NSTimeZone.local
        self.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        updateProgress()
    }
    
    func updateProgress() {
        let dailyGoal = getDailyGoalValue()

        if (dailyGoal > 0) {
            let progress = Float(getCountOfDeedsDoneToday()) / Float(dailyGoal)
            self.setProgress(progress, animated: true)
        }
    }
    
    func getDailyGoalValue() -> Int32 {
        return cdm.fetchDailyChallenges()
    }
    
    func getCountOfDeedsDoneToday() -> Int {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: dateHandler.currentDate() as Date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
       
        setRequestPredicatesBetween(dateFrom: dateFrom, dateTo: dateTo!, forRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            
        return cdm.fetchDeeds(with: request).count
    }
    
    func setRequestPredicatesBetween(dateFrom: Date, dateTo: Date, forRequest request: NSFetchRequest<NSFetchRequestResult>) {
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
    }

}
