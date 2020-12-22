//
//  SparkViewFactory.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 12/21/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

protocol SparkViewFactoryData {

    var size: CGSize { get }
    var index: Int { get }

}

protocol SparkViewFactory {
    
    func create(with data: SparkViewFactoryData) -> SparkView

}

class CircleColorSparkViewFactory: SparkViewFactory {

    var colors: [UIColor] {
        return UIColor.sparkColorSet1
    }

    func create(with data: SparkViewFactoryData) -> SparkView {
        let color = self.colors[data.index % self.colors.count]
        return CircleColorSparkView(color: color, size: data.size)
    }
}
