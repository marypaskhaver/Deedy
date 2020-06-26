//
//  BackgroundView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/26/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    func changeBackgroundColor() {
        if let navBarColor = defaults.color(forKey: "navBarColor") {
            changeBackgroundToColorFromComponents(from: navBarColor)
        } else {
            changeBackgroundToColorFromComponents(from: CustomColors.defaultBlue)
        }
    }
    
    func changeBackgroundToColorFromComponents(from color: UIColor) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        if b > 0.75 {
            self.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        } else {
            self.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
        }
    }
    
}
