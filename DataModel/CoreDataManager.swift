//
//  CoreDataManager.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    let persistentContainer: NSPersistentContainer!
    var dateHandler = DateHandler()
    
    // MARK: - Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        
        self.init(container: appDelegate.persistentContainer)
    }
    
    // Commit changes in the background thread instead of main thread
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - CRUD for Deeds
    func insertDeed(title: String, date: Date) -> Deed? {
        guard let deed = NSEntityDescription.insertNewObject(forEntityName: "Deed", into: backgroundContext) as? Deed else { return nil }
        
        deed.title = title
        deed.date = date

        return deed
    }

    func fetchDeeds(with request: NSFetchRequest<Deed> = Deed.fetchRequest()) -> [Deed] {
        let results = try? persistentContainer.viewContext.fetch(request)
        
        return results ?? [Deed]()
    }
    
    // MARK: - CRUD for DailyChallenges
    func insertDailyChallenge(dailyGoal: Int32, date: Date) -> DailyChallenge? {
        guard let challenge = NSEntityDescription.insertNewObject(forEntityName: "DailyChallenge", into: backgroundContext) as? DailyChallenge else { return nil }
        
        challenge.dailyGoal = dailyGoal
        challenge.date = date

        return challenge
    }
    
    func fetchLatestDailyChallengeDailyGoal(with request: NSFetchRequest<DailyChallenge> = DailyChallenge.fetchRequest()) -> Int32 {
        let request: NSFetchRequest<DailyChallenge> = DailyChallenge.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let results = try? persistentContainer.viewContext.fetch(request)
        
        // If no DailyChallenges have been saved before
        if results?.count == 0 {
            _ = self.insertDailyChallenge(dailyGoal: 0, date: dateHandler.currentDate() as Date)!
            self.save()
            return 0
        }
        
        return results?[0].dailyGoal ?? 0
    }
    
    // MARK: - CRUD for Streaks
    func insertStreak(daysKept: Int32, wasUpdatedToday: Bool, date: Date) -> Streak? {
        guard let streak = NSEntityDescription.insertNewObject(forEntityName: "Streak", into: backgroundContext) as? Streak else { return nil }
        
        streak.daysKept = daysKept
        streak.wasUpdatedToday = wasUpdatedToday
        streak.date = date
        
        self.save()
        return streak
    }
    
    func fetchStreaks(with request: NSFetchRequest<Streak> = Streak.fetchRequest()) -> [Streak] {
        let results = try? persistentContainer.viewContext.fetch(request)
        
        return results ?? [Streak]()
    }
    
    func fetchLatestStreak(with request: NSFetchRequest<Streak> = Streak.fetchRequest()) -> Streak {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let results = try? persistentContainer.viewContext.fetch(request)

        // No previous streaks have ever been saved
        if (results?.count == 0) {
            let newStreak = self.insertStreak(daysKept: 0, wasUpdatedToday: false, date: dateHandler.currentDate() as Date)!
            self.save()
            return newStreak
        }
        
        return (results?[0])!
    }
    
    // MARK: - CRUD for Achievements
    func insertAchievement(title: String, identifier: String, goalNumber: Int32, isDone: Bool) -> Achievement? {
        guard let achievement = NSEntityDescription.insertNewObject(forEntityName: "Achievement", into: backgroundContext) as? Achievement else { return nil }
        
        achievement.title = title
        achievement.identifier = identifier
        achievement.goalNumber = goalNumber
        achievement.isDone = isDone
        
        return achievement
    }
    
    func fetchAchievements(with request: NSFetchRequest<Achievement> = Achievement.fetchRequest()) -> [Achievement] {
        let results = try? persistentContainer.viewContext.fetch(request)
        
        return results ?? [Achievement]()
    }
    
    // MARK: - Universal save
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }

    }
}
