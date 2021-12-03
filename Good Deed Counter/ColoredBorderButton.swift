//
//  ColoredBorderButton.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/11/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class ColoredBorderButton: UIButton {    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set layer properties.
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 2
        
        // Constrain width and height based on current screen width.
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.56 * UIScreen.main.bounds.width))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.width / 20))
    }
    
    func setBorderColor(to color: CGColor) {
        self.layer.borderColor = color
    }
}
