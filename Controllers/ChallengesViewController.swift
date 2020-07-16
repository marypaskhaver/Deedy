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
    @IBOutlet weak var dailyGoalProgressView: MyProgressView!
    
    @IBOutlet weak var dailyGoalStreakLabel: UILabel!
    @IBOutlet weak var labelSayingStreak: UILabel!
    @IBOutlet weak var labelSayingDays: UILabel!
    
    @IBOutlet weak var topView: TopView!
    @IBOutlet var backgroundView: BackgroundView!
    
    @IBOutlet weak var scrollView: TutorialScrollView!
    @IBOutlet weak var tutorialXButton: UIButton!
    @IBOutlet weak var pageControl: MyPageControl!
    
    var cdm = CoreDataManager()
    lazy var dailyChallenge = DailyChallenge(context: cdm.backgroundContext)
    lazy var streak = Streak(context: cdm.backgroundContext)
    
    var totalDeedsDone: Int = 0
    
    var dataSource: ChallengesViewControllerTableViewDataSource!

    let headerFont = UIFont.systemFont(ofSize: 22)
    
    var calendar = Calendar.current

    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyChallenge.dailyGoal = Int32(stepper.value)
        dailyChallenge.date = Date()
        cdm.save()
        
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        
        revealDailyGoalRelatedItemsIfNeeded()

        saveGoalsAndAchievements()
        
        dailyGoalProgressView.updateProgress()
    }
    
    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        hideTutorialItems(bool: true)
        
        tableView.reloadData()
        defaults.set(true, forKey: "ChallengesViewControllerTutorialShown")

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
        
        dailyGoalProgressView.updateProgress()

        hideTutorialItems(bool: true)
        cdm.save()
    }
    
    func showTutorial() {
        hideTutorialItems(bool: false)
        stepper.isEnabled = false
        
        let pages = scrollView.createPages(forViewController: self)
        scrollView.setupSlideScrollView(withPages: pages)
        view.bringSubviewToFront(scrollView)
        
        pageControl.setUp(withScrollView: scrollView, inViewController: self)
        view.bringSubviewToFront(pageControl)
        
        tutorialXButton.frame = CGRect(x: scrollView.frame.width - 20, y: scrollView.frame.origin.y + 10, width: 30, height: 30)
        view.bringSubviewToFront(tutorialXButton)
        
        tableView.reloadData()
    }
    
    func hideTutorialItems(bool: Bool) {
        scrollView.isHidden = bool
        pageControl.isHidden = bool
        tutorialXButton.isHidden = bool
        dataSource.isShowingTutorial = !bool
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dailyGoalProgressView.updateProgress() // needed?

        setTotalDeedsDone()
        
        backgroundView.changeBackgroundColor()
        
        if defaults.object(forKey: "ChallengesViewControllerTutorialShown") == nil {
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
        
        // Reloads achievements with updated text
        tableView.reloadData()
    }
    
    // MARK: - Updating Daily Streak
    func loadStreak() {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let fetchedRequest = cdm.fetchStreaks(with: request)
        
        // No previous streaks have ever been saved
        if (fetchedRequest.count == 0) {
            streak = cdm.insertStreak(daysKept: 0, wasUpdatedToday: false, date: Date())!
        } else {
            streak.daysKept = fetchedRequest[0].daysKept
            streak.date = fetchedRequest[0].date
        }
        
        if streak.date == nil {
            streak.date = Date()
        }
        
        // Set wasUpdatedToday to false if the streak's previous date was before today
        if calendar.isDateInToday(streak.date!) {
            streak.wasUpdatedToday = true
        } else {
            streak.wasUpdatedToday = false
        }
        
        streak.date = Date()

        dailyGoalStreakLabel.text = String(streak.daysKept)
    }
    
    func updateStreak() {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Include deeds only done before today
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)

        setRequestPredicatesBetween(dateFrom: yesterday!, dateTo: today, forRequest: request as! NSFetchRequest<NSFetchRequestResult>)
         
        let arrayOfDeedsDoneYesterday = cdm.fetchDeeds(with: request)
        
        // Check if deed was done yesterday-- if it was and the daily challenge was > 0: add to streak else: set streak to zero
        if (arrayOfDeedsDoneYesterday.count < dailyChallenge.dailyGoal || dailyChallenge.dailyGoal == 0) {
            streak.daysKept = 0
        } else {
            streak.daysKept += 1
        }
        
        streak.date = Date()
        dailyGoalStreakLabel.text = String(streak.daysKept)
        streak.wasUpdatedToday = true
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
        
        dailyGoalProgressView.updateProgress()
    }

    func hideDailyGoalRelatedItems(bool: Bool) {
        dailyGoalProgressView.isHidden = bool
        dailyGoalStreakLabel.isHidden = bool
        labelSayingStreak.isHidden = bool
        labelSayingDays.isHidden = bool
    }
    
    // MARK: - Model Manipulation Methods
    func saveGoalsAndAchievements() {
        if dailyChallenge.date == nil {
            dailyChallenge.date = Date()
        }

        if streak.date == nil {
            streak.date = Date()
        }

        cdm.save()
    }
    
    func loadDailyGoalValue() {
        let request: NSFetchRequest<DailyChallenge> = DailyChallenge.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let fetchedRequest = cdm.fetchDailyChallenges(with: request)
            
        if fetchedRequest.count == 0 {
            dailyChallenge = cdm.insertDailyChallenge(dailyGoal: 0, date: Date())!
        } else {
            dailyChallenge.dailyGoal = fetchedRequest[0].dailyGoal
        }

        dailyChallenge.date = Date()
        
        stepper.value = Double(dailyChallenge.dailyGoal)
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        revealDailyGoalRelatedItemsIfNeeded()
    }
    
    func setRequestPredicatesBetween(dateFrom: Date, dateTo: Date, forRequest request: NSFetchRequest<NSFetchRequestResult>) {
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
    }
    
}
