//
//  StreakAchievements.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import CoreData

class StreakAchievements: AchievementProtocol {
    static var cdm: CoreDataManager = CoreDataManager()
    
    static var achievements: [Dictionary<String, Int>] = [
        ["Hit your streak for 1 day" : 1],
        ["Hit your streak for 5 days" : 5],
        ["Hit your streak for 10 days" : 10],
        ["Hit your streak for 15 days" : 15],
        ["Hit your streak for 30 days" : 30],
    ]
    
    static var identifier: String = "streakAchievement"
    
    static func setCellText(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        let streakDaysKept = getStreakDaysKept()
        
        if (streakDaysKept >= achievement.goalNumber) {
            markAchievementDoneAndSetCellSubtitleTextToComplete(forCell: cell, forAchievement: achievement)
        } else {
            cell.subtitleLabel.text = "\(streakDaysKept) / \(achievement.goalNumber)"
        }
    }
    
    private static func markAchievementDoneAndSetCellSubtitleTextToComplete(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        cell.setSubtitleTextIfAchievementCompleted(to: "\(achievement.goalNumber) / \(achievement.goalNumber)")
        achievement.isDone = true
    }
    
    static func getStreakDaysKept() -> Int32 {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()

        return cdm.fetchStreaks(with: request).map( { $0.daysKept }).max() ?? 0
    }
}
