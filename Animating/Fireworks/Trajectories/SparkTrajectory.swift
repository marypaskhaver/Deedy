//
//  SparkTrajectory.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 12/21/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

protocol SparkTrajectory {

    // Stores all points that defines a trajectory
    var points: [CGPoint] { get set }

    // A path representing trajectory
    var path: UIBezierPath { get }
}

extension SparkTrajectory {

    // Scales a trajectory so it fits to a UI requirements in terms of size of a trajectory.
    // Use it after all other transforms have been applied and before 'shift'.
    func scale(by value: CGFloat) -> SparkTrajectory {
            var copy = self
            (0..<self.points.count).forEach { copy.points[$0].multiply(by: value) }
            return copy
        }

    // Flips trajectory horizontally
    func flip() -> SparkTrajectory {
        var copy = self

        (0..<self.points.count).forEach { copy.points[$0].x *= -1 }

        return copy
    }

    // Shifts a trajectory by (x, y). Applies to each point.
    // Use it after all other transformations have been applied and after 'scale'.
    func shift(to point: CGPoint) -> SparkTrajectory {
        var copy = self

        let vector = CGVector(dx: point.x, dy: point.y)
        (0..<self.points.count).forEach { copy.points[$0].add(vector: vector) }
        
        return copy
    }
}
