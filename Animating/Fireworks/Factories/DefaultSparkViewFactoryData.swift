//
//  DefaultSparkViewFactoryData.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 12/21/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class DefaultSparkViewFactoryData: SparkViewFactoryData {
    var size: CGSize
    var index: Int
    
    init(size: CGSize, index: Int) {
        self.size = CGSize(width: Int.random(in: 10..<20), height: Int.random(in: 10..<20))
        self.index = Int.random(in: 0..<10)
    }
    
}
