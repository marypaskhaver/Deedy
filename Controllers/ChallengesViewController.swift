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
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var dailyGoalStepperLabel: UILabel!
    @IBOutlet weak var dailyGoalProgressView: UIProgressView!
    
    @IBOutlet weak var dailyGoalStreakLabel: UILabel!
    @IBOutlet weak var labelSayingStreak: UILabel!
    @IBOutlet weak var labelSayingDays: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var dailyChallenge: DailyChallenge = DailyChallenge(context: context)
    var streak: Streak = Streak(context: context)
    var deedsDoneToday: Int = 0
    var achievements = [Achievement]()
    var totalDeedsDone: Int = 0
    
    let headerFont = UIFont.systemFont(ofSize: 22)

    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyChallenge.dailyGoal = Int32(stepper.value)
        dailyChallenge.date = Date()
        
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        
        revealDailyGoalRelatedItemsIfNeeded()
        
        saveGoalsAndAchievements()
    }
    
    @IBAction func scrollUpButtonPressed(_ sender: UIBarButtonItem) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        setTotalDeedsDone()
        
        loadAchievements()

        dailyGoalProgressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)

        loadDailyGoalValue()
        
        // Load up previous streak data for use in updateStreak method
        loadStreak()
        
        // Update streak-- inc. or dec. count.
        if totalDeedsDone > 0 && !streak.wasUpdatedToday {
            updateStreak()
        }

        topView.backgroundColor = UIColor.white
        
        if self.traitCollection.userInterfaceStyle == .dark {
            topView.backgroundColor = UIColor.black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCountOfDeedsDoneToday()

        setDailyGoalProgressViewValue()
        
        setTotalDeedsDone()
        
        if let navBarColor = defaults.color(forKey: "navBarColor") {
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            navBarColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

            if b > 0.75 {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
            } else {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
            }
        } else {
            let navBarColor = SettingsViewController.navBarColor
            
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            navBarColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

            if b > 0.75 {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
            } else {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
            }
        }
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
    
    // MARK: - Updating Daily Streak
    func loadStreak() {
        let request : NSFetchRequest<Streak> = Streak.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let fetchedRequest = try context.fetch(request)
                    
            streak.daysKept = fetchedRequest[0].daysKept
            streak.date = fetchedRequest[0].date
            
            if streak.date == nil {
                streak.date = Date()
            }
            
            // Set wasUpdatedToday to false if the streak's previous date was before today
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            if calendar.isDateInToday(streak.date!) {
                streak.wasUpdatedToday = true
            } else {
                streak.wasUpdatedToday = false
            }
            
            streak.date = Date()

            dailyGoalStreakLabel.text = String(streak.daysKept)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func updateStreak() {
        do {
            let request: NSFetchRequest<Deed> = Deed.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            // Include deeds only done before today
            let today = calendar.startOfDay(for: Date())
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)

             // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "date >= %@", yesterday! as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", today as NSDate)
            
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request.predicate = datePredicate
             
            let arrayOfDeedsDoneYesterday = try context.fetch(request)
          
            // Check if deed was done yesterday-- if it was: add to streak w/ if statement below, else: set streak to zero, then save everything
            if (arrayOfDeedsDoneYesterday.count == 0) {
                streak.daysKept = 0
                
                streak.date = Date()
                dailyGoalStreakLabel.text = String(streak.daysKept)
                
                return
            } else {
                if (arrayOfDeedsDoneYesterday.count >= dailyChallenge.dailyGoal) {
                    streak.daysKept += 1
                    
                    streak.date = Date()
                    dailyGoalStreakLabel.text = String(streak.daysKept)
                }
            }
            
            streak.wasUpdatedToday = true
                        
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    //MARK: - Loading and Creating Achievements
    func loadAchievements() {
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        
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
        let deedAchievements = [
            ["Complete 5 deeds", 5],
            ["Complete 10 deeds", 10],
            ["Complete 25 deeds", 25],
            ["Complete 50 deeds", 50],
            ["Complete 75 deeds", 75],
            ["Complete 100 deeds", 100],
            ["Complete 200 deeds", 200]
        ]
        
        let streakAchievements = [
            ["Hit your streak for 1 day", 1],
            ["Hit your streak for 5 days", 5],
            ["Hit your streak for 10 days", 10],
            ["Hit your streak for 15 days", 15],
            ["Hit your streak for 30 days", 30],
        ]
        
        addToAchievementsArray(fromArray: deedAchievements, withIdentifier: "deedAchievement")

        addToAchievementsArray(fromArray: streakAchievements, withIdentifier: "streakAchievement")
    }
    
    func addToAchievementsArray(fromArray titlesAndNumbers: [[Any]], withIdentifier identifier: String) {
        for titleAndNumber in titlesAndNumbers {
            let newAchievement = Achievement(context: context)
            
            newAchievement.title = (titleAndNumber[0] as! String)
            newAchievement.goalNumber = Int32((titleAndNumber[1] as! Int))
            newAchievement.isDone = false
            newAchievement.identifier = identifier
            
            achievements.append(newAchievement)
        }
    }
    
    // MARK: - Manipulating Progress Views and Daily Challenge Items
    
    func setDailyGoalProgressViewValue() {
        if (dailyChallenge.dailyGoal > 0) {
            let progress = Float(deedsDoneToday) / Float(dailyChallenge.dailyGoal)
            dailyGoalProgressView.setProgress(progress, animated: true)
        }
    }
    
    func setCountOfDeedsDoneToday() {
        do {
            let request: NSFetchRequest<Deed> = Deed.fetchRequest()
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local

            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: Date())
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
           
            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request.predicate = datePredicate
            
            deedsDoneToday = try context.fetch(request).count
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

    // Change tableView frame and animate?
    func revealDailyGoalRelatedItemsIfNeeded() {
        let originalTableViewYPos: CGFloat = 0.263 * self.view.frame.height
        let amountToMoveTableViewDownBy = -0.122 * self.view.frame.height
        let originalTopViewHeight: CGFloat = self.view.frame.height / 4.0
        
//        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (dailyChallenge.dailyGoal > 0) {
            hideDailyGoalRelatedItems(bool: false)
            
            tableView.frame = CGRect(x: 0, y: originalTableViewYPos + amountToMoveTableViewDownBy, width: tableView.frame.width, height: tableView.frame.height)
                        
            if tableViewTopConstraint.constant < 0 {
                tableViewTopConstraint.constant = 0
            }
            
            moveTopViewFrame(toHeight: originalTopViewHeight)
        } else { // If daily goals are set to 0, remove daily goal-related items from screen
            hideDailyGoalRelatedItems(bool: true)
            
            moveTopViewFrame(toHeight: originalTopViewHeight + amountToMoveTableViewDownBy)

            tableViewTopConstraint.constant = 0
            
            tableView.frame = CGRect(x: 0, y: originalTableViewYPos, width: CGFloat(tableView.frame.width), height: CGFloat(tableView.frame.height))
        }
        
        setDailyGoalProgressViewValue()
    }
    
    func moveTopViewFrame(toHeight height: CGFloat) {
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (navigationController?.navigationBar.frame.height) != nil {
            topView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: CGFloat(self.view.frame.width), height: height)
        }
    }
    
    func hideDailyGoalRelatedItems(bool: Bool) {
        dailyGoalProgressView.isHidden = bool
        dailyGoalStreakLabel.isHidden = bool
        labelSayingStreak.isHidden = bool
        labelSayingDays.isHidden = bool
    }
    
    // MARK: - Model Manipulation Methods
    func saveGoalsAndAchievements() {

        do {
            if dailyChallenge.date == nil {
                dailyChallenge.date = Date()
            }
            
            if streak.date == nil {
                streak.date = Date()
            }
            
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadDailyGoalValue() {
        let request : NSFetchRequest<DailyChallenge> = DailyChallenge.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let fetchedRequest = try context.fetch(request)
                    
            dailyChallenge.dailyGoal = fetchedRequest[0].dailyGoal
            dailyChallenge.date = Date()
                
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
        header.textLabel?.font = headerFont 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerFont.pointSize + 18
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

        UIView.animate(
            withDuration: 1,
            delay: 0.1 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }

}

// MARK: - TableView DataSource Methods
extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let whiteRoundedViewTag = 1
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
    
        let achievement = achievements[indexPath.row]
                
        cell.challengeDescriptionLabel.text = achievement.title
        
        if achievement.identifier == "deedAchievement" {
            if (totalDeedsDone >= achievement.goalNumber) {
                markAchievementDoneAndSetCellTextToProgress(forCell: cell, forAchievement: achievement)
            } else {
                cell.subtitleLabel.text = "\(totalDeedsDone) / \(achievements[indexPath.row].goalNumber)"
            }
            
        } else if achievement.identifier == "streakAchievement" {
            if (streak.daysKept >= achievement.goalNumber) {
                markAchievementDoneAndSetCellTextToProgress(forCell: cell, forAchievement: achievement)
            } else {
                cell.subtitleLabel.text = "\(streak.daysKept) / \(achievements[indexPath.row].goalNumber)"
            }
        }
        
        cell.subtitleLabel.sizeToFit()
                
        let whiteRoundedViewHeight = cell.challengeDescriptionLabel.frame.height + cell.subtitleLabel.frame.height
   
        let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: whiteRoundedViewHeight - 18))
        
        whiteRoundedView.tag = whiteRoundedViewTag
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView) 
                        
        return cell
    }
    
    func markAchievementDoneAndSetCellTextToProgress(forCell cell: ChallengeTableViewCell, forAchievement ach: Achievement) {
        cell.setSubtitleTextIfAchievementCompleted(to: "\(ach.goalNumber) / \(ach.goalNumber)")
        ach.isDone = true
    }
    
}
