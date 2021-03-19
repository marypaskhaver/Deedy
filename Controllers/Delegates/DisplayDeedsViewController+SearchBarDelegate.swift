//
//  DisplayDeedsViewController+SearchBarDelegate.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

extension DisplayDeedsViewController: UISearchBarDelegate {
    // Query CoreData database
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        
        // We need to query/filter what's in our database-- can be done with an NSPredicate
        // The [cd] makes the search case and diacritic insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        dataSource.loadDeeds(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            dataSource.loadDeeds()
            tableView.reloadData()

            // Multiple threads/stuffs are happening when we try to de-activate the searchBar.
            // We need to get to the main queue (where UI elements are updated) to dismiss the searchBar while background tasks are being completed.
            // Thus: Use DispatchQueue, which manages execution of work items
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
