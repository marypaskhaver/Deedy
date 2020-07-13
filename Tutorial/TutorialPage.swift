//
//  TutorialPage.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/12/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit

class TutorialPage: UIView {
    
    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: UIScreen.main.bounds.width - 30, height: 300)
    }
}

