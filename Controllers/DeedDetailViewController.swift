//
//  DeedDetailViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class DeedDetailViewController: UIViewController {

    @IBOutlet weak var textView: TextViewForDeedEntry!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneAddingSegue" {
            textView.text = textView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "doneAddingSegue") {
            if (textView.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)  {
                self.performSegue(withIdentifier: "cancelAddingSegue", sender: Any?.self)
                return false
            }
        }
        
        return true
    }

}
