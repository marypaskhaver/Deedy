//
//  CGPoint+Operations.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 12/21/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

extension CGPoint {
    mutating func add(vector: CGVector) {
        self.x += vector.dx
        self.y += vector.dy
    }

    func adding(vector: CGVector) -> CGPoint {
        var copy = self
        copy.add(vector: vector)
        return copy
    }

    mutating func multiply(by value: CGFloat) {
        self.x *= value
        self.y *= value
    }
}
