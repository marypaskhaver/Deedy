//
//  ChallengesViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class ChallengesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var dailyGoalStepperLabel: UILabel!
    @IBOutlet weak var dailyGoalProgressView: UIProgressView!
    @IBOutlet weak var dailyGoalStreakLabel: UILabel!
    @IBOutlet weak var labelSayingStreak: UILabel!
    
    var dailyChallenge: DailyChallenge = DailyChallenge(context: context)
    var deedsDoneToday: Int = 0
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyChallenge.dailyGoal = Int32(Int(stepper.value))
        dailyChallenge.date = Date()
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        
        revealDailyGoalRelatedItemsIfNeeded()
        
        setProgressViewValue()
        saveDailyGoalValue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()

        dailyGoalProgressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        loadDailyGoalValue()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDeedsDoneToday()
        setProgressViewValue()
    }
    
    func setProgressViewValue() {
        if (dailyChallenge.dailyGoal != 0) {
            let progress = Float(deedsDoneToday) / Float(dailyChallenge.dailyGoal)
            dailyGoalProgressView.setProgress(progress, animated: true)
        }
    }
    
    func setDeedsDoneToday() {
        do {
            let request: NSFetchRequest<Deed> = Deed.fetchRequest()
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local

            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: Date())
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
           
            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", dateTo as! NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request.predicate = datePredicate
            
            deedsDoneToday = try context.fetch(request).count
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func revealDailyGoalRelatedItemsIfNeeded() {
        if (dailyChallenge.dailyGoal > 0) {
            hideDailyGoalRelatedItems(bool: false)
            tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        } else { // If daily goals are set to 0, remove daily goal-related items from screen
            hideDailyGoalRelatedItems(bool: true)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideDailyGoalRelatedItems(bool: Bool) {
        dailyGoalProgressView.isHidden = bool
        dailyGoalStreakLabel.isHidden = bool
        labelSayingStreak.isHidden = bool
    }
    
    // MARK: - Model Manipulation Methods
    func saveDailyGoalValue() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadDailyGoalValue() {
        let request : NSFetchRequest<DailyChallenge> = DailyChallenge.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(DailyChallenge.date), ascending: false)]

        do {
            let fetchedRequest = try context.fetch(request)
            
            dailyChallenge.dailyGoal = fetchedRequest[0].dailyGoal

            stepper.value = Double(dailyChallenge.dailyGoal)
            dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
            revealDailyGoalRelatedItemsIfNeeded()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
}


// MARK: - TableView Delegate Methods
extension ChallengesViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Achievements"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.center
    }

}

// MARK: - TableView DataSource Methods
extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return challenges.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
        
        cell.challengeDescriptionLabel.text = "Hello"
        
        return cell
    }
    
    
}


