//
//  SortDeedsViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/9/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class SortDeedsViewController: UIViewController, PickerViewProtocol {
    
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
    }
    
    func pickerDidSelectRow(selectedRowValue: String) {
        pickerListItem = selectedRowValue
        
        var dateFormat: String
        
        switch pickerListItem {
        case "Day":
                dateFormat = "dd MMMM yyyy" // Move these to xSection classes?
                break
            case "Week":
                dateFormat = "dd MMMM yyyy"
                break
            case "Month":
                dateFormat = "MMMM yyyy"
                break
            case "Year":
                dateFormat = "yyyy"
                break
            default:
                //Month
                dateFormat = "MMMM yyyy"
        }
        
        ViewController.changeDateFormatter(toOrderBy: dateFormat, timeSection: pickerListItem)
    }
    
    // Do any additional setup after loading the view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sortSegue" {
            
        }
    }
    
}
