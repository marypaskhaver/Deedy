//
//  AchievementProtocol.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

// Implemented by DeedAchievements and StreakAchievements.
// Protocol to represent the achievements presented in ChallengesViewController. Each class that implements this protocol for a unique kind of achievement must provide a dictionary that has the description of the achievement plus a way it can be quantified, an identifier, and a way to modify a cell's text based on whether the achievement is done or not.
protocol AchievementProtocol {
    static var achievements: [Dictionary<String, Int>] { get set }
    static var identifier: String { get set }
    static func setCellText(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement)
}
