//
//  TutorialScrollView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/12/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TutorialScrollView: UIScrollView {
   
    func createPages() -> [TutorialPage] {
        let page1: TutorialPage = Bundle.main.loadNibNamed("TutorialPage", owner: self, options: nil)?.first as! TutorialPage
        page1.textView.text = "\t\t    Welcome to Deedy!\n\n• Press ＋ to add deeds\n\n• Swipe left on a deed to edit it"
        
        let page2: TutorialPage = Bundle.main.loadNibNamed("TutorialPage", owner: self, options: nil)?.first as! TutorialPage
        page2.textView.text = "\t\t    Welcome to Deedy!\n\n•Press 📊 to see graphs of your deeds in the past month\n\n• Press Sort to sort deeds by date"
        
        return [page1, page2]
    }
    
    func setupSlideScrollView(withPages pages: [TutorialPage]) {
        self.frame = CGRect(x: 15, y: UIScreen.main.bounds.height / 2 - 50, width: UIScreen.main.bounds.width - 30, height: 300)
        self.contentSize = CGSize(width: self.frame.width * CGFloat(pages.count), height: self.frame.height)
        
        self.isPagingEnabled = true
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: (UIScreen.main.bounds.width - 30) * CGFloat(i), y: -50, width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height)
            self.addSubview(pages[i])
        }
    }

}
