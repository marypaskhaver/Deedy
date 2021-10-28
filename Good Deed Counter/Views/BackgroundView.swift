//
//  BackgroundView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/26/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    // Set self's backgroundColor to be roughly same color as nav bar, whether a custom color was selected or not.
    func changeBackgroundColor() {
        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            changeBackgroundToColorFromComponents(from: navBarColor)
        } else {
            changeBackgroundToColorFromComponents(from: CustomColors.defaultBlue)
        }
    }
    
    // Sets layer's background color to param color passed in, with some other calculations.
    func changeBackgroundToColorFromComponents(from color: UIColor) {
        // Get hue-- HSBA values-- from param color
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        // If the brightness of the color param is > 0.75, set backgroundColor to it. Otherwise, set it to almost the same color, but with a higher brightness level.
        if b > 0.75 {
            self.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        } else {
            self.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
        }
    }
    
}
