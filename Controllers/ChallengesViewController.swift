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
    @IBOutlet weak var dailyGoalProgressView: ProgressView!
    
    @IBOutlet weak var dailyGoalStreakLabel: UILabel!
    
    @IBOutlet weak var topView: TopView!
    @IBOutlet var backgroundView: BackgroundView!
    
    @IBOutlet weak var scrollView: TutorialScrollView!
    @IBOutlet weak var tutorialXButton: TutorialXButton!
    @IBOutlet weak var pageControl: TutorialPageControl!
    
    var cdm = CoreDataManager()
    lazy var dailyChallenge = DailyChallenge(context: cdm.backgroundContext)
    lazy var streak = Streak(context: cdm.backgroundContext)
    
    var totalDeedsDone: Int = 0
    
    var dataSource: ChallengesViewControllerTableViewDataSource!

    let headerFont = UIFont.systemFont(ofSize: 22)
    
    var calendar = Calendar.current
    var dateHandler = DateHandler()

    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyChallenge.dailyGoal = Int32(stepper.value)
        dailyChallenge.date = dateHandler.currentDate() as Date?
        cdm.save()
        
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        
        revealDailyGoalRelatedItemsIfNeeded()
        
        dailyGoalProgressView.updateProgress()
    }
    
    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        hideTutorialItems(bool: true)
        
        tableView.reloadData()
        defaults.set(true, forKey: UserDefaultsKeys.challengesViewControllerTutorialShown)

        stepper.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.timeZone = NSTimeZone.local
        
        // Do any additional setup after loading the view.
        TableViewModification.setRowAndEstimatedRowHeightsToAutomaticDimension(forTableView: tableView)
                
        dataSource = ChallengesViewControllerTableViewDataSource(withView: self.view)
        tableView.dataSource = dataSource

        setTotalDeedsDone()
        
        loadDailyGoalValue()
        
        // Load up previous streak data for use in updateStreak method
        loadStreak()
        
        // Update streak-- inc. or dec. count.
        if totalDeedsDone > 0 && !streak.wasUpdatedToday {
            updateStreak()
        }
        
        tableView.reloadData()
        
        dailyGoalProgressView.updateProgress()

        hideTutorialItems(bool: true)
        cdm.save()
    }
    
    func showTutorial() {
        hideTutorialItems(bool: false)
        stepper.isEnabled = false
        
        TutorialSetterUpper.setUp(withViewController: self)
        
        tableView.reloadData()
    }
    
    func hideTutorialItems(bool: Bool) {
        scrollView.isHidden = bool
        pageControl.isHidden = bool
        tutorialXButton.isHidden = bool
        dataSource.isShowingTutorial = !bool
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dailyGoalProgressView.updateProgress()

        setTotalDeedsDone()
        tableView.reloadData()
        
        backgroundView.changeBackgroundColor()
        
        if defaults.object(forKey: UserDefaultsKeys.challengesViewControllerTutorialShown) == nil {
            showTutorial()
        }
        
        BarStyleSetter.setBarStyle(forViewController: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        topView.changeBackgroundColor()
        tableView.reloadData()
    }
    
    func setTotalDeedsDone() {
        self.totalDeedsDone = cdm.fetchDeeds().count
    }
    
    // MARK: - Updating Daily Streak
    func loadStreak() {
        let latestStreak: Streak = cdm.fetchLatestStreak()
        streak.daysKept = latestStreak.daysKept
        streak.date = latestStreak.date
        streak.wasUpdatedToday = latestStreak.wasUpdatedToday

        // Set wasUpdatedToday to true if the streak's date is today so it doesn't update multiple times.
        streak.wasUpdatedToday = calendar.isDateInToday(streak.date!) ? true : false
        streak.date = dateHandler.currentDate() as Date

        dailyGoalStreakLabel.text = streak.daysKept == 1 ? "Streak kept for:\t\(streak.daysKept) day" : "Streak kept for:\t\(streak.daysKept) days"
    }
    
    func updateStreak() {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Get deeds between the beginning of yesterday to the very start of today
        let today = calendar.startOfDay(for: dateHandler.currentDate() as Date)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)

        setRequestPredicatesBetween(dateFrom: yesterday!, dateTo: today, forRequest: request as! NSFetchRequest<NSFetchRequestResult>)
         
        let arrayOfDeedsDoneYesterday = cdm.fetchDeeds(with: request)
        
        // Check if deed was done yesterday-- if it was and the daily challenge was > 0: add to streak else: set streak to zero
        if (arrayOfDeedsDoneYesterday.count < dailyChallenge.dailyGoal || dailyChallenge.dailyGoal == 0) {
            streak.daysKept = 0
        } else {
            streak.daysKept += 1
            streak = cdm.insertStreak(daysKept: streak.daysKept, wasUpdatedToday: streak.wasUpdatedToday, date: streak.date ?? dateHandler.currentDate() as Date)!
        }
        
        streak.wasUpdatedToday = true
        dailyGoalStreakLabel.text = streak.daysKept == 1 ? "Streak kept for:\t\(streak.daysKept) day" : "Streak kept for:\t\(streak.daysKept) days"
        cdm.save()
    }
    
    // MARK: - Manipulating Views and Daily Challenge Items
    func revealDailyGoalRelatedItemsIfNeeded() {
        let originalTableViewYPos: CGFloat = 0.263 * self.view.frame.height
        let amountToMoveTableViewDownBy = -0.122 * self.view.frame.height
        let originalTopViewHeight: CGFloat = self.view.frame.height / 4.0

        // TableViewModification class
        if (dailyChallenge.dailyGoal > 0) {
            hideDailyGoalRelatedItems(bool: false)
            
            tableView.frame = CGRect(x: 0, y: originalTableViewYPos + amountToMoveTableViewDownBy, width: tableView.frame.width, height: tableView.frame.height)
                        
            if tableViewTopConstraint.constant < 0 {
                tableViewTopConstraint.constant = 0
            }
            
            topView.setHeightInViewController(vc: self, toHeight: originalTopViewHeight)

        } else { // If daily goals are set to 0, remove daily goal-related items from screen
            hideDailyGoalRelatedItems(bool: true)
            
            topView.setHeightInViewController(vc: self, toHeight: originalTopViewHeight + amountToMoveTableViewDownBy)

            tableViewTopConstraint.constant = 0
            
            tableView.frame = CGRect(x: 0, y: originalTableViewYPos, width: CGFloat(tableView.frame.width), height: CGFloat(tableView.frame.height))
        }
        
    }

    func hideDailyGoalRelatedItems(bool: Bool) {
        dailyGoalProgressView.isHidden = bool
        dailyGoalStreakLabel.isHidden = bool
    }
    
    // MARK: - Model Manipulation Methods
    func loadDailyGoalValue() {
        dailyChallenge.dailyGoal = cdm.fetchLatestDailyChallengeDailyGoal()
        dailyChallenge.date = dateHandler.currentDate() as Date
        
        stepper.value = Double(dailyChallenge.dailyGoal)
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        revealDailyGoalRelatedItemsIfNeeded()
        dailyGoalProgressView.updateProgress()
    }
    
    func setRequestPredicatesBetween(dateFrom: Date, dateTo: Date, forRequest request: NSFetchRequest<NSFetchRequestResult>) {
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
    }
    
}
