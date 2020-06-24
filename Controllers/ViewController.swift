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

class ViewController: UIViewController, DeedEditedDelegateProtocol {
    
    var deeds = [Deed]()
    var sections = [TimeSection]()
    static var timeSection: String = "Month"
    
    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
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
        
        topView.backgroundColor = UIColor.white
        
        if self.traitCollection.userInterfaceStyle == .dark {
            topView.backgroundColor = UIColor.black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navBarColor = defaults.color(forKey: "navBarColor") {
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            navBarColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

            if b > 0.75 {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
            } else {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
            }
        } else {
            let navBarColor = SettingsViewController.navBarColor
            
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            navBarColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

            if b > 0.75 {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
            } else {
                view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 1.8, alpha: a)
            }
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
            
            let newDeed = Deed(context: context)
            newDeed.title = deedDetailVC.textView.text
            newDeed.date = Date()
                                       
            deeds.insert(newDeed, at: 0)
        } else if (segue.identifier == "doneSortingSegue") {
            
        }
        
        self.saveDeeds()
        
        // Add update GlobalViewController here
        tableView.reloadData()
    }
    
    @IBAction func scrollUpButtonPressed(_ sender: UIBarButtonItem) {
        tableView.setContentOffset(.zero, animated: true)
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
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.totalDeedsLabel.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            self.totalDeedsLabel.text = String(self.deeds.count)
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.totalDeedsLabel.transform = .identity
            })
        }
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
        }
        
        // Green
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
        let whiteRoundedViewTag = 1
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deedCell", for: indexPath) as! DeedTableViewCell
        
        cell.contentView.viewWithTag(whiteRoundedViewTag)?.removeFromSuperview()
        
        let section = self.sections[indexPath.section]
        let deed = section.deeds[indexPath.row]
        
        cell.deedDescriptionLabel.text = deed.title
        cell.deedDescriptionLabel.sizeToFit()
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedViewHeight = cell.deedDescriptionLabel.frame.height + 20
                
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: whiteRoundedViewHeight))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        
        if self.traitCollection.userInterfaceStyle == .dark {
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 0.9])
            whiteRoundedView.layer.borderWidth = 1
            whiteRoundedView.layer.borderColor = UIColor.white.cgColor
        }
        
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        whiteRoundedView.tag = whiteRoundedViewTag;
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
                                
        return cell
    }
    
    // Animate cells here
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

        UIView.animate(
            withDuration: 1,
            delay: 0.1 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
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
