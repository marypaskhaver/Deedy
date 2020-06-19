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
    var doneButtonWasPressed = false
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print("done button pressed (received in EditDeedViewController)")
        delegate?.userEditedDeed(newDeedTitle: textView.text)
        print("told delegate")
        doneButtonWasPressed = true
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.gray.cgColor
    }

}
