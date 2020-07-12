//
//  ResetButton.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/11/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class ResetButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.54 * UIScreen.main.bounds.width))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.width / 3))
    }
}
