//
//  ChallengesViewControllerTableViewDataSource.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/13/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData
class ChallengesViewControllerTableViewDataSource: NSObject, UITableViewDataSource {
    var achievements = [Achievement]()
    var view: UIView
    var isShowingTutorial: Bool = false
    var cdm = CoreDataManager()
       
    init(withView view: UIView) {
        self.view = view
        super.init()
           
        loadAchievements()
    }
    
    func loadAchievements() {
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        
        achievements = cdm.fetchAchievements(with: request)

        // If no achievements have been saved before
        if (achievements.count == 0) {
            createAchievements()
        }
    }
    
    func createAchievements() {
        addToAchievementsArray(fromDictionary: DeedAchievements.achievements, withIdentifier: DeedAchievements.identifier)
        addToAchievementsArray(fromDictionary: StreakAchievements.achievements, withIdentifier: StreakAchievements.identifier)
    }
    
    func addToAchievementsArray(fromDictionary titlesAndNumbers: [Dictionary<String, Int>], withIdentifier identifier: String) {
        for titleAndNumberDictionary in titlesAndNumbers {
            for (key, value) in titleAndNumberDictionary {
                let newAchievement = cdm.insertAchievement(title: key, identifier: identifier, goalNumber: Int32(value), isDone: false)
                
                achievements.append(newAchievement!)
            }
        }
    }
    
    // MARK: - TableView datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
        
        let achievement = achievements[indexPath.row]
        
        CellCustomizer.customizeChallengeCell(cell: cell, withAchievement: achievement, view: view)
        
        if isShowingTutorial {
            cell.isHidden = true
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Achievements"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isShowingTutorial ? 0 : 1
    }
    
}
