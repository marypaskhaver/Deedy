//
//  AddDeedViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class AddDeedViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: TextViewForDeedEntry!
    @IBOutlet weak var invalidInputWarningLabel: UILabel!
    
    let placeholderText = "I am " + TextFileReader().returnRandomLineFromFile(withName: "placeholder_adjs") + " and today I..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initially, hide invalidInputWarningLabel that shows up underneath the textView if invalid data is entered (empty text or is equal to placeholder text).
        invalidInputWarningLabel.isHidden = true
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Create "placeholder"
        textView.text = placeholderText
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil 
            textView.textColor = (self.traitCollection.userInterfaceStyle == .dark) ? UIColor.white : UIColor.black
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneAddingSegue" {
            textView.text = textView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Don't perform segue if textView contains just white space and line breaks or if the user didn't type anything and deed is thus equal to placeholderText
        if (identifier == "doneAddingSegue") {
            if (textView.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) || textView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == placeholderText {
                invalidInputWarningLabel.isHidden = false

                return false
            }
        }
        
        return true
    }

}
