//
//  ViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var deeds = [Deed]()
    var sections = [TimeSection]()
    static var timeSection: String = "Month"

    static let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        deeds = []
        updateSections()
        ViewController.dateFormatter.dateFormat = "MMMM yyyy"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) {

    }
    
    // Add deed
    @IBAction func done(segue: UIStoryboardSegue) {
        let _ = self.view
        
        if (segue.identifier == "doneAddingSegue") {
            let deedDetailVC = segue.source as! DeedDetailViewController
            let newDeed = Deed(withDesc: deedDetailVC.deed.description)
            
            deeds.append(newDeed)
        } else if (segue.identifier == "doneSortingSegue") {
            
        }
        
        updateSections()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.sections[indexPath.section].deeds.remove(at: indexPath.row)
            
            deeds.remove(at: indexPath.row)
            updateDeedsLabel()
            
            if self.sections[indexPath.section].deeds.count == 0 {
                self.sections.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .automatic)
                
                updateSections()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
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
        
        cell.deedDescriptionLabel.text = deed.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = section.date
        
        if (ViewController.timeSection == "Week") {
            return "Week of " + ViewController.dateFormatter.string(from: date);
        }
        
        return ViewController.dateFormatter.string(from: date)
    }
    
    func splitSections() {
        if (ViewController.timeSection == "Day") {
            self.sections = DaySection.group(deeds: self.deeds)
        } else if (ViewController.timeSection == "Week") {
            self.sections = WeekSection.group(deeds: self.deeds)
        } else if (ViewController.timeSection == "Month") {
            self.sections = MonthSection.group(deeds: self.deeds)
        } else if (ViewController.timeSection == "Year") {
            self.sections = YearSection.group(deeds: self.deeds)
        }
        
        self.sections.sort { (lhs, rhs) in lhs.date < rhs.date }
    }
    
    func updateSections() {
        splitSections()
        updateDeedsLabel()
    }
    
    func updateDeedsLabel() {
        totalDeedsLabel.text = String(deeds.count)
    }
    
    static func changeDateFormatter(toOrderBy dateFormat: String, timeSection: String) {
        dateFormatter.dateFormat = dateFormat
        ViewController.timeSection = timeSection
    }
    
}
