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
        self.backgroundColor = (self.traitCollection.userInterfaceStyle == .dark) ? UIColor.black : UIColor.white
    }

}
