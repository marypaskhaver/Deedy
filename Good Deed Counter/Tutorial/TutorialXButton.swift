//
//  TutorialXButton.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/16/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TutorialXButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(inScrollView scrollView: TutorialScrollView) {
        self.frame = CGRect(x: scrollView.frame.width - 20, y: scrollView.frame.origin.y + 10, width: 30, height: 30)
    }

}
