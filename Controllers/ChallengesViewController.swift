//
//  ChallengesViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var dailyGoalStepperLabel: UILabel!
    @IBOutlet weak var dailyGoalProgressView: UIProgressView!
    @IBOutlet weak var dailyGoalStreakLabel: UILabel!
    @IBOutlet weak var labelSayingStreak: UILabel!
    
    var dailyGoal = 0

    
    // To do: create a Challenge item and make it work like a Deed. Use CoreData to save its completeness? Good luck!
    // Make user able to set daily challenge
    @IBAction func stepperValueChanged(_ sender: Any) {
        dailyGoal = Int(stepper.value)
        dailyGoalStepperLabel.text = String(dailyGoal)
        
        if (dailyGoal > 0) {
            revealDailyGoalRelatedItems(bool: false)
            tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        } else { // If daily goals are set to 0, remove daily goal-related items from screen
            revealDailyGoalRelatedItems(bool: true)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        // Save dailyGoal # in CoreData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperValueChanged(UIStepper())

        // Do any additional setup after loading the view.
    }
    
    func revealDailyGoalRelatedItems(bool: Bool) {
        dailyGoalProgressView.isHidden = bool
        dailyGoalStreakLabel.isHidden = bool
        labelSayingStreak.isHidden = bool
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


