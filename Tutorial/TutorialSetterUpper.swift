//
//  TutorialSetterUpper.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/16/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TutorialSetterUpper {
    
    static func setUp(withViewController vc: DisplayDeedsViewController) {
        let pages = vc.scrollView.createPages(forViewController: vc)
        vc.scrollView.setupSlideScrollView(withPages: pages)
        vc.view.bringSubviewToFront(vc.scrollView)
        
        vc.pageControl.setUp(withScrollView: vc.scrollView, inViewController: vc)
        vc.view.bringSubviewToFront(vc.pageControl)
        
        vc.tutorialXButton.setUp(inScrollView: vc.scrollView)
        vc.view.bringSubviewToFront(vc.tutorialXButton)
    }
    
    static func setUp(withViewController vc: ChallengesViewController) {
        let pages = vc.scrollView.createPages(forViewController: vc)
        vc.scrollView.setupSlideScrollView(withPages: pages)
        vc.view.bringSubviewToFront(vc.scrollView)
        
        vc.pageControl.setUp(withScrollView: vc.scrollView, inViewController: vc)
        vc.view.bringSubviewToFront(vc.pageControl)
        
        vc.tutorialXButton.setUp(inScrollView: vc.scrollView)
        vc.view.bringSubviewToFront(vc.tutorialXButton)
    }
    
    
}
