//
//  StreakAchievements.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import CoreData

// Implements AchievementProtocol and necessary achievements, identifier vars and the setCellText func.
class StreakAchievements: AchievementProtocol {
    // Initialize CoreDataManager for fetching data from CoreData.
    static var cdm: CoreDataManager = CoreDataManager()
    
    // Complies with protocol; sets achievement var.
    // The possible achievements a user can get for attaining their daily goal for a certain number of consecutive days (streak). Dictionary holds achievement description and number corresponding to length of streak.
    static var achievements: [Dictionary<String, Int>] = [
        ["Hit your streak for 1 day" : 1],
        ["Hit your streak for 5 days" : 5],
        ["Hit your streak for 10 days" : 10],
        ["Hit your streak for 15 days" : 15],
        ["Hit your streak for 30 days" : 30],
    ]
    
    // Complies with protocol; set identifier var.
    static var identifier: String = "streakAchievement"
    
    // Complies with protocol; create custom setCellText func.
    static func setCellText(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        let streakDaysKept = getMaxStreakDaysKept()

        // For the current cell holding a "streak" achievement.
        if (streakDaysKept >= achievement.goalNumber) {
            markAchievementDoneAndSetCellSubtitleTextToComplete(forCell: cell, forAchievement: achievement)
        } else {
            cell.subtitleLabel.text = "\(streakDaysKept) / \(achievement.goalNumber)"
        }
    }
    
    private static func markAchievementDoneAndSetCellSubtitleTextToComplete(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        // If the number of streak days the user has reached exceeds the number needed to complete that achievement, set cell text to the number of days reached out of the number of days reached (like 1/1 instead of 5/1).
        cell.setSubtitleTextIfAchievementCompleted(to: "\(achievement.goalNumber) / \(achievement.goalNumber)")
        
        // For the Achievement object the cell holds / represents, set its isDone property to true.
        achievement.isDone = true
    }
    
    // Fetches all streaks ever reached from CoreData and returns the greatest one, or 0 if none was ever reached.
    static func getMaxStreakDaysKept() -> Int32 {
        return cdm.fetchStreaks().map( { $0.daysKept }).max() ?? 0
    }
}
