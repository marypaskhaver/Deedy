//
//  ViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, DeedEditedDelegateProtocol {
   
    static var timeSection: String = "Month"
    
    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    @IBOutlet weak var topView: TopView!
    @IBOutlet var backgroundView: BackgroundView!
        
    var editedDeedText: String = ""
    var editedIndexPath: IndexPath! = nil

    let headerFont = UIFont.systemFont(ofSize: 22)
        
    var dataSource: ViewControllerTableViewDataSource!
    
    @IBOutlet weak var scrollView: TutorialScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tutorialXButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Default
        ViewController.dateFormatter.dateFormat = "MMMM yyyy"
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)], for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)], for: .disabled)
        
        dataSource = ViewControllerTableViewDataSource(withView: self.view)
        
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
                        
        dataSource.loadDeeds()
        sortDeedsFromSavedData()
        updateSections()
        
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (navigationController?.navigationBar.frame.height) != nil {
            topView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: self.view.frame.width, height: topView.frame.height)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        showTutorial()
    }
    
    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        scrollView.isHidden = true
        pageControl.isHidden = true
        tutorialXButton.isHidden = true
        dataSource.isShowingTutorial = false
        
        tableView.reloadData()

        enableBarButtons(bool: true)
    }
    
    func enableBarButtons(bool: Bool) {
        self.navigationItem.leftBarButtonItem?.isEnabled = bool
        
        for item in self.navigationItem.rightBarButtonItems! {
            item.isEnabled = bool
        }
    }
    
    func showTutorial() {
        enableBarButtons(bool: false)
        dataSource.isShowingTutorial = true
        
        let pages = scrollView.createPages(forViewController: self)
        scrollView.setupSlideScrollView(withPages: pages)
        
        pageControl.frame = CGRect(x: scrollView.frame.width / 2, y: scrollView.frame.maxY - 50, width: 37, height: 39)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        tutorialXButton.frame = CGRect(x: scrollView.frame.width - 20, y: scrollView.frame.origin.y + 10, width: 30, height: 30)
        view.bringSubviewToFront(tutorialXButton)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDescendant(of: view.superview!) {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.changeBackgroundColor()
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
        ViewController.dateFormatter.dateFormat = dateFormat
        ViewController.timeSection = timeSection
    }
    
    func sortDeedsFromSavedData() {
        if let dateFormat = defaults.string(forKey: "dateFormat") {
            ViewController.dateFormatter.dateFormat = dateFormat
        }
        
        if let timeSection = defaults.string(forKey: "timeSection") {
            ViewController.timeSection = timeSection
        }
        
        updateSections()
    }
}

// MARK: - TableView Delegate Methods
extension ViewController: UITableViewDelegate {
    // Edit deed
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editContextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let evc = storyboard.instantiateViewController(withIdentifier: "EditDeedViewController") as! EditDeedViewController
            
            evc.delegate = self
            
            evc.oldText = self.dataSource.deeds[indexPath.row].title!
            
            self.navigationController?.present(evc, animated: true)
            
            self.editedIndexPath = indexPath
        }
        
        // Dark blue
        editContextItem.backgroundColor = CustomColors.editButtonBlue

        let swipeActions = UISwipeActionsConfiguration(actions: [editContextItem])
        
        return swipeActions
    }
    
    func userEditedDeed(newDeedTitle: String) {
        editedDeedText = newDeedTitle
        
        dataSource.deeds[editedIndexPath.row].title = editedDeedText

        editedDeedText = ""
        editedIndexPath = nil
        
        dataSource.saveDeeds()
        updateSections()
        
        tableView.reloadData()
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
    
}

// MARK: - Search bar methods
extension ViewController: UISearchBarDelegate {
    
    // Query CoreData database
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        
        // We need to query/filter what's in our database-- can be done with an NSPredicate
        // The [cd] makes the search case and diacritic insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        dataSource.loadDeeds(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            dataSource.loadDeeds()
            tableView.reloadData()

            // Multiple threads/stuffs are happening when we try to de-activate the searchBar.
            // We need to get to the main queue (where UI elements are updated) to dismiss the searchBar while background tasks are being completed.
            // Thus: Use DispatchQueue, which manages execution of work items
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
