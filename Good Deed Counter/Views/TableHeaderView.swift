//
//  TableHeaderView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 10/28/21.
//  Copyright © 2021 Nostaw. All rights reserved.
//

import UIKit

class TableHeaderView {
    
    static let headerFont = UIFont.systemFont(ofSize: 22)

    static func setTableHeaderView(forView view: UIView, textAlign: NSTextAlignment) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = textAlign
        header.textLabel?.font = headerFont
        header.tintColor = (view.traitCollection.userInterfaceStyle == .dark) ? .black : .white
        header.textLabel?.textColor = (view.traitCollection.userInterfaceStyle == .dark) ? .white : .black
    }
}
