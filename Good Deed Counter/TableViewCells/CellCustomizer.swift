//
//  CellCustomizer.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/28/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit

// Customizes cells that hold deeds in DisplayDeedsViewController and cells that hold challenges in ChallengesViewController
class CellCustomizer {
    
    static func customizeDeedCell(cell: DeedTableViewCell, withNewText text: String, view: UIView) {
        // Clear cell's current contentView from any old WhiteRoundedView.
        cell.contentView.viewWithTag(WhiteRoundedView.tag)?.removeFromSuperview()
        
        // Set cell text.
        cell.deedDescriptionLabel.text = text
        
        // Resize cell's deedDescriptionLabel's frame to be a little less wide, to add "padding."
        let frame = cell.deedDescriptionLabel.frame
        cell.deedDescriptionLabel.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: UIScreen.main.bounds.width - 20, height: cell.deedDescriptionLabel.frame.height)
        cell.deedDescriptionLabel.sizeToFit()

        // Make whiteRoundedView taller than the cell so the cell appears to have "padding."
        let whiteRoundedViewHeight = cell.deedDescriptionLabel.frame.height + 20
                
        let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: whiteRoundedViewHeight))
        
        // Add new whiteRoundedView to cell's contentView, behind the text.
        addWhiteRoundedViewToCell(cell: cell, whiteRoundedView: whiteRoundedView)
    }
    
    static func customizeChallengeCell(cell: ChallengeTableViewCell, withAchievement achievement: Achievement, view: UIView) {
        // Clear cell's current contentView from any old WhiteRoundedView.
        cell.contentView.viewWithTag(WhiteRoundedView.tag)?.removeFromSuperview()
        
        // Set cell text.
        cell.challengeDescriptionLabel.text = achievement.title

        // Set cell subtitle text.
        setCellSubtitleTextToAchievement(forCell: cell, forAchievement: achievement)
        cell.subtitleLabel.sizeToFit()
             
        // Make whiteRoundedView taller than the cell so the cell appears to have "padding."
        let whiteRoundedViewHeight = cell.challengeDescriptionLabel.frame.height + 12

        let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: whiteRoundedViewHeight))
     
        // Add new whiteRoundedView to cell's contentView, behind the text.
        addWhiteRoundedViewToCell(cell: cell, whiteRoundedView: whiteRoundedView)
    }
    
    static func addWhiteRoundedViewToCell(cell: UITableViewCell, whiteRoundedView: WhiteRoundedView) {
        // Add whiteRoundedView to cell but push behind other cell elements so text can be seen and the whiteRoundedView just provides a background.
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }
    
    static func setCellSubtitleTextToAchievement(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement) {
        // Oof, shouldn't need to rely on the identifier.
        
        // Use achievement identifier to figure out which cell it comes from, then set that cell's text properly depending on that with classes implementing the AchievementProtocol.
        if achievement.identifier == DeedAchievements.identifier {
            DeedAchievements.setCellText(forCell: cell, forAchievement: achievement)
        } else if achievement.identifier == StreakAchievements.identifier {
            StreakAchievements.setCellText(forCell: cell, forAchievement: achievement)
        }
    }
}
