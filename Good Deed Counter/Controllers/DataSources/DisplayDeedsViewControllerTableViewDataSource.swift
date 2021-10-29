//
//  DisplayDeedsViewControllerTableViewDataSource.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/29/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit
import CoreData

class DisplayDeedsViewControllerTableViewDataSource: NSObject, UITableViewDataSource {
    var deeds = [Deed]()
    var sections = [TimeSection]()
    var view: UIView
    var isShowingTutorial: Bool = false
    var cdm = CoreDataManager()
    
    init(withView view: UIView) {
        self.view = view
        super.init()
        
        loadDeeds()
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
        
        if isShowingTutorial {
            cell.isHidden = true
        }

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
        // Do not put a header on the tableView if no deeds have been completed.
        if self.sections.isEmpty {
            return nil
        }
        
        let section = sections[section]
        let date = section.date
        
        // Usually, use the dateFormat of the TimeSection to format headers. However, if the time section is a week, instead of showing the first day of the week, preface the header w/ "Week of."
        if (DisplayDeedsViewController.timeSection == "Week") {
            return "Week of " + DisplayDeedsViewController.dateFormatter.string(from: date)
        }
        
        return DisplayDeedsViewController.dateFormatter.string(from: date)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // If no deeds have been completed or a tutorial is being shown, do not load any deeds; do not have any sections.
        if sections.isEmpty || isShowingTutorial {
            return 0
        }

        return sections.count
    }
    
    func splitSections() {
        // Depending on which way the user has decided to split deeds up, split the deeds with TimeSection .group methods. Each section has a deeds property (array) that holds deeds completed on that day / week / month / year-- whatever the TimeSection is.
        switch DisplayDeedsViewController.timeSection {
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
        
        // Sort deeds reverse-chronologically; i.e. the most recent deeds show up first and the deeds done long ago show up last.
        sections.sort { (lhs, rhs) in lhs.date > rhs.date }
    }
    
    // Sets self.deeds to hold user's deeds, with a default request if needed.
    func loadDeeds(with request: NSFetchRequest<Deed> = Deed.fetchRequest()) {
        // Sort fetched deeds by date.
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Set self.deeds to deeds fetched with custom or default request.
        self.deeds = cdm.fetchDeeds(with: request)
        
        // Place deeds into sections based on their date and the user's selected timeSection (the way they wish to split them).
        splitSections()
    }
   
}
