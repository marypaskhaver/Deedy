//
//  SortDeedsViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/9/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class SortDeedsViewController: UIViewController {
    
    var pickerListItem: String!
    var pickerItems: [String]!
    var myPickerView: PickerView! // Custom class
    
    @IBOutlet weak var interfacePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerItems = [
            "Day",
            "Week",
            "Month",
            "Year"
        ]
        
        myPickerView = PickerView()
        myPickerView.pickerList = pickerItems
        
        interfacePickerView.delegate = myPickerView
        interfacePickerView.dataSource = myPickerView
        myPickerView.propertyThatReferencesThisViewController = self
        
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension SortDeedsViewController: PickerViewProtocol {
    func pickerDidSelectRow(selectedRowValue: String) {
        pickerListItem = selectedRowValue
        
        let dateFormat = getDateFormatFromPickerListItem(pickerListItem: pickerListItem)
        
        DisplayDeedsViewController.changeDateFormatter(toOrderBy: dateFormat, timeSection: pickerListItem)
        saveSortDetails(forDateFormat: dateFormat, timeSection: pickerListItem)
    }
    
    func getDateFormatFromPickerListItem(pickerListItem: String) -> String {
        var dateFormat: String
        
        switch pickerListItem {
            case "Day":
                dateFormat = DaySection.dateFormat
                break
            case "Week":
                dateFormat = WeekSection.dateFormat
                break
            case "Month":
                dateFormat = MonthSection.dateFormat
                break
            case "Year":
                dateFormat = YearSection.dateFormat
                break
            default:
                dateFormat = MonthSection.dateFormat
        }
        
        return dateFormat
    }
    
    func saveSortDetails(forDateFormat dateFormat: String, timeSection: String) {
        defaults.set(dateFormat, forKey: UserDefaultsKeys.dateFormat)
        defaults.set(timeSection, forKey: UserDefaultsKeys.timeSection)
    }

}
