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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let resetQuoteActionIdentifier: String = "RESET_QUOTE_ACTION"
    let categoryIdentifier: String = "RESET_QUOTE_CATEGORY"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        
                    } else {

                    }
                }
            } else if settings.authorizationStatus == .denied {

            } else if settings.authorizationStatus == .authorized {
                self.addDailyNotificationToCenter(center)
            }
        })
          
        // Override point for customization after application launch.
        changeAppColor()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func addDailyNotificationToCenter(_ center: UNUserNotificationCenter, removePendingRequests shouldRemoveRequests: Bool = true) {
        center.removeAllDeliveredNotifications()
        
        if (shouldRemoveRequests) {
            center.removeAllPendingNotificationRequests()
        }
        
        configureCategory(forCenter: center)
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = NSTimeZone.local
        dateComponents.hour = 9 // At 9:00 every morning

        let content: UNMutableNotificationContent = getRandomQuoteNotificationContent()
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
        center.add(request)
    }
    
    func configureCategory(forCenter center: UNUserNotificationCenter) {
        let resetAction = UNNotificationAction(identifier: resetQuoteActionIdentifier, title: "Get a new quote!", options: .foreground)
        
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [resetAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func getRandomQuoteNotificationContent() -> UNMutableNotificationContent {
        let randomQuote = TextFileReader().returnRandomLineFromFile(withName: "quotes")
        
        let content = UNMutableNotificationContent()
        content.title = "Quote of the Day"
        content.body = randomQuote
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = categoryIdentifier
        
        return content
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == resetQuoteActionIdentifier {
            center.removeAllPendingNotificationRequests()
            
            configureCategory(forCenter: center)

            let content: UNMutableNotificationContent = getRandomQuoteNotificationContent()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
            addDailyNotificationToCenter(center, removePendingRequests: false)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
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
        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            UINavigationBar.appearance().barTintColor = navBarColor
        } else {
            UINavigationBar.appearance().barTintColor = CustomColors.defaultBlue
        }

        if let navBarTextColor = defaults.color(forKey: UserDefaultsKeys.navBarTextColor) {
            setNavBarTextAndItemsAppearance(withColor: navBarTextColor)
        } else {
            setNavBarTextAndItemsAppearance(withColor: UIColor.white)
        }
        
        UINavigationController().navigationBar.barStyle = BarStyleSetter.getNavBarRGBSum() >= 2 ? UIBarStyle.default : UIBarStyle.black
    }
    
    func setNavBarTextAndItemsAppearance(withColor color: UIColor) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]

        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
    }

}
