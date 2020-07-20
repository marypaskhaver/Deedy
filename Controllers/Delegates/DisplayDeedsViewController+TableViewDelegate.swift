//
//  DisplayDeedsViewController+TableViewDelegate.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

extension DisplayDeedsViewController: UITableViewDelegate {
    // Edit deed
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let editContextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 
            let evc = storyboard.instantiateViewController(withIdentifier: "EditDeedViewController") as! EditDeedViewController
                 
            evc.delegate = self
                
            // When the EditDeedViewController shows, its textView will contain the deed's text
            evc.oldText = self.dataSource.sections[indexPath.section].deeds[indexPath.row].title!
             
            self.navigationController?.present(evc, animated: true)
             
            self.editedIndexPath = indexPath
        }
         
        editContextItem.backgroundColor = CustomColors.editButtonBlue

        let swipeActions = UISwipeActionsConfiguration(actions: [editContextItem])
         
        return swipeActions
    }
     
    func userEditedDeed(newDeedTitle: String) {
        editedDeedText = newDeedTitle
        
        let editedDeed = dataSource.sections[editedIndexPath.section].deeds[editedIndexPath.row]

        let requestForPreviousDeed: NSFetchRequest<Deed> = Deed.fetchRequest()
        requestForPreviousDeed.predicate = NSPredicate(format: "date == %@", editedDeed.date! as NSDate)
        let previousDeed: Deed = dataSource.cdm.fetchDeeds(with: requestForPreviousDeed)[0]
        previousDeed.title = editedDeedText
            
        dataSource.saveDeeds()
        dataSource.loadDeeds()

        tableView.reloadRows(at: [editedIndexPath], with: .automatic)

        editedDeedText = ""
        editedIndexPath = nil
     }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataSource.sections.isEmpty {
            return 0
        }
         
        return headerFont.pointSize + 18
    }
     
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = headerFont
    }
     
     // Animate cells here
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = Animations.slideRightToLeftAnimation(duration: 1, delayFactor: 0.1)
        let animator = TableViewCellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDescendant(of: view.superview!) {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
}
