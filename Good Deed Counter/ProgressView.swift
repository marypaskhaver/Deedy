//
//  ProgressView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

// Used to display daily deeds done in ChallengesViewController.
class ProgressView: UIProgressView {
    // Create properties
    var cdm: CoreDataManager = CoreDataManager()
    var calendar = Calendar.current
    var dateHandler = DateHandler()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set timeZone to user's local timeZone.
        calendar.timeZone = NSTimeZone.local
        
        // Scale it to nice size on the screen.
        self.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        
        updateProgress()
    }
    
    func updateProgress() {
        // Gets user's most recent daily goal (Int); the number of deeds they wished to do daily.
        let dailyGoal = cdm.fetchLatestDailyChallengeDailyGoal()

        // If dailyGoal exists / was set, set update view w/ user's progress at achieving said goal today.
        if (dailyGoal > 0) {
            let progress = Float(getCountOfDeedsDoneToday()) / Float(dailyGoal)
            self.setProgress(progress, animated: true)
        }
    }
    
    func getCountOfDeedsDoneToday() -> Int {
        // Fetch request for all deeds that have been completed
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: dateHandler.currentDate() as Date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
       
        // Update request with predicates so only deeds from dateFrom to dateTo (the current day) are fetched from CoreData.
        setRequestPredicatesBetween(dateFrom: dateFrom, dateTo: dateTo!, forRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        // Return the number of deeds the user completed between dateFrom and dateTo (the current day).
        return cdm.fetchDeeds(with: request).count
    }
    
    // Sets predicates on request to limit fetching deeds that are between dateFrom and dateTo Date params.
    func setRequestPredicatesBetween(dateFrom: Date, dateTo: Date, forRequest request: NSFetchRequest<NSFetchRequestResult>) {
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
    }

}
