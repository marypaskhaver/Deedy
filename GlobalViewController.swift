//
//  GlobalViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 5/22/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class GlobalViewController: UIViewController {

    @IBOutlet weak var globalTotalDeedsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func formatPoints(num: Double) -> String {
        let thousandNum = num / 1000
        let millionNum = num / 1000000
        
        if num >= 1000 && num < 1000000 {
            if (floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            
            return("\(thousandNum.truncate(places: 2))k")
        }
        
        //Used to be num > 1000000
        if num >= 1000000 {
//            if (floor(millionNum) == millionNum) {
//                return("\(Int(thousandNum))k")
//            }
            
            if (floor(millionNum) == millionNum) {
                return("\(Int(millionNum))M")
            }
                        
            return ("\(millionNum.truncate(places: 2))M")
        } else {
            if (floor(num) == num) {
                return ("\(Int(num))")
            }
            
            return ("\(num.truncate(places: 2))")
        }
    }
}

extension Double
{
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}
