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
    var achievements = [Achievement]()
    
    var totalDeedsDone: Int = 0
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyChallenge.dailyGoal = Int32(Int(stepper.value))
        dailyChallenge.date = Date()
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        
        revealDailyGoalRelatedItemsIfNeeded()
        
        saveGoalsAndAchievements()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        setTotalDeedsDone()
        
        loadAchievements()

        dailyGoalProgressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)

        loadDailyGoalValue()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDeedsDoneToday()
        setProgressViewValue()
        
        setTotalDeedsDone()
    }
    
    func setTotalDeedsDone() {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        
        do {
            self.totalDeedsDone = try context.fetch(request).count
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Loading and Creating Achievements
    func loadAchievements() {
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "goalNumber", ascending: true)]
        
        do {
            achievements = try context.fetch(request)

            // If no achievements have been saved before
            if (achievements.count == 0) {
                createAchievements()
            }
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func createAchievements() {
        let titlesAndNumbers = [
            ["Complete 5 deeds", 5],
            ["Complete 10 deeds", 10],
            ["Complete 25 deeds", 25],
            ["Complete 50 deeds", 50],
            ["Complete 75 deeds", 75],
            ["Complete 100 deeds", 100],
            ["Complete 200 deeds", 200],
        ]
        
        for titleAndNumber in titlesAndNumbers {
            let newAchievement = Achievement(context: context)
            newAchievement.title = (titleAndNumber[0] as! String)
            newAchievement.goalNumber = Int32((titleAndNumber[1] as! Int))
            newAchievement.isDone = false
            achievements.append(newAchievement)
        }
    }
    
    // MARK: - Manipulating Progress Views and Daily Challenge Items
    
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
        
        setProgressViewValue()
    }
    
    func hideDailyGoalRelatedItems(bool: Bool) {
        dailyGoalProgressView.isHidden = bool
        dailyGoalStreakLabel.isHidden = bool
        labelSayingStreak.isHidden = bool
    }
    
    // MARK: - Model Manipulation Methods
    func saveGoalsAndAchievements() {
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
        header.textLabel?.font = UIFont.systemFont(ofSize: 22)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - TableView DataSource Methods
extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
    
        let achievement = achievements[indexPath.row]
                
        cell.challengeDescriptionLabel.text = achievement.title

        if (totalDeedsDone >= achievement.goalNumber) {
            cell.subtitleLabel.text = "\(achievement.goalNumber) / \(achievement.goalNumber)"
            cell.subtitleLabel.textColor = UIColor(red: 26 / 255.0, green: 145 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            achievement.isDone = true
        } else {
            cell.subtitleLabel.text = "\(totalDeedsDone) / \(achievements[indexPath.row].goalNumber)"
        }
    
                
        return cell
    }
    
}
