//
//  TableViewModification.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TableViewModification {
    // Sets param tableView's rowHeight and estimatedRowHeight properties to .automaticDimension. Used to configure tableViews in DisplayDeeds and Challenges View Controllers.
    static func setRowAndEstimatedRowHeightsToAutomaticDimension(forTableView tableView: UITableView) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
}
