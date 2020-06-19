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
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.userEditedDeed(newDeedTitle: textView.text)
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.gray.cgColor
    }

}
