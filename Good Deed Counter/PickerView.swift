//
//  PickerView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/9/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

// Set up protocol; classes that implement this must create a pickerDidSelectRow func.
protocol PickerViewProtocol {
    func pickerDidSelectRow(selectedRowValue: String)
}

class PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerList: [String] = []
    var pickerListItem: String!
    var propertyThatReferencesThisViewController: PickerViewProtocol?
    let labelFontSize = CGFloat(24.0)
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return labelFontSize + 8.0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Tell DisplayDeedsViewController item was selected
        propertyThatReferencesThisViewController?.pickerDidSelectRow(selectedRowValue: pickerList[row])

        return pickerList[row]
    }

}

