//
//  TopView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TopView: UIView {

    override func awakeFromNib() {
        self.backgroundColor = UIColor.white
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.backgroundColor = UIColor.black
        }
    }

}
