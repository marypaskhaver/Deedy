//
//  EditDeedViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/18/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

protocol DeedEditedDelegateProtocol {
    func userEditedDeed(newDeedTitle: String)
}

class EditDeedViewController: UIViewController {

    @IBOutlet weak var textView: TextViewForDeedEntry!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var invalidInputWarningLabel: UILabel!

    var delegate: DeedEditedDelegateProtocol? = nil
    
    var oldText: String = "" // What will be in the textView when this view controller is presented
        
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let trimmedText: String = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (trimmedText.count == 0) {
            invalidInputWarningLabel.isHidden = false
        } else {
            delegate?.userEditedDeed(newDeedTitle: trimmedText)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent user from swiping it down
        self.isModalInPresentation = true

        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            topView.backgroundColor = navBarColor
        } else {
            topView.backgroundColor = CustomColors.defaultBlue
        }
        
        var height = self.navigationController?.navigationBar.frame.height ?? 88.0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            height += 24
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            height += 20
        }
        
        topView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
        
        textView.text = oldText
        
        invalidInputWarningLabel.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
            
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
