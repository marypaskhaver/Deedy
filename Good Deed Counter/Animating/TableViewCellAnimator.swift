//
//  Animator.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

typealias TableViewCellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

final class TableViewCellAnimator {
    private var hasAnimatedAllCells = false
    private let animation: TableViewCellAnimation

    init(animation: @escaping TableViewCellAnimation) {
        self.animation = animation
    }

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, tableView)

        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        let lastRowIndexPath = IndexPath(row: lastRow, section: lastSection)
        
        hasAnimatedAllCells = (indexPath == lastRowIndexPath)
    }
}
