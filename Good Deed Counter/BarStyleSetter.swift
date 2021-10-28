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
        // Set nav bar style based on sum of RGB values of current nav bar color.
        vc.navigationController?.navigationBar.barStyle = getNavBarRGBSum() >= 2 ? UIBarStyle.default : UIBarStyle.black
    }
    
    // Calculations for summing up RGB values in nav bar's curernt color
    static func getNavBarRGBSum() -> Int {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        // If nav bar color was set to a custom color, get its RGB values. Otherwise, get the RGB values of the defaultBlue color.
        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            navBarColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        } else {
            CustomColors.defaultBlue.getRed(&r, green: &g, blue: &b, alpha: &a)
        }
        
        // If RGB colors (scaled to out of 255) are >= 225, add 1 to sum. Otherwise, add nothing.
        var sum: Int = r * 255 >= 225 ? 1 : 0
        sum += g * 255 >= 225 ? 1 : 0
        sum += b * 255 >= 225 ? 1 : 0
        
        return sum
    }
}
