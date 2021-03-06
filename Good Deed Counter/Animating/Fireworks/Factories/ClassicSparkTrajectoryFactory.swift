//
//  ClassicSparkTrajectoryFactory.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 12/21/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

protocol ClassicSparkTrajectoryFactoryProtocol: SparkTrajectoryFactory {
    func randomTopRight() -> SparkTrajectory
    func randomBottomRight() -> SparkTrajectory
}

// Each trajectory starts at (0, 0)
final class ClassicSparkTrajectoryFactory: ClassicSparkTrajectoryFactoryProtocol {
    
    private lazy var topRight: [SparkTrajectory] = {
        return [
                CubicBezierTrajectory(0.00, 0.00, 0.31, -0.46, 0.74, -0.29, 0.99, 0.12),
                CubicBezierTrajectory(0.00, 0.00, 0.31, -0.46, 0.62, -0.49, 0.88, -0.19),
                CubicBezierTrajectory(0.00, 0.00, 0.10, -0.54, 0.44, -0.53, 0.66, -0.30),
                CubicBezierTrajectory(0.00, 0.00, 0.19, -0.46, 0.41, -0.53, 0.65, -0.45),
            ]
    }() 

    private lazy var bottomRight: [SparkTrajectory] = {
        return [
                CubicBezierTrajectory(0.00, 0.00, 0.42, -0.01, 0.68, 0.11, 0.87, 0.44),
                CubicBezierTrajectory(0.00, 0.00, 0.35, 0.00, 0.55, 0.12, 0.62, 0.45),
                CubicBezierTrajectory(0.00, 0.00, 0.21, 0.05, 0.31, 0.19, 0.32, 0.45),
                CubicBezierTrajectory(0.00, 0.00, 0.18, 0.00, 0.31, 0.11, 0.35, 0.25),
        ]
    }()

    func randomTopRight() -> SparkTrajectory {
        return self.topRight[Int(arc4random_uniform(UInt32(self.topRight.count)))]
    }

    func randomBottomRight() -> SparkTrajectory {
        return self.bottomRight[Int(arc4random_uniform(UInt32(self.bottomRight.count)))]
    }
}
