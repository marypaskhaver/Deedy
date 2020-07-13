//
//  TutorialScrollView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/12/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TutorialScrollView: UIScrollView {
       
    func createPages(forViewController vc: UIViewController) -> [TutorialPage] {
        switch vc.restorationIdentifier {
            case "ViewController":
                return createViewControllerPages()
            case "ChallengesViewController":
                return createChallengesViewControllerPages()
            default:
                return []
        }
    }
    
    func makePageWithText(text: String) -> TutorialPage {
        let page: TutorialPage = Bundle.main.loadNibNamed("TutorialPage", owner: self, options: nil)?.first as! TutorialPage
        page.textView.text = text
        
        return page
    }
    
    func createViewControllerPages() -> [TutorialPage] {
        let page1 = makePageWithText(text: "\n\t\t\tWelcome to Deedy!\n\n  • Press ＋ (top right) to add deeds\n\n  • Swipe left on a deed to edit it\n\n   • Exit the tutorial to begin recording deeds")
        
        let page2 = makePageWithText(text: "\n\t\t\tWelcome to Deedy!\n\n  • Press ＋ (top right) to add deeds\n\n  • Swipe left on a deed to edit it\n\n   • Exit the tutorial to begin recording deeds")
        
        return [page1, page2]
    }
    
    func createChallengesViewControllerPages() -> [TutorialPage] {
        let page1 = makePageWithText(text: "\n\t\t\tWelcome to Deedy!\n\n  • Set a challenge to complete a certain amount of deeds daily \n\n  • Setting a challenge will show a daily streak")
        
        let page2 = makePageWithText(text: "\n\t\t\tWelcome to Deedy!\n\n  • If you complete your challenge, your streak will increase\n\n  • If you don't, your streak will reset")
        
        let page3 = makePageWithText(text: "\n\t\t\tWelcome to Deedy!\n\n  • Track your impact and progress with achievements\n\n  • Exit the tutorial to view them")
        
        return [page1, page2, page3]
    }
    
    func setupSlideScrollView(withPages pages: [TutorialPage]) {
        self.frame = CGRect(x: 15, y: UIScreen.main.bounds.height / 2 - 100, width: UIScreen.main.bounds.width - 30, height: 300)
        self.contentSize = CGSize(width: self.frame.width * CGFloat(pages.count), height: self.frame.height)
        self.layer.cornerRadius = 20
        
        self.isPagingEnabled = true
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: (UIScreen.main.bounds.width - 30) * CGFloat(i), y: 0, width: UIScreen.main.bounds.width - 30, height: self.frame.height)
            self.addSubview(pages[i])            
        }
    }
}
