//
//  TableHeaderView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 10/28/21.
//  Copyright © 2021 Nostaw. All rights reserved.
//

import UIKit

// Used to display section headers for tables in DisplayDeeds and ChallengesViewControllers.
class TableHeaderView {
    
    static let headerFont = UIFont.systemFont(ofSize: 22)

    // Creates section header w/ custom text alignment for table views. Is white w/ black text when not in Dark Mode and black w/ white text when in Dark Mode.
    static func setTableHeaderView(forView view: UIView, textAlign: NSTextAlignment) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = textAlign
        header.textLabel?.font = headerFont
        
        // Set tint and text colors based on Dark Mode.
        header.tintColor = (view.traitCollection.userInterfaceStyle == .dark) ? .black : .white
        header.textLabel?.textColor = (view.traitCollection.userInterfaceStyle == .dark) ? .white : .black
    }
}
