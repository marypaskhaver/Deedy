//
//  BarStyleSetter.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/13/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit

class BarStyleSetter {
    
    static func setBarStyle(forViewController vc: UIViewController) {
        vc.navigationController?.navigationBar.barStyle = getNavBarRGBSum() >= 2 ? UIBarStyle.default : UIBarStyle.black
    }
    
    static func getNavBarRGBSum() -> Int {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            navBarColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        } else {
            CustomColors.defaultBlue.getRed(&r, green: &g, blue: &b, alpha: &a)
        }
        
        var sum: Int = r * 255 >= 225 ? 1 : 0
        sum += g * 255 >= 225 ? 1 : 0
        sum += b * 255 >= 225 ? 1 : 0
        
        return sum
    }
}
