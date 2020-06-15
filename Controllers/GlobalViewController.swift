//
//  GlobalViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 5/22/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class GlobalViewController: UIViewController {

    @IBOutlet weak var truncatedNumberOfGlobalDeeds: UILabel!
    @IBOutlet weak var numeralOfGlobalDeeds: UILabel!
    static var totalDeeds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Fetch from database, then adjust labels
        changeAppColor()        
    }
    
    func changeAppColor() {
        if let navBarColor = defaults.color(forKey: "navBarColor") {
            navigationController?.navigationBar.barTintColor = navBarColor
            UINavigationBar.appearance().barTintColor = navBarColor
        }
        
        if let navBarTextColor = defaults.color(forKey: "navBarTextColor") {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTextColor]

            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTextColor]
            
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: navBarTextColor], for: .normal)
        }
    }
    
    static func add1ToTotalDeeds() {
        totalDeeds += 1
        
        // Write to database
    }
    
    func formatPoints(num: Double) -> [String] {
        let thousandNum = num / 1000
        let millionNum = num / 1000000
        let billionNum = num / 1000000000
        
        if num >= 1000 && num < 1000000 {
            if (floor(thousandNum) == thousandNum){
                return ["\(Int(thousandNum))", "thousand"]
            }
            
            return ["\(thousandNum.truncate(places: 2))", "thousand"]
        }
        
        if num >= 1000000 && num < 1000000000 {
            if (floor(millionNum) == millionNum) {
                return ["\(Int(millionNum))", "million"]
            }
                        
            return ["\(millionNum.truncate(places: 2))", "million"]
        }
        
        if num >= 1000000000 {
            if (floor(billionNum) == billionNum) {
                return ["\(Int(billionNum))", "billion"]
            }
            
            return ["\(billionNum.truncate(places: 2))", "billion"]
        }
            
        else {
            if (floor(num) == num) {
                return ["\(Int(num))", ""]
            }
            
            return ["\(num.truncate(places: 2))", ""]
        }
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}
