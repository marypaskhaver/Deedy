//
//  PickerView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/9/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

protocol PickerViewProtocol {
    func pickerDidSelectRow(selectedRowValue: String)
}

class PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerList: [String] = []
    var pickerListItem: String!
    var propertyThatReferencesThisViewController: PickerViewProtocol?
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Tell ViewController item was selected
        propertyThatReferencesThisViewController?.pickerDidSelectRow(selectedRowValue: pickerList[row])
        return pickerList[row]
    }

}

