//
//  AddDeedViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class AddDeedViewController: UIViewController {

    @IBOutlet weak var textView: TextViewForDeedEntry!
    @IBOutlet weak var invalidInputWarningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        invalidInputWarningLabel.isHidden = true
        
        navigationController?.navigationBar.shadowImage = UIImage()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneAddingSegue" {
            textView.text = textView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "doneAddingSegue") {
            if (textView.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)  {
                invalidInputWarningLabel.isHidden = false

                return false
            }
        }
        
        return true
    }

}
