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
        // Create fetch request for achievements. Sort by title in ascending order. Because each title differs only by the number it contains in the middle of its title String, this will essentially sort them in ascending numerical order. I could probably also have sorted by each Achievement's goalNumber... Dunno why I didn't do that.
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        
        // Set achievements array to hold fetched Achievement entities from CoreData.
        achievements = cdm.fetchAchievements(with: request)

        // If no achievements have been saved before, create Achievements and store them in CoreData and the self.achievements array.
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
                // Create new Achievement entity from each Achievement class in titlesAndNumbers and save that Achievement entity to CoreData.
                let newAchievement = cdm.insertAchievement(title: key, identifier: identifier, goalNumber: Int32(value), isDone: false)
                
                // Append Achievement objects to self.achievements property.
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
        
        // Get the achievement this cell represents.
        let achievement = achievements[indexPath.row]
        
        // Customize this cell's text based on the achievement it represents (ex: if achivement is done, make cell's subtitleText green instead of the usual black).
        CellCustomizer.customizeChallengeCell(cell: cell, withAchievement: achievement, view: view)
        
        // If tutorial is showing, hide cells.
        if isShowingTutorial {
            cell.isHidden = true
        }

        return cell
    }
    
    // The title of the 1 header above the tableView in ChallengesViewController.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Achievements"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
