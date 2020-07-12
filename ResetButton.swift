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
        
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        
        self.backgroundColor = (self.traitCollection.userInterfaceStyle == .dark) ? UIColor.black : UIColor.white 

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.54 * UIScreen.main.bounds.width))
    }
}
