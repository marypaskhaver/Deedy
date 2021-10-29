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
    // Edit deed if user swipes left on a tableView cell and selects the edit button.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            // Make an edit option appear when the user swipes left on a tableView cell.
            let editContextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Create EditDeedViewController when the user taps the swipe button. This controller will initialize holding the description of the deed the user wants to edit and allow the user to type the edited deed description into it.
            let evc = storyboard.instantiateViewController(withIdentifier: "EditDeedViewController") as! EditDeedViewController
                 
            // Set EditDeedViewController to DisplayDeedsViewController's delegate.
            evc.delegate = self
                
            // When the EditDeedViewController shows, its textView will contain the deed's text.
            evc.oldText = self.dataSource.sections[indexPath.section].deeds[indexPath.row].title!
             
            // Present instance of EditDeedViewController.
            self.navigationController?.present(evc, animated: true)
             
            // To keep track of which deed is being edited, set self.editedIndexPath to currently-selected cell's indexPath.
            self.editedIndexPath = indexPath
        }
         
        // Set backgroundColor of edit button that appears when user swipes left on tableView cell.
        editContextItem.backgroundColor = CustomColors.editButtonBlue

        // Put all that stuff we defined above into an array of actions (even though it's only one element) that will be executed when the user clicks the edit button.
        let swipeActions = UISwipeActionsConfiguration(actions: [editContextItem])
         
        return swipeActions
    }
     
    func userEditedDeed(newDeedTitle: String) {
        // Get the old deed by indexing into dataSource's sections at the editedIndexPath and extracting the right deed from that section's deeds property.
        let editedDeed = dataSource.sections[editedIndexPath.section].deeds[editedIndexPath.row]
        
        // Create a fetch request w/ a predicate that limits results to those completed on the editedDeed's  date. Since each deed has a specific date (including the milliseconds it was made), this will fetch the right deed.
        let requestForPreviousDeed: NSFetchRequest<Deed> = Deed.fetchRequest()
        requestForPreviousDeed.predicate = NSPredicate(format: "date == %@", editedDeed.date! as NSDate)
        
        // Fetch the un-edited deed with this fetch request and set its title property to the new, edited title the user has entered.
        let previousDeed: Deed = dataSource.cdm.fetchDeeds(with: requestForPreviousDeed)[0]
        previousDeed.title = newDeedTitle
            
        // Save the deeds, since one has been changed.
        dataSource.saveDeeds()
        
        // Reset deeds to now hold the edited deed, since previously, the edited deed was just stored in CoreData and didn't modify the existing deeds array.
        dataSource.loadDeeds()

        // Reload the tableView at the editedIndexPath to display the new deed with its changed text.
        tableView.reloadRows(at: [editedIndexPath], with: .automatic)

        // Essentially, clear editedDeedText and editedIndexPath.
        editedDeedText = ""
        editedIndexPath = nil
     }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // If no deeds have been created, don't set a header height. Is this necessary? Maybe not.
        if dataSource.sections.isEmpty {
            return 0
        }
         
        return headerFont.pointSize + 18
    }
     
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        TableHeaderView.setTableHeaderView(forView: view, textAlign: .left)
    }
     
     // Animate cells here
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Display each cell with the slideRightToLeftAnimation in the TableViewCellAnimator class.
        let animation = Animations.slideRightToLeftAnimation(duration: 1, delayFactor: 0.1)
        let animator = TableViewCellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    // This is for the custom TutorialScrollView the DisplayDeedsViewController displays. Set its pageControl's currentPage properly depending on how much text gets offset each swipe.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDescendant(of: view.superview!) {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
}
