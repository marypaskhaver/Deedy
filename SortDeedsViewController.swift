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
    }
    
    // Do any additional setup after loading the view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sortSegue" {
            
        }
    }
    
}
