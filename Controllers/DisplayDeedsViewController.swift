//
//  DisplayDeedsViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class DisplayDeedsViewController: UIViewController, DeedEditedDelegateProtocol {
   
    static var timeSection: String = "Month"
    
    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    @IBOutlet weak var topView: TopView!
    @IBOutlet var backgroundView: BackgroundView!
        
    var editedDeedText: String = ""
    var editedIndexPath: IndexPath! = nil

    let headerFont = UIFont.systemFont(ofSize: 22)
        
    var dataSource: DisplayDeedsViewControllerTableViewDataSource!
    
    @IBOutlet weak var scrollView: TutorialScrollView!
    @IBOutlet weak var pageControl: MyPageControl!
    @IBOutlet weak var tutorialXButton: UIButton!

    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        hideTutorialItems(bool: true)
        
        tableView.reloadData()

        enableBarButtons(bool: true)
        defaults.set(true, forKey: "DisplayDeedsViewControllerTutorialShown")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Default
        DisplayDeedsViewController.dateFormatter.dateFormat = "MMMM yyyy"
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)], for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)], for: .disabled)
        
        dataSource = DisplayDeedsViewControllerTableViewDataSource(withView: self.view)
        
        tableView.dataSource = dataSource
        
        TableViewModification.setRowAndEstimatedRowHeightsToAutomaticDimension(forTableView: tableView)
                        
        sortDeedsFromSavedData()
        updateSections()
        
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (navigationController?.navigationBar.frame.height) != nil {
            topView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: self.view.frame.width, height: topView.frame.height)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        hideTutorialItems(bool: true)
    }
    
    func enableBarButtons(bool: Bool) {
        self.navigationItem.leftBarButtonItem?.isEnabled = bool
        
        for item in self.navigationItem.rightBarButtonItems! {
            item.isEnabled = bool
        }
    }
    
    func hideTutorialItems(bool: Bool) {
        scrollView.isHidden = bool
        pageControl.isHidden = bool
        tutorialXButton.isHidden = bool
        dataSource.isShowingTutorial = !bool
    }
        
    func showTutorial() {
        enableBarButtons(bool: false)
        hideTutorialItems(bool: false)
        
        let pages = scrollView.createPages(forViewController: self)
        scrollView.setupSlideScrollView(withPages: pages)
        view.bringSubviewToFront(scrollView)
        
        pageControl.setUp(withScrollView: scrollView, inViewController: self)
        view.bringSubviewToFront(pageControl)
        
        tutorialXButton.frame = CGRect(x: scrollView.frame.width - 20, y: scrollView.frame.origin.y + 10, width: 30, height: 30)
        view.bringSubviewToFront(tutorialXButton)
        
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDescendant(of: view.superview!) {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.changeBackgroundColor()
        
        if defaults.object(forKey: "DisplayDeedsViewControllerTutorialShown") == nil {
            showTutorial()
        }
        
        BarStyleSetter.setBarStyle(forViewController: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        topView.changeBackgroundColor()
        totalDeedsLabel.textColor = (self.traitCollection.userInterfaceStyle == .dark) ? UIColor.white : UIColor.black
        tableView.reloadData()
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Segue methods
    @IBAction func cancel(segue: UIStoryboardSegue) {

    }
    
    // Add deed
    @IBAction func done(segue: UIStoryboardSegue) {
        let _ = self.view
        
        if (segue.identifier == "doneAddingSegue") {
            let addDeedVC = segue.source as! AddDeedViewController
            
            dataSource.addDeed(title: addDeedVC.textView.text!, date: Date())
        }
        
        updateSections()

        dataSource.saveDeeds()

        tableView.reloadData()
    }
    
    // MARK: - Updating/Sorting Sections and Labels
    func updateSections() {
        dataSource.splitSections()
        updateDeedsLabel()
    }
    
    func updateDeedsLabel() {
        Animations.changeLabelNumberWithPop(forLabel: totalDeedsLabel, withNewNumber: dataSource.deeds.count, duration: 0.4)
        totalDeedsLabel.text = String(dataSource.deeds.count)
    }
    
    static func changeDateFormatter(toOrderBy dateFormat: String, timeSection: String) {
        DisplayDeedsViewController.dateFormatter.dateFormat = dateFormat
        DisplayDeedsViewController.timeSection = timeSection
    }
    
    func sortDeedsFromSavedData() {
        if let dateFormat = defaults.string(forKey: "dateFormat") {
            DisplayDeedsViewController.dateFormatter.dateFormat = dateFormat
        }
        
        if let timeSection = defaults.string(forKey: "timeSection") {
            DisplayDeedsViewController.timeSection = timeSection
        }
        
        updateSections()
    }
}
