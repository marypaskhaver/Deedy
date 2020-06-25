//
//  WhiteRoundedView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class WhiteRoundedView: UIView {
    
    init(frameToDisplay: CGRect) {
        super.init(frame: frameToDisplay)

        self.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 0.9])
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.white.cgColor
        }
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8.0
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.2
        
        // Store in some sort of Constant class
//        self.tag = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
