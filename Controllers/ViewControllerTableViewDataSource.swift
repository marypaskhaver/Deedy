//
//  ViewControllerTableViewDataSource.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/29/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerTableViewDataSource: NSObject, UITableViewDataSource {
    var deeds = [Deed]()
    var sections = [TimeSection]()
    var view: UIView
    
    let cdm = CoreDataManager()
    
    init(withView view: UIView) {
        self.view = view
        super.init()
        
        let request: NSFetchRequest<Deed> = Deed.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
        deeds = cdm.fetchDeeds(with: request)
        splitSections()
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
        
        CellCustomizer.customizeDeedCell(cell: cell, withNewText: deed.title!, view: view)
                                
        return cell
    }

    func addDeed(title: String, date: Date) {
        deeds.insert(cdm.insertDeed(title: title, date: date)!, at: 0)
        splitSections()
    }
    
    func saveDeeds() {
        cdm.save()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.sections.isEmpty {
            return nil
        }
        
        let section = sections[section]
        let date = section.date
            
        if (ViewController.timeSection == "Week") {
            return "Week of " + ViewController.dateFormatter.string(from: date);
        }
        
        return ViewController.dateFormatter.string(from: date)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty {
            return 0
        }

        return sections.count
    }
    
    func splitSections() {
        switch ViewController.timeSection {
            case "Day":
                sections = DaySection.group(deeds: deeds)
            case "Week":
                sections = WeekSection.group(deeds: deeds)
            case "Month":
                sections = MonthSection.group(deeds: deeds)
            case "Year":
                sections = YearSection.group(deeds: deeds)
            default:
                sections = MonthSection.group(deeds: deeds)
        }
        
        sections.sort { (lhs, rhs) in lhs.date > rhs.date }
    }
   
}
