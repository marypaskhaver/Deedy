//
//  WhiteRoundedView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

// Used around deeds and achievements in DisplayDeedsViewController and ChallengesViewController.
class WhiteRoundedView: UIView {
    
    // Set tag; acts as identifier.
    static var tag = 1
    
    // Init to display in custom frame.
    init(frameToDisplay: CGRect) {
        super.init(frame: frameToDisplay)

        // Set backgroundColor to grayish-white.
        self.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        
        // If in Dark Mode, set backgroundColor to be blackish and add a curved white border around cells so they stand out if the user has a dark app color theme.
        if self.traitCollection.userInterfaceStyle == .dark {
            self.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 0.9])
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.white.cgColor
        }
        
        self.layer.masksToBounds = false
        
        // Set corner radius, slight shadow effect.
        self.layer.cornerRadius = 8.0
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.2
        
        // Need to store in some sort of Constant class in the future, but set self's tag to the current tag declared above as its property. Redundant, but other classes can know WhiteRoundedView's tag too. Eh.
        self.tag = WhiteRoundedView.tag
    }

    // Required init.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
