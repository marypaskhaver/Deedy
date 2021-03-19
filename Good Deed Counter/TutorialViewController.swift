//
//  TutorialViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/10/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides = [TutorialPage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [TutorialPage] {
        let slide1: TutorialPage = Bundle.main.loadNibNamed("TutorialPage", owner: self, options: nil)?.first as! TutorialPage
        slide1.imageView.image = UIImage(named: "ic_onboarding_1")
        slide1.instructionsTextView.text = "This is page 1"
        
        let slide2: TutorialPage = Bundle.main.loadNibNamed("TutorialPage", owner: self, options: nil)?.first as! TutorialPage
        slide2.imageView.image = UIImage(named: "ic_onboarding_2")
        slide2.instructionsTextView.text = "This is page 2"
        
        return [slide1, slide2]
    }
    
    func setupSlideScrollView(slides: [TutorialPage]) {
       scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
       scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
       scrollView.isPagingEnabled = true
       
       for i in 0 ..< slides.count {
           slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
           scrollView.addSubview(slides[i])
       }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

}
