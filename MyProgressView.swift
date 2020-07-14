//
//  MyProgressView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class MyProgressView: UIProgressView {

    override func awakeFromNib() {
        self.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
    }

}
