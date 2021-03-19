//
//  CubicBezierTrajectory.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 12/21/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

// Bezier path with two control points
struct CubicBezierTrajectory: SparkTrajectory {

    var points = [CGPoint]()

    init(_ x0: CGFloat, _ y0: CGFloat,
         _ x1: CGFloat, _ y1: CGFloat,
         _ x2: CGFloat, _ y2: CGFloat,
         _ x3: CGFloat, _ y3: CGFloat) {
        self.points.append(CGPoint(x: x0, y: y0))
        self.points.append(CGPoint(x: x1, y: y1))
        self.points.append(CGPoint(x: x2, y: y2))
        self.points.append(CGPoint(x: x3, y: y3))
    }

    var path: UIBezierPath {
        guard self.points.count == 4 else { fatalError("4 points required") }

        let path = UIBezierPath()
        path.move(to: self.points[0])
        path.addCurve(to: self.points[3], controlPoint1: self.points[1], controlPoint2: self.points[2])
        return path
    }
}
