//
//  DeedAchievements.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

class DeedAchievements: AchievementProtocol {
    
    static var achievements: [Dictionary<String, Int>] = [
        ["Complete 5 deeds" : 5],
        ["Complete 10 deeds" : 10],
        ["Complete 25 deeds" : 25],
        ["Complete 50 deeds" : 50],
        ["Complete 75 deeds" : 75],
        ["Complete 100 deeds" : 100],
        ["Complete 200 deeds" : 200]
       ]
    
    static var identifier: String = "deedAchievement"
    
}
