//
//  TextViewForDeedEntry.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TextViewForDeedEntry: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8 
        self.layer.borderColor = UIColor.gray.cgColor
    }

}
