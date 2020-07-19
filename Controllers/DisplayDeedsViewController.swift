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
    @IBOutlet weak var pageControl: TutorialPageControl!
    @IBOutlet weak var tutorialXButton: TutorialXButton!

    var dateHandler = DateHandler()
    
    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        hideTutorialItems(bool: true)
        
        tableView.reloadData()

        enableBarButtons(bool: true)
        defaults.set(true, forKey: UserDefaultsKeys.displayDeedsViewControllerTutorialShown)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default
        DisplayDeedsViewController.dateFormatter.dateFormat = "MMMM yyyy"
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)], for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)], for: .disabled)
        
        dataSource = DisplayDeedsViewControllerTableViewDataSource(withView: self.view)
        tableView.dataSource = dataSource
        
        TableViewModification.setRowAndEstimatedRowHeightsToAutomaticDimension(forTableView: tableView)
                        
        sortDeedsFromSavedData()
        updateSections()
   
        topView.setFrameInViewController(vc: self)
        
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
        TutorialSetterUpper.setUp(withViewController: self)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.changeBackgroundColor()
        
        if defaults.object(forKey: UserDefaultsKeys.displayDeedsViewControllerTutorialShown) == nil {
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
    @IBAction func cancel(segue: UIStoryboardSegue) { }
    
    // Add or sort deeds
    @IBAction func done(segue: UIStoryboardSegue) {
        let _ = self.view
        
        if (segue.identifier == "doneAddingSegue") {
            let addDeedVC = segue.source as! AddDeedViewController
            
            // When a deed is added, dataSource.sections are updated
            dataSource.addDeed(title: addDeedVC.textView.text!, date: dateHandler.currentDate() as Date)

            if dataSource.sections.count > tableView.numberOfSections {
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(integer: 0), with: .none)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
            
            dataSource.saveDeeds()

        } else if segue.identifier == "doneSortingSegue" {
            updateSections()
            tableView.reloadData()
        }
          
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
        if let dateFormat = defaults.string(forKey: UserDefaultsKeys.dateFormat) {
            DisplayDeedsViewController.dateFormatter.dateFormat = dateFormat
        }
        
        if let timeSection = defaults.string(forKey: UserDefaultsKeys.timeSection) {
            DisplayDeedsViewController.timeSection = timeSection
        }
        
        updateSections()        
    }
}
