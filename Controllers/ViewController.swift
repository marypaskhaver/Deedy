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
    
//    var deeds = [Deed]()
//    var sections = [TimeSection]()
    static var timeSection: String = "Month"
    
    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    @IBOutlet weak var topView: TopView!
    @IBOutlet var backgroundView: BackgroundView!
    
    var editedDeedText: String = ""
    var editedIndexPath: IndexPath! = nil
    
    let headerFont = UIFont.systemFont(ofSize: 22)
    
    var cdm = CoreDataManager()
    
    lazy var dataSource = ViewControllerTableViewDataSource(withView: self.view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Default
        ViewController.dateFormatter.dateFormat = "MMMM yyyy"
        
        let font = UIFont.systemFont(ofSize: 28)

        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        loadDeeds()
        sortDeedsFromSavedData()
        updateSections()
      
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (navigationController?.navigationBar.frame.height) != nil {
            topView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: self.view.frame.width, height: topView.frame.height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.changeBackgroundColor()
    }
    
    // MARK: - Segue methods
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    // Add deed
    @IBAction func done(segue: UIStoryboardSegue) {
        let _ = self.view
        
        if (segue.identifier == "doneAddingSegue") {
            let deedDetailVC = segue.source as! AddDeedViewController
            
            let newDeed = dataSource.addDeed(title: deedDetailVC.textView.text!, date: Date())

            // Will crash if newDeed is nil/not inserted properly, etc
            dataSource.deeds.insert(newDeed!, at: 0)
        }
        
        saveDeeds()
        updateSections()
        
        tableView.reloadData()
    }
    
    @IBAction func scrollUpButtonPressed(_ sender: UIBarButtonItem) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Updating/Sorting Sections and Labels
    func splitSections() {
        // Make class for this switch statement and all
        switch ViewController.timeSection {
            case "Day":
                dataSource.sections = DaySection.group(deeds: dataSource.deeds)
            case "Week":
                dataSource.sections = WeekSection.group(deeds: dataSource.deeds)
            case "Month":
                dataSource.sections = MonthSection.group(deeds: dataSource.deeds)
            case "Year":
                dataSource.sections = YearSection.group(deeds: dataSource.deeds)
            default:
                dataSource.sections = MonthSection.group(deeds: dataSource.deeds)
        }
        
        dataSource.sections.sort { (lhs, rhs) in lhs.date > rhs.date }
    }
    
    func updateSections() {
        splitSections()
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
    
    //MARK: - Model Manipulation Methods
    func saveDeeds() {
        dataSource.saveDeeds()
    }
    
    // Provides default value if no request is sent
    func loadDeeds(with request: NSFetchRequest<Deed> = Deed.fetchRequest()) {
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        dataSource.deeds = cdm.fetchDeeds(with: request)
        updateSections()

        tableView.reloadData()
    }
}

// MARK: - TableView Delegate Methods
extension ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if dataSource.sections.isEmpty {
            return 0
        }
        
        return dataSource.sections.count
    }
    
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
        
        saveDeeds()
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
    
}

// MARK: - Search bar methods
extension ViewController: UISearchBarDelegate {
    
    // Query CoreData database
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        
        // We need to query/filter what's in our database-- can be done with an NSPredicate
        // The [cd] makes the search case and diacritic insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadDeeds(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDeeds()
            
            // Multiple threads/stuffs are happening when we try to de-activate the searchBar.
            // We need to get to the main queue (where UI elements are updated) to dismiss the searchBar while background tasks are being completed.
            // Thus: Use DispatchQueue, which manages execution of work items
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
