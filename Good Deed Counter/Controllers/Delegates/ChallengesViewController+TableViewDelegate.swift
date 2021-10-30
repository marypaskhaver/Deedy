//
//  ChallengesViewController+TableViewDelegate.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

extension ChallengesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        TableHeaderView.setTableHeaderView(forView: view, textAlign: .center)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerFont = UIFont.systemFont(ofSize: 22)
        return headerFont.pointSize + 18
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = Animations.slideRightToLeftAnimation(duration: 1, delayFactor: 0.1)
        let animator = TableViewCellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    // This is for the custom TutorialScrollView the ChallengesViewController displays. Set its pageControl's currentPage properly depending on how much text gets offset each swipe.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDescendant(of: view.superview!) {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }

}

