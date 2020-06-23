//
//  AppDelegate.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                current.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("Yay!")
                    } else {
                        print("Phooey.")
                    }
                }
            } else if settings.authorizationStatus == .denied {
                print("Notifs disabled")
            } else if settings.authorizationStatus == .authorized {
                print("Notifs enabled")

            }
        })
        
        
        // Override point for customization after application launch.
        changeAppColor()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    // An SQL database
       lazy var persistentContainer: NSPersistentContainer = {
           
           let container = NSPersistentContainer(name: "DataModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support

       func saveContext () {
        // Context: an area in which you can update your data. Data is saved to the container.
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
    
    //MARK: - Change app color theme
    
    func changeAppColor() {
        if let navBarColor = defaults.color(forKey: "navBarColor") {
            UINavigationBar.appearance().barTintColor = navBarColor
        }

        if let navBarTextColor = defaults.color(forKey: "navBarTextColor") {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]

            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: navBarTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)
        }
    }

}
