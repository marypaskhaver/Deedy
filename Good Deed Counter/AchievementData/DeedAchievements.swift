//
//  DeedAchievements.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

// Implements AchievementProtocol and necessary achievements, identifier vars and the setCellText func.
class DeedAchievements: AchievementProtocol {
    // Initialize CoreDataManager for fetching data from CoreData.
    static var cdm: CoreDataManager = CoreDataManager()

    // Complies with protocol; sets achievement var.
    // The possible achievements a user can get for completing a certain number of deeds total. Dictionary holds achievement description and number corresponding to how many deeds must be done to get that achievement.
    static var achievements: [Dictionary<String, Int>] = [
        ["Complete 5 deeds" : 5],
        ["Complete 10 deeds" : 10],
        ["Complete 25 deeds" : 25],
        ["Complete 50 deeds" : 50],
        ["Complete 75 deeds" : 75],
        ["Complete 100 deeds" : 100],
        ["Complete 200 deeds" : 200]
    ]
    
    // Complies with protocol; set identifier var.
    static var identifier: String = "deedAchievement"
    
    // Complies with protocol; create custom setCellText func.
    static func setCellText(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        let totalDeedsDone = getTotalDeedsDone()
        
        // For the current cell holding a "deed" achievement.
        if (totalDeedsDone >= achievement.goalNumber) {
            // If the total number of deeds the user has done exceeds the number needed to complete that achievement, set cell text to the number of deeds needed out of the number of deeds needed (like 5/5 instead of 100/5).
            markAchievementDoneAndSetCellSubtitleTextToComplete(forCell: cell, forAchievement: achievement)
        } else {
            // If the total number of deeds the user has done is less than the number needed to complete that achievement, show the user's progress in the cell: the number of deeds they've done out of the number needed.
            cell.subtitleLabel.text = "\(totalDeedsDone) / \(achievement.goalNumber)"
        }
    }
    
    private static func markAchievementDoneAndSetCellSubtitleTextToComplete(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        // Set cell text to the number of deeds needed out of the number of deeds needed (like 5/5 instead of 100/5).
        cell.setSubtitleTextIfAchievementCompleted(to: "\(achievement.goalNumber) / \(achievement.goalNumber)")
        
        // For the Achievement object the cell holds / represents, set its isDone property to true.
        achievement.isDone = true
    }
    
    // Fetches all deeds ever done from CoreData.
    private static func getTotalDeedsDone() -> Int {
        return cdm.fetchDeeds().count
    }
    
}
