//
//  ViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class ViewController: UIViewController, DataEnteredDelegateProtocol {
    
    var deeds = [Deed]()
    var sections = [TimeSection]()
    static var timeSection: String = "Month"
    
    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    
    var editedDeedText: String = ""
    var editedIndexPath: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateSections()
        ViewController.dateFormatter.dateFormat = "MMMM yyyy"
        
        let font = UIFont.systemFont(ofSize: 28)

        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        loadDeeds()
        sortDeedsFromSavedData()
    }
    
    // MARK: - Segue methods
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    // Add deed
    @IBAction func done(segue: UIStoryboardSegue) {
        let _ = self.view
        
        if (segue.identifier == "doneAddingSegue") {
            let deedDetailVC = segue.source as! DeedDetailViewController
            
            let newDeed = Deed(context: context)
            newDeed.title = deedDetailVC.deedTF.text
            newDeed.date = Date()
                                       
            deeds.insert(newDeed, at: 0)
        } else if (segue.identifier == "doneSortingSegue") {
            
        }
        
        self.saveDeeds()
        
        // Add update GlobalViewController here
        GlobalViewController.add1ToTotalDeeds()
    }
    
    // MARK: - Updating/Sorting Sections and Labels
    func splitSections() {
        if (ViewController.timeSection == "Day") {
            self.sections = DaySection.group(deeds: deeds)
        } else if (ViewController.timeSection == "Week") {
            self.sections = WeekSection.group(deeds: deeds)
        } else if (ViewController.timeSection == "Month") {
            self.sections = MonthSection.group(deeds: deeds)
        } else if (ViewController.timeSection == "Year") {
            self.sections = YearSection.group(deeds: deeds)
        }
        
        self.sections.sort { (lhs, rhs) in lhs.date > rhs.date }
    }
    
    func updateSections() {
        splitSections()
        updateDeedsLabel()
    }
    
    func updateDeedsLabel() {
        totalDeedsLabel.text = String(deeds.count)
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
        updateSections()
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Provides default value if no request is sent
    func loadDeeds(with request: NSFetchRequest<Deed> = Deed.fetchRequest()) {
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            deeds = try context.fetch(request)
            updateSections()
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate Methods
extension ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Edit deed
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let evc = storyboard.instantiateViewController(withIdentifier: "EditDeedViewController") as! EditDeedViewController
            evc.delegate = self
            
            evc.oldText = self.deeds[indexPath.row].title!
            
            self.navigationController?.present(evc, animated: true)
            
            self.editedIndexPath = indexPath
            
            tableView.reloadData()
        }
                
        contextItem.backgroundColor = UIColor(red: 0 / 255.0, green: 148 / 255.0, blue: 206 / 255.0, alpha: 1.0)

        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    func userEditedDeed(newDeedTitle: String) {
        editedDeedText = newDeedTitle
        
        deeds[editedIndexPath.row].title = editedDeedText

        editedDeedText = ""
        editedIndexPath = nil
        
        saveDeeds()
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = section.date
        
        if (ViewController.timeSection == "Week") {
            return "Week of " + ViewController.dateFormatter.string(from: date);
        }
        
        return ViewController.dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 22)
    }
    
}

// MARK: - TableView DataSource Methods
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.sections.isEmpty) {
            return 0
        }
        
        let section = self.sections[section]
        return section.deeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deedCell", for: indexPath) as! DeedTableViewCell
        
        let section = self.sections[indexPath.section]
        let deed = section.deeds[indexPath.row]
        
        cell.deedDescriptionLabel.text = deed.title
        
        return cell
    }
}

// MARK: - Search bar methods
extension ViewController: UISearchBarDelegate {
    
    // Query CoreData database
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Deed> = Deed.fetchRequest()
        
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
