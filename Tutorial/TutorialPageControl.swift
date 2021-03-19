//
//  TutorialPageControl.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TutorialPageControl: UIPageControl {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(withScrollView scrollView: TutorialScrollView, inViewController vc: UIViewController) {
        let numPages = scrollView.createPages(forViewController: vc).count
        
        self.frame = CGRect(x: 0, y: scrollView.frame.maxY - 50, width: vc.view.bounds.width, height: 37)

        self.numberOfPages = numPages
        self.currentPage = 0
    }
    
}
