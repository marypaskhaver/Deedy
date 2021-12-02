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
        self.backgroundColor = color

    }
    
}
