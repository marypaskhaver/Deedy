//
//  TableViewModification.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TableViewModification {
    static func setRowAndEstimatedRowHeightsToAutomaticDimension(forTableView tableView: UITableView) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
}
