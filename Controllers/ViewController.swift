//
//  ViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

//let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let cdm = CoreDataManager()

class ViewController: UIViewController, DeedEditedDelegateProtocol {
    
    var deeds = [Deed]()
    var sections = [TimeSection]()
    static var timeSection: String = "Month"
    
    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    @IBOutlet weak var topView: TopView!
    
    var editedDeedText: String = ""
    var editedIndexPath: IndexPath! = nil
    
    let headerFont = UIFont.systemFont(ofSize: 22)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewController.dateFormatter.dateFormat = "MMMM yyyy"
        
        let font = UIFont.systemFont(ofSize: 28)

        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
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
        if let navBarColor = defaults.color(forKey: "navBarColor") {
            changeViewBackgroundColorFromComponents(from: navBarColor)
        } else {
            changeViewBackgroundColorFromComponents(from: CustomColors.defaultBlue)
        }
    }
    
    func changeViewBackgroundColorFromComponents(from color: UIColor) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        if b > 0.75 {
            view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        } else {
            view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
        }
    }
    
    // MARK: - Segue methods
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    // Add deed
    @IBAction func done(segue: UIStoryboardSegue) {
        let _ = self.view
        
        if (segue.identifier == "doneAddingSegue") {
            let deedDetailVC = segue.source as! DeedDetailViewController
            
            let newDeed = cdm.insertDeed(title: deedDetailVC.textView.text, date: Date())
            
            // Will crash if newDeed is nil/not inserted properly, etc
            deeds.insert(newDeed!, at: 0)
        } else if (segue.identifier == "doneSortingSegue") {
            
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
        
        switch ViewController.timeSection {
            case "Day":
                self.sections = DaySection.group(deeds: deeds)
            case "Week":
                self.sections = WeekSection.group(deeds: deeds)
            case "Month":
                self.sections = MonthSection.group(deeds: deeds)
            case "Year":
                self.sections = YearSection.group(deeds: deeds)
            default:
                self.sections = MonthSection.group(deeds: deeds)
        }
        
        self.sections.sort { (lhs, rhs) in lhs.date > rhs.date }
    }
    
    func updateSections() {
        splitSections()
        updateDeedsLabel()
    }
    
    func updateDeedsLabel() {
        Animations.changeLabelNumberWithPop(forLabel: totalDeedsLabel, withNewNumber: deeds.count, duration: 0.4)
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
        cdm.save()
    }
    
    // Provides default value if no request is sent
    func loadDeeds(with request: NSFetchRequest<Deed> = Deed.fetchRequest()) {
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        deeds = cdm.fetchDeeds(with: request)
        updateSections()

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
        
        let editContextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let evc = storyboard.instantiateViewController(withIdentifier: "EditDeedViewController") as! EditDeedViewController
            
            evc.delegate = self
            
            evc.oldText = self.deeds[indexPath.row].title!
            
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
        
        deeds[editedIndexPath.row].title = editedDeedText

        editedDeedText = ""
        editedIndexPath = nil
        
        saveDeeds()
        updateSections()
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerFont.pointSize + 18
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
       header.textLabel?.font = headerFont
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
        let whiteRoundedViewTag = WhiteRoundedView.tag
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deedCell", for: indexPath) as! DeedTableViewCell
        
        cell.contentView.viewWithTag(whiteRoundedViewTag)?.removeFromSuperview()
        
        let section = self.sections[indexPath.section]
        let deed = section.deeds[indexPath.row]
        
        cell.deedDescriptionLabel.text = deed.title
        cell.deedDescriptionLabel.sizeToFit()
        
        let whiteRoundedViewHeight = cell.deedDescriptionLabel.frame.height + 20
                
        let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: whiteRoundedViewHeight))
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
                                
        return cell
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
