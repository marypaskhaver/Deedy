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
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyChallenge.dailyGoal = Int32(Int(stepper.value))
        dailyChallenge.date = Date()
        dailyGoalStepperLabel.text = String(dailyChallenge.dailyGoal)
        
        revealDailyGoalRelatedItemsIfNeeded()
        
        // Save dailyGoal # in CoreData
        saveDailyGoalValue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDailyGoalValue()
        // Do any additional setup after loading the view.
    }
    
    func revealDailyGoalRelatedItemsIfNeeded() {
        if (dailyChallenge.dailyGoal > 0) {
            revealDailyGoalRelatedItems(bool: false)
            tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        } else { // If daily goals are set to 0, remove daily goal-related items from screen
            revealDailyGoalRelatedItems(bool: true)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func revealDailyGoalRelatedItems(bool: Bool) {
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

}

// MARK: - TableView DataSource Methods
extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return challenges.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
        
        return cell
    }
}


