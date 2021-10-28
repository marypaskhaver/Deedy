//
//  TextViewForDeedEntry.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

// Text view used in AddDeedsViewController where user will type a deed they have done.
class TextViewForDeedEntry: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make rounded text view w/ gray border.
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8 
        self.layer.borderColor = UIColor.gray.cgColor
    }

}
