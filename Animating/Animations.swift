//
//  Animations.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit

enum Animations {
    
    static func slideRightToLeftAnimation(duration: TimeInterval, delayFactor: Double) -> TableViewCellAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

            UIView.animate(
                withDuration: 1,
                delay: 0.1 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    static func changeLabelNumberWithPop(forLabel label: UILabel, withNewNumber num: Int, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            label.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
                label.text = String(num)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                label.transform = .identity
            })
        }        
    }
    
    static func getFadeInAnimationForCALayer(atIndex index: Int) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.beginTime = CACurrentMediaTime() + 0.3 * Double(index)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }
}
