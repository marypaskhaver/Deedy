//
//  DeedDetailViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class DeedDetailViewController: UIViewController {

    @IBOutlet weak var deedTF: UITextView!
    
    var deed: Deed!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        deedTF.layer.borderWidth = 1
        deedTF.layer.cornerRadius = 8
        deedTF.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneAddingSegue" {
            deed = Deed(withDesc: deedTF.text!)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "doneAddingSegue") {
            let possibleDeed = Deed(withDesc: deedTF.text!)
            
            if (possibleDeed.description.trimmingCharacters(in: .whitespaces).isEmpty)  {
                self.performSegue(withIdentifier: "cancelAddingSegue", sender: Any?.self)
                return false
            }
        }
        
        return true
    }

}
