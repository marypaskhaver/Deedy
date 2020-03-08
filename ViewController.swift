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
    var sections = [MonthSection]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalDeedsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
                deeds = []
//        deeds = [Deed(withDesc: "Helped Mom"), Deed(withDesc: "Cooked")]
        
        updateSections()
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        let deedDetailVC = segue.source as! DeedDetailViewController
        let newDeed = Deed(withDesc: deedDetailVC.deed.description)
        
        deeds.append(newDeed)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "deedCell", for: indexPath)
        
        let section = self.sections[indexPath.section]
        let deed = section.deeds[indexPath.row]
        cell.textLabel?.text = deed.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sections.isEmpty) {
            print("Empty")
            return ""
        }
        
        let section = self.sections[section]
        let date = section.month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func updateSections() {
        self.sections = MonthSection.group(deeds: self.deeds)
        self.sections.sort { (lhs, rhs) in lhs.month < rhs.month }
        updateDeedsLabel()
    }
    
    func updateDeedsLabel() {
        totalDeedsLabel.text? = String(deeds.count)
    }
    
}
