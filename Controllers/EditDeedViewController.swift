//
//  EditDeedViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/18/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

protocol DataEnteredDelegateProtocol {
    func userEditedDeed(newDeedTitle: String)
}

class EditDeedViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var delegate: DataEnteredDelegateProtocol? = nil
    var oldText: String = ""
    @IBOutlet weak var invalidInputWarningLabel: UILabel!
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let trimmedText: String = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if (trimmedText.count == 0) {
            invalidInputWarningLabel.isHidden = false
        } else {
            delegate?.userEditedDeed(newDeedTitle: trimmedText)
            presentingViewController?.dismiss(animated: true, completion:nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.gray.cgColor
        
        textView.text = oldText
        invalidInputWarningLabel.isHidden = true
    }

}
