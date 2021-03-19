//
//  AchievementProtocol.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

protocol AchievementProtocol {
    static var achievements: [Dictionary<String, Int>] { get set }
    static var identifier: String { get set }
    static func setCellText(forCell cell: ChallengeTableViewCell, forAchievement achievement: Achievement)
}
