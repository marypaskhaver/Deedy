//
//  CellCustomizer.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/28/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CellCustomizer {
    
    static func customizeDeedCell(cell: DeedTableViewCell, withNewText text: String, view: UIView) {
        cell.contentView.viewWithTag(WhiteRoundedView.tag)?.removeFromSuperview()
        
        cell.deedDescriptionLabel.text = text
        cell.deedDescriptionLabel.sizeToFit()
        
        let whiteRoundedViewHeight = cell.deedDescriptionLabel.frame.height + 20
                
        let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: whiteRoundedViewHeight))
        
        addWhiteRoundedViewToCell(cell: cell, whiteRoundedView: whiteRoundedView)
    }
    
    static func customizeChallengeCell(cell: ChallengeTableViewCell, withAchievement achievement: Achievement, view: UIView) {
        cell.contentView.viewWithTag(WhiteRoundedView.tag)?.removeFromSuperview()
                              
         cell.challengeDescriptionLabel.text = achievement.title

         setCellSubtitleTextToAchievement(forCell: cell, forAchievement: achievement)
         
         cell.subtitleLabel.sizeToFit()
                 
         let whiteRoundedViewHeight = cell.challengeDescriptionLabel.frame.height + cell.subtitleLabel.frame.height
    
         let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: whiteRoundedViewHeight - 18))
         
         addWhiteRoundedViewToCell(cell: cell, whiteRoundedView: whiteRoundedView) 
    }
    
    static func addWhiteRoundedViewToCell(cell: UITableViewCell, whiteRoundedView: WhiteRoundedView) {
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }
    
    static func setCellSubtitleTextToAchievement(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
            if achievement.identifier == DeedAchievements.identifier {
                let totalDeedsDone = getTotalDeedsDone()
                
                if (totalDeedsDone >= achievement.goalNumber) {
                    markAchievementDoneAndSetCellSubtitleTextToComplete(forCell: cell, forAchievement: achievement)
                } else {
                    cell.subtitleLabel.text = "\(totalDeedsDone) / \(achievement.goalNumber)"
                }
                
            } else if achievement.identifier == StreakAchievements.identifier {
                let streakDaysKept = getStreakDaysKept()
                
                if (streakDaysKept >= achievement.goalNumber) {
                    markAchievementDoneAndSetCellSubtitleTextToComplete(forCell: cell, forAchievement: achievement)
                } else {
                    cell.subtitleLabel.text = "\(streakDaysKept) / \(achievement.goalNumber)"
                }
            }
        }
        
    static func markAchievementDoneAndSetCellSubtitleTextToComplete(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        cell.setSubtitleTextIfAchievementCompleted(to: "\(achievement.goalNumber) / \(achievement.goalNumber)")
        achievement.isDone = true
    }
    
    static func getTotalDeedsDone() -> Int {
        return CoreDataManager().fetchDeeds().count
    }
    
    static func getStreakDaysKept() -> Int {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        return Int(CoreDataManager().fetchStreaks(with: request)[0].daysKept)
    }

}
